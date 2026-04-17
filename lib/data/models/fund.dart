enum FundCategory {
  mmf,
  equity,
  fif,
  spf,
  bal;

  String get code => switch (this) {
        FundCategory.mmf    => 'MMF',
        FundCategory.equity => 'EQUITY',
        FundCategory.fif    => 'FIF',
        FundCategory.spf    => 'SPF',
        FundCategory.bal    => 'BAL',
      };

  String get displayName => switch (this) {
        FundCategory.mmf    => 'Money Market',
        FundCategory.equity => 'Equity',
        FundCategory.fif    => 'Fixed Income',
        FundCategory.spf    => 'Special',
        FundCategory.bal    => 'Balanced',
      };
}

class Fund {
  const Fund({
    required this.id,
    this.name,
    this.code,
    this.category,
    this.managerId,
    this.managerName,
    this.aum,
    this.navPerUnit,
    this.managementFee,
    this.minimumInvestment,
    this.riskLevel,
    this.inceptionDate,
    this.isActive,
    this.return1m,
    this.return3m,
    this.return6m,
    this.return1y,
    this.return3y,
  });

  final int id;
  final String? name;
  final String? code;
  final String? category;
  final int? managerId;
  final String? managerName;
  final double? aum;
  final double? navPerUnit;
  final double? managementFee;
  final double? minimumInvestment;
  final String? riskLevel;
  final String? inceptionDate;
  final bool? isActive;
  final double? return1m;
  final double? return3m;
  final double? return6m;
  final double? return1y;
  final double? return3y;

  factory Fund.fromJson(Map<String, dynamic> j) {
    // The list endpoint returns flat fields; the detail endpoint has nested
    // `manager` and `category` objects. Handle both gracefully.
    final mgr = j['manager'] as Map<String, dynamic>?;
    final cat = j['category'] as Map<String, dynamic>?;

    return Fund(
      id: j['id'] as int,
      name: (j['fund_name'] ?? j['name']) as String?,
      code: (j['fund_code'] ?? j['code']) as String?,
      category: (j['category_name'] ?? cat?['name'] ?? j['category_code'] ?? cat?['code']) as String?,
      managerId: (j['fund_manager_id'] ?? j['manager_id']) as int?,
      managerName: (j['manager_name'] ?? mgr?['short_name'] ?? mgr?['name']) as String?,
      aum: ((j['latest_aum'] ?? j['current_fund_size'] ?? j['aum']) as num?)?.toDouble(),
      navPerUnit: (j['nav_per_unit'] as num?)?.toDouble(),
      managementFee: (j['management_fee'] as num?)?.toDouble(),
      minimumInvestment: (j['minimum_investment'] as num?)?.toDouble(),
      riskLevel: (j['risk_level'] ?? cat?['risk_level']) as String?,
      inceptionDate: j['inception_date'] as String?,
      isActive: j['is_active'] as bool?,
      return1m: (j['return_1m'] as num?)?.toDouble(),
      return3m: (j['return_3m'] as num?)?.toDouble(),
      return6m: (j['return_6m'] as num?)?.toDouble(),
      return1y: (j['return_1y'] as num?)?.toDouble(),
      return3y: (j['return_3y'] as num?)?.toDouble(),
    );
  }
}
