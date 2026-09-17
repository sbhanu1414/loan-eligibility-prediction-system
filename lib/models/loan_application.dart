class LoanApplication {
  final double annualIncome;
  final double monthlyIncome;
  final double existingEMI;
  final int creditScore;
  final String existingLoans;
  final String employmentDuration;
  final String loanType;
  final double requestedAmount;
  final String loanTenure;
  final String loanPurpose;

  const LoanApplication({
    this.annualIncome = 0,
    this.monthlyIncome = 0,
    this.existingEMI = 0,
    this.creditScore = 0,
    this.existingLoans = 'None',
    this.employmentDuration = '',
    this.loanType = '',
    this.requestedAmount = 0,
    this.loanTenure = '',
    this.loanPurpose = '',
  });

  /// Alias for backward compatibility with screens using `existingMonthlyEmi`
  double get existingMonthlyEmi => existingEMI;

  /// Alias for backward compatibility with screens using `loanAmount`
  double get loanAmount => requestedAmount;

  LoanApplication copyWith({
    double? annualIncome,
    double? monthlyIncome,
    double? existingEMI,
    int? creditScore,
    String? existingLoans,
    String? employmentDuration,
    String? loanType,
    double? requestedAmount,
    String? loanTenure,
    String? loanPurpose,
  }) {
    return LoanApplication(
      annualIncome: annualIncome ?? this.annualIncome,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      existingEMI: existingEMI ?? this.existingEMI,
      creditScore: creditScore ?? this.creditScore,
      existingLoans: existingLoans ?? this.existingLoans,
      employmentDuration: employmentDuration ?? this.employmentDuration,
      loanType: loanType ?? this.loanType,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      loanTenure: loanTenure ?? this.loanTenure,
      loanPurpose: loanPurpose ?? this.loanPurpose,
    );
  }

  factory LoanApplication.demo() {
    return const LoanApplication(
      annualIncome: 800000.0,
      monthlyIncome: 66667.0,
      existingEMI: 12000.0,
      creditScore: 742,
      existingLoans: 'Personal Loan',
      employmentDuration: '3 Years',
      loanType: 'Business Loan',
      requestedAmount: 1500000.0,
      loanTenure: '5 Years',
      loanPurpose: 'Business Expansion',
    );
  }
}
