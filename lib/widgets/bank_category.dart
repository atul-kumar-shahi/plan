import 'package:flutter/material.dart';
import 'package:plan/models/bank_data.dart';

class BankCategoryWidget extends StatelessWidget {
  final List<AccountBalance> bankAccounts;
  final VoidCallback onTap;
  final bool isExpanded;

  const BankCategoryWidget({
    super.key,
    required this.bankAccounts,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    double total = bankAccounts.fold(0, (sum, account) => sum + account.total);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xffEDEDED),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.account_balance_outlined,
                            size: 20),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bank Accounts',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Total: ₹${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                color: Color(0xff6B6B6B),
                              )),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Column(
                children: bankAccounts
                    .map(
                      (account) => Container(
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            bottom:
                                BorderSide(color: Color(0xffEDEDED), width: 1),
                          ),
                        ),
                        child: ListTile(
                          title: Text(account.name,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                              )),
                          trailing: Text('₹${account.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                              )),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
