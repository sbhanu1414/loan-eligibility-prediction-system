import 'package:flutter_test/flutter_test.dart';
import 'package:loan_eligibility/main.dart';

void main() {
  testWidgets('Loan Eligibility Prediction System initial load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoanEligibilityApp());

    // Verify that the title appears.
    expect(find.text('Loan Eligibility Prediction System'), findsAtLeastNWidgets(1));

    // Verify that the start button appears.
    expect(find.text('Start Assessment'), findsOneWidget);
  });
}

