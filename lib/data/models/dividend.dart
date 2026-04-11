class Dividend {
  const Dividend({
    this.symbol,
    this.exDate,
    this.paymentDate,
    this.amount,
    this.type,
    this.currency,
  });

  final String? symbol;
  final String? exDate;
  final String? paymentDate;
  final double? amount;
  final String? type;
  final String? currency;

  factory Dividend.fromJson(Map<String, dynamic> j) => Dividend(
        symbol: j['symbol'] as String?,
        exDate: j['ex_date'] as String?,
        paymentDate: j['payment_date'] as String?,
        amount: (j['amount'] as num?)?.toDouble(),
        type: j['type'] as String?,
        currency: j['currency'] as String?,
      );
}
