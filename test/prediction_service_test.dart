import 'package:flutter_test/flutter_test.dart';
import 'package:loan_eligibility/models/applicant.dart';
import 'package:loan_eligibility/models/loan_application.dart';
import 'package:loan_eligibility/screens/loan_details_screen.dart';
import 'package:loan_eligibility/services/prediction_service.dart';

void main() {
  group('PredictionService Tests', () {
    final service = MockPredictionService();

    test('Demo applicant and application yield an eligible prediction', () async {
      final applicant = Applicant.demo();
      final application = LoanApplication.demo();

      final result = await service.predict(applicant, application);

      expect(result.isEligible, isTrue);
      expect(result.probability, greaterThanOrEqualTo(0.55));
      expect(result.riskLevel, isIn(['Low', 'Medium']));
      expect(result.positiveFactors, isNotEmpty);
      expect(result.profileBreakdown, contains('Credit Profile'));
      expect(result.factorScores, contains('Credit Score'));
    });

    test('High risk applicant with low credit and high EMI burden is not eligible', () async {
      const applicant = Applicant(
        fullName: 'Test Applicant',
        age: 22,
        employmentType: 'Student',
        education: 'Undergraduate',
        numberOfDependents: 4,
        maritalStatus: 'Single',
      );

      const application = LoanApplication(
        annualIncome: 200000,
        monthlyIncome: 16000,
        existingEMI: 12000, // 75% EMI burden
        creditScore: 520,   // Poor credit score
        existingLoans: 'Multiple Loans',
        employmentDuration: '6 Months',
        loanType: 'Personal Loan',
        requestedAmount: 1000000, // 5x annual income
        loanTenure: '3 Years',
        loanPurpose: 'Personal Expenses',
      );

      final result = await service.predict(applicant, application);

      expect(result.isEligible, isFalse);
      expect(result.probability, lessThan(0.55));
      expect(result.riskLevel, equals('High'));
      expect(result.concerns, isNotEmpty);
    });
  });

  group('Indian Currency Formatter Tests', () {
    test('Formats various Indian Rupee amounts correctly', () {
      expect(formatCurrency(800000), equals('₹8,00,000'));
      expect(formatCurrency(1500000), equals('₹15,00,000'));
      expect(formatCurrency(12000), equals('₹12,000'));
      expect(formatCurrency(66667), equals('₹66,667'));
      expect(formatCurrency(0), equals('₹0'));
    });
  });

  group('Model Demo Factory Tests', () {
    test('Applicant.demo contains specified presentation values', () {
      final demo = Applicant.demo();
      expect(demo.fullName, equals('Bhanu Pratap'));
      expect(demo.age, equals(24));
      expect(demo.employmentType, equals('Salaried'));
      expect(demo.education, equals('Graduate'));
      expect(demo.numberOfDependents, equals(2));
      expect(demo.maritalStatus, equals('Married'));
    });

    test('LoanApplication.demo contains specified presentation values', () {
      final demo = LoanApplication.demo();
      expect(demo.annualIncome, equals(800000.0));
      expect(demo.monthlyIncome, equals(66667.0));
      expect(demo.existingEMI, equals(12000.0));
      expect(demo.creditScore, equals(742));
      expect(demo.existingLoans, equals('Personal Loan'));
      expect(demo.requestedAmount, equals(1500000.0));
      expect(demo.loanType, equals('Business Loan'));
      expect(demo.loanTenure, equals('5 Years'));
    });
  });
}
