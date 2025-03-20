class RegexPatterns {
  static final bankRegex = RegExp(
    r'BOI|SBI|Bank of India|State Bank of India|Union Bank of India|Bank of Baroda|Punjab National Bank|HDFC Bank|ICICI Bank|YES BANK|AXIS Bank|Kotak Mahindra Bank|IndusInd Bank|IDBI Bank|Canara Bank|Central Bank of India|Indian Bank|UCO Bank|IDFC FIRST Bank',
  );

  static final walletRegex = RegExp(
    r'Paytm Wallet|PhonePe Wallet|Google Pay Wallet',
  );

  static final balanceRegex = RegExp(r'Avl Bal Rs[.:]([\d,]+\.\d{2})');

  static final accountNumberRegex = RegExp(r'A/c \*(\d{4})');
}
