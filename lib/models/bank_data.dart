class AccountBalance {
  String name;
  double total;

  AccountBalance({required this.name, required this.total});

  Map<String, dynamic> toJson() => {
        'accountName': name,
        'balance': total,
      };

  static AccountBalance fromJson(Map<String, dynamic> json) => AccountBalance(
        name: json['accountName'],
        total: json['balance'],
      );
}

class ScanResult {
  double bankTotal;
  double walletTotal;
  List<AccountBalance> bankAccounts;
  List<AccountBalance> digitalWallets;

  ScanResult({
    required this.bankTotal,
    required this.walletTotal,
    required this.bankAccounts,
    required this.digitalWallets,
  });

  Map<String, dynamic> toJson() => {
        'bankTotal': bankTotal,
        'walletTotal': walletTotal,
        'bankAccounts': bankAccounts.map((a) => a.toJson()).toList(),
        'digitalWallets': digitalWallets.map((a) => a.toJson()).toList(),
      };

  static ScanResult fromJson(Map<String, dynamic> json) => ScanResult(
        bankTotal: json['bankTotal'],
        walletTotal: json['walletTotal'],
        bankAccounts: (json['bankAccounts'] as List)
            .map((a) => AccountBalance.fromJson(a))
            .toList(),
        digitalWallets: (json['digitalWallets'] as List)
            .map((a) => AccountBalance.fromJson(a))
            .toList(),
      );
}

class Category {
  String name;
  double amount;
  String? parentCategoryName;
  List<Category> childCategories;

  Category({
    required this.name,
    required this.amount,
    this.parentCategoryName,
    List<Category>? childCategories,
  }) : this.childCategories = childCategories ?? [];

  Map<String, dynamic> toJson({bool isChild = false}) {
    return {
      'name': name,
      'amount': amount,
      'parentCategoryName': parentCategoryName,
      'childCategories':
          childCategories.map((child) => child.toJson(isChild: true)).toList(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Category> childCategories = (json['childCategories'] as List)
        .map((childJson) => Category.fromJson(childJson))
        .toList();

    return Category(
      name: json['name'],
      amount: json['amount'],
      parentCategoryName: json['parentCategoryName'],
      childCategories: childCategories,
    );
  }

  static List<Category> getInitialCategories() {
    return [
      Category(
        name: 'Investments',
        amount: 0,
        childCategories: [],
      ),
      Category(
        name: 'Digital Wallets',
        amount: 0,
        childCategories: [],
      ),
      Category(
        name: 'Cash',
        amount: 0,
        childCategories: [],
      ),
      Category(
        name: 'Lent',
        amount: 0,
        childCategories: [],
      ),
    ];
  }
}
