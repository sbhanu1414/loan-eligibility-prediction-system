import 'package:loan_eligibility/models/applicant.dart';
import 'package:loan_eligibility/models/loan_application.dart';
import 'package:loan_eligibility/models/prediction_result.dart';

abstract class PredictionService {
  Future<PredictionResult> predict(Applicant applicant, LoanApplication application);
}

class MockPredictionService implements PredictionService {
  @override
  Future<PredictionResult> predict(Applicant applicant, LoanApplication application) async {
    // Simulate realistic inference delay for decision support
    await Future.delayed(const Duration(milliseconds: 1800));

    // TODO: Replace mock prediction with trained ML model/API.
    
    // 1. Credit score evaluation (Weight: 30%)
    double creditScoreValue = 0.0;
    if (application.creditScore >= 750) {
      creditScoreValue = 100.0;
    } else if (application.creditScore >= 700) {
      creditScoreValue = 85.0;
    } else if (application.creditScore >= 650) {
      creditScoreValue = 70.0;
    } else if (application.creditScore >= 580) {
      creditScoreValue = 50.0;
    } else {
      creditScoreValue = 30.0;
    }
    
    // 2. Income to loan ratio (Weight: 25%)
    // Annual income vs requested loan amount
    final double reqAmount = application.requestedAmount > 0 ? application.requestedAmount : 1.0;
    final double incomeLoanRatio = application.annualIncome / reqAmount;
    double incomeLoanValue = 0.0;
    if (incomeLoanRatio >= 0.6) {
      incomeLoanValue = 100.0;
    } else if (incomeLoanRatio >= 0.45) {
      incomeLoanValue = 85.0;
    } else if (incomeLoanRatio >= 0.3) {
      incomeLoanValue = 70.0;
    } else if (incomeLoanRatio >= 0.2) {
      incomeLoanValue = 50.0;
    } else {
      incomeLoanValue = 35.0;
    }

    // 3. Existing Monthly EMI debt burden ratio (Weight: 15%)
    final double monthlyInc = application.monthlyIncome > 0 ? application.monthlyIncome : 1.0;
    final double emiBurdenRatio = application.existingEMI / monthlyInc;
    double emiBurdenValue = 0.0;
    if (emiBurdenRatio <= 0.20) {
      emiBurdenValue = 100.0;
    } else if (emiBurdenRatio <= 0.35) {
      emiBurdenValue = 80.0;
    } else if (emiBurdenRatio <= 0.50) {
      emiBurdenValue = 60.0;
    } else {
      emiBurdenValue = 30.0;
    }

    // 4. Employment stability and type (Weight: 15%)
    double employmentValue = 0.0;
    if (applicant.employmentType == 'Salaried') {
      employmentValue = 95.0;
    } else if (applicant.employmentType == 'Business Owner') {
      employmentValue = 85.0;
    } else if (applicant.employmentType == 'Self Employed') {
      employmentValue = 80.0;
    } else if (applicant.employmentType == 'Student') {
      employmentValue = 45.0;
    } else {
      employmentValue = 55.0;
    }

    // 5. Education background (Weight: 5%)
    double educationValue = 0.0;
    if (applicant.education == 'Post Graduate') {
      educationValue = 100.0;
    } else if (applicant.education == 'Graduate') {
      educationValue = 85.0;
    } else if (applicant.education == 'Undergraduate') {
      educationValue = 70.0;
    } else {
      educationValue = 55.0;
    }

    // 6. Number of Dependents (Weight: 10%)
    double dependentsValue = 0.0;
    if (applicant.numberOfDependents <= 1) {
      dependentsValue = 100.0;
    } else if (applicant.numberOfDependents <= 2) {
      dependentsValue = 85.0;
    } else if (applicant.numberOfDependents <= 4) {
      dependentsValue = 65.0;
    } else {
      dependentsValue = 45.0;
    }

    // Weighted cumulative score
    final double weightedScore = (creditScoreValue * 0.30) + 
                                 (incomeLoanValue * 0.25) + 
                                 (emiBurdenValue * 0.15) + 
                                 (employmentValue * 0.15) + 
                                 (educationValue * 0.05) + 
                                 (dependentsValue * 0.10);

    final double probability = (weightedScore / 100.0).clamp(0.10, 0.98);
    final bool isEligible = probability >= 0.55;

    String riskLevel = 'High';
    if (probability >= 0.75) {
      riskLevel = 'Low';
    } else if (probability >= 0.55) {
      riskLevel = 'Medium';
    }

    final List<String> positiveFactors = [];
    final List<String> concerns = [];

    if (creditScoreValue >= 70) {
      positiveFactors.add('Strong credit profile');
    } else {
      concerns.add('Credit score below optimal benchmark (700+)');
    }

    if (incomeLoanValue >= 70) {
      positiveFactors.add('Stable income profile relative to loan size');
    } else {
      concerns.add('Requested amount relative to income is high');
    }

    if (emiBurdenValue >= 75) {
      positiveFactors.add('Manageable existing monthly EMI obligations');
    } else {
      concerns.add('Existing monthly debt commitments are high');
    }

    if (employmentValue >= 80) {
      positiveFactors.add('Favorable employment background');
    } else {
      concerns.add('Employment category carries higher risk evaluation');
    }

    final Map<String, String> profileBreakdown = {
      'Credit Profile': creditScoreValue >= 75 ? 'Strong' : (creditScoreValue >= 60 ? 'Good' : 'Moderate'),
      'Income Profile': incomeLoanValue >= 75 ? 'Good' : 'Moderate',
      'Existing Debt': emiBurdenValue >= 75 ? 'Low' : 'Moderate',
      'Loan Amount': incomeLoanRatio >= 0.4 ? 'Moderate' : 'High',
      'Employment Stability': employmentValue >= 80 ? 'Good' : 'Moderate',
    };

    final Map<String, double> factorScores = {
      'Credit Score': creditScoreValue,
      'Annual Income': incomeLoanValue,
      'Existing Debt': emiBurdenValue,
      'Employment Type': employmentValue,
      'Education': educationValue,
      'Dependents': dependentsValue,
    };

    final String recommendation = isEligible 
      ? 'Applicant appears suitable for initial eligibility based on the provided information. Final approval requires document verification and bank credit assessment.'
      : 'Applicant does not meet the primary automated screening threshold. Consider reducing the requested loan amount or adding a creditworthy co-applicant.';

    return PredictionResult(
      isEligible: isEligible,
      probability: probability,
      riskLevel: riskLevel,
      positiveFactors: positiveFactors,
      concerns: concerns,
      recommendation: recommendation,
      profileBreakdown: profileBreakdown,
      factorScores: factorScores,
      assessmentDate: DateTime.now(),
    );
  }
}

