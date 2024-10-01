class DailySales {
  const DailySales({
    required this.totalSales,
    required this.dayOfTheWeek,
  });

  /// The primary amount or value of this entity.
  final int totalSales;

  /// The full displayable account number.
  final String dayOfTheWeek;
}
