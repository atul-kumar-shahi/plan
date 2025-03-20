import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future<void> write({required String key, required dynamic value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<dynamic> read({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }
}

final secureStorage = SecureStorage();
