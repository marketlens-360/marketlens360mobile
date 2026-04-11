class FundManager {
  const FundManager({
    required this.id,
    this.name,
    this.company,
    this.isActive,
    this.totalAum,
    this.fundsCount,
    this.averageReturn1y,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String? name;
  final String? company;
  final bool? isActive;
  final double? totalAum;
  final int? fundsCount;
  final double? averageReturn1y;
  final double? latitude;
  final double? longitude;

  factory FundManager.fromJson(Map<String, dynamic> j) => FundManager(
        id: j['id'] as int,
        name: j['name'] as String?,
        company: j['company'] as String?,
        isActive: j['is_active'] as bool?,
        totalAum: (j['total_aum'] as num?)?.toDouble(),
        fundsCount: j['funds_count'] as int?,
        averageReturn1y: (j['average_return_1y'] as num?)?.toDouble(),
        latitude: (j['latitude'] as num?)?.toDouble(),
        longitude: (j['longitude'] as num?)?.toDouble(),
      );
}
