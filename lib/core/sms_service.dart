import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plan/core/regex_patterns.dart';
import 'package:plan/models/bank_data.dart';

class SMSService {
  final ValueNotifier<ScanResult?> scanResultNotifier =
      ValueNotifier<ScanResult?>(null);


  Future<ScanResult> parseMessagesAndCalculateBalance(
      List<SmsMessage> messages) async {
    Map<String, double> bankAccounts = {};
    Map<String, double> digitalWallets = {};

    for (var msg in messages) {
      String body = msg.body ?? '';
      var balanceMatch = RegexPatterns.balanceRegex.firstMatch(body);
      var accountNumberMatch = RegexPatterns.accountNumberRegex.firstMatch(body);
      var accountMatch =
          RegexPatterns.bankRegex.firstMatch(body) ?? RegexPatterns.walletRegex.firstMatch(body);

      if (balanceMatch != null &&
          accountNumberMatch != null &&
          accountMatch != null) {
        double amount =
            double.parse(balanceMatch.group(1)!.replaceAll(',', ''));
        String accountNumber = accountNumberMatch.group(1)!;
        String accountName = accountMatch.group(0)!;
        String uniqueAccountKey = '$accountName-$accountNumber';

        if (RegexPatterns.bankRegex.hasMatch(accountName)) {
          if (!bankAccounts.containsKey(uniqueAccountKey)) {
            bankAccounts[uniqueAccountKey] = amount;
          }
        }
      }
    }

    double bankTotal = bankAccounts.values.fold(0, (sum, value) => sum + value);
    double walletTotal =
        digitalWallets.values.fold(0, (sum, value) => sum + value);

    return ScanResult(
      bankTotal: bankTotal,
      walletTotal: walletTotal,
      bankAccounts: bankAccounts.entries
          .map((e) => AccountBalance(name: e.key, total: e.value))
          .toList(),
      digitalWallets: digitalWallets.entries
          .map((e) => AccountBalance(name: e.key, total: e.value))
          .toList(),
    );
  }

  Future<bool> requestPermissions() async {
    var smsStatus = await Permission.sms.status;

    if (!smsStatus.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.sms,
        Permission.storage,
      ].request();

      return statuses[Permission.sms]!.isGranted &&
          statuses[Permission.storage]!.isGranted;
    }

    return smsStatus.isGranted;
  }

  Future<void> scanIncomingMessages(BuildContext context) async {
    if (await requestPermissions()) {
      print('Permissions granted. Starting SMS query...');
      final smsQuery = SmsQuery();
      List<SmsMessage> messages =
          await smsQuery.querySms(kinds: [SmsQueryKind.inbox]);
      print('Total messages retrieved: ${messages.length}');

      final scanResult = await parseMessagesAndCalculateBalance(messages);

      final jsonString = jsonEncode(scanResult);

      // Using FlutterSecureStorage to store the scanResult securely
      final storage = FlutterSecureStorage();
      await storage.write(key: 'scanned_messages', value: jsonString);
      print('Scan result stored securely');

      // Notify listeners with the new scan result
      scanResultNotifier.value = scanResult;
    } else {
      print('Permissions not granted');
    }
  }

  Future<ScanResult?> retrieveScanResult() async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'scanned_messages');
    final jsonString2 = await storage.read(key: 'scanned_messages1');
    if (jsonString2 != null) {
      ScanResult scanResult = ScanResult.fromJson(jsonDecode(jsonString2));
      if (jsonString != null) {
        ScanResult scanResult2 = ScanResult.fromJson(jsonDecode(jsonString));
        for (int i = 0; i < scanResult2.bankAccounts.length; i++) {
          if (i >= scanResult.bankAccounts.length) {
            scanResult.bankAccounts.add(scanResult2.bankAccounts[i]);
            continue;
          }
          scanResult.bankAccounts[i].name = scanResult2.bankAccounts[i].name;
          scanResult.bankAccounts[i].total = scanResult2.bankAccounts[i].total;
        }
        double total = 0;
        for (var account in scanResult.bankAccounts) {
          total += account.total;
        }
        scanResult.bankTotal = total;
        return scanResult;
      }
      return scanResult;
    }
    if (jsonString != null) {
      return ScanResult.fromJson(jsonDecode(jsonString));
    }
    return null;
  }
}
