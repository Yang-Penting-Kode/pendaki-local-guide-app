class ChartDataPoint {
  final String label;
  final double value;
  final bool isHighlighted;

  const ChartDataPoint({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });
}

class IncomeAnalyticsModel {
  final String timeframeLabel;
  final String totalBalance;
  final String growthPercentage;
  final String grossIncome;
  final String adminFee;
  final String netIncome;
  final List<ChartDataPoint> chartPoints;

  const IncomeAnalyticsModel({
    required this.timeframeLabel,
    required this.totalBalance,
    required this.growthPercentage,
    required this.grossIncome,
    required this.adminFee,
    required this.netIncome,
    required this.chartPoints,
  });
}
