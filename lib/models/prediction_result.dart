class PredictionResult {
  final bool isEligible;
  final double probability;
  final String riskLevel;
  final List<String> positiveFactors;
  final List<String> concerns;
  final String recommendation;
  final Map<String, String> profileBreakdown;
  final Map<String, double> factorScores;
  final DateTime assessmentDate;

  const PredictionResult({
    required this.isEligible,
    required this.probability,
    required this.riskLevel,
    required this.positiveFactors,
    required this.concerns,
    required this.recommendation,
    required this.profileBreakdown,
    required this.factorScores,
    required this.assessmentDate,
  });
}
