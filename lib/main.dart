import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/applicant.dart';
import 'package:loan_eligibility/models/loan_application.dart';
import 'package:loan_eligibility/models/prediction_result.dart';
import 'package:loan_eligibility/screens/applicant_screen.dart';
import 'package:loan_eligibility/screens/assessment_details_screen.dart';
import 'package:loan_eligibility/screens/dashboard_screen.dart';
import 'package:loan_eligibility/screens/financial_screen.dart';
import 'package:loan_eligibility/screens/home_screen.dart';
import 'package:loan_eligibility/screens/loan_details_screen.dart';
import 'package:loan_eligibility/screens/processing_screen.dart';
import 'package:loan_eligibility/screens/result_screen.dart';
import 'package:loan_eligibility/services/prediction_service.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoanEligibilityApp());
}

enum AssessmentStep {
  applicant,
  financial,
  loanDetails,
  processing,
  result,
  assessmentDetails,
}

class LoanEligibilityApp extends StatelessWidget {
  const LoanEligibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Eligibility Prediction System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShellScreen(),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentNavIndex = 0;
  AssessmentStep _assessmentStep = AssessmentStep.applicant;

  Applicant? _applicant;
  LoanApplication? _application;
  PredictionResult? _predictionResult;

  final PredictionService _predictionService = MockPredictionService();

  void _navigateToTab(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }

  void _startNewAssessment() {
    setState(() {
      _currentNavIndex = 1;
      _assessmentStep = AssessmentStep.applicant;
      _applicant = null;
      _application = null;
      _predictionResult = null;
    });
  }

  void _loadFullDemoAndRun() async {
    final demoApplicant = Applicant.demo();
    final demoApp = LoanApplication.demo();

    setState(() {
      _currentNavIndex = 1;
      _applicant = demoApplicant;
      _application = demoApp;
      _assessmentStep = AssessmentStep.processing;
    });

    final res = await _predictionService.predict(demoApplicant, demoApp);
    if (mounted) {
      setState(() {
        _predictionResult = res;
      });
    }
  }

  Future<void> _executePrediction(LoanApplication completeApplication) async {
    setState(() {
      _application = completeApplication;
      _assessmentStep = AssessmentStep.processing;
    });

    final applicantToPredict = _applicant ?? Applicant.demo();
    final res = await _predictionService.predict(applicantToPredict, completeApplication);

    if (mounted) {
      setState(() {
        _predictionResult = res;
      });
    }
  }

  void _handleProcessingComplete() {
    if (_predictionResult != null) {
      setState(() {
        _assessmentStep = AssessmentStep.result;
      });
    } else {
      // If mock service took a moment longer, wait briefly
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _predictionResult != null) {
          setState(() {
            _assessmentStep = AssessmentStep.result;
          });
        }
      });
    }
  }

  Widget _buildAssessmentFlow() {
    switch (_assessmentStep) {
      case AssessmentStep.applicant:
        return ApplicantScreen(
          initialData: _applicant,
          onBack: () => _navigateToTab(0),
          onNext: (applicant) {
            setState(() {
              _applicant = applicant;
              _assessmentStep = AssessmentStep.financial;
            });
          },
          onLoadDemo: () {
            setState(() {
              _applicant = Applicant.demo();
            });
          },
        );

      case AssessmentStep.financial:
        return FinancialScreen(
          initialData: _application,
          onBack: () {
            setState(() {
              _assessmentStep = AssessmentStep.applicant;
            });
          },
          onNext: (partialApp) {
            setState(() {
              _application = partialApp;
              _assessmentStep = AssessmentStep.loanDetails;
            });
          },
          onLoadDemo: () {
            setState(() {
              _application = LoanApplication.demo();
            });
          },
        );

      case AssessmentStep.loanDetails:
        return LoanDetailsScreen(
          applicant: _applicant ?? Applicant.demo(),
          financialData: _application ?? const LoanApplication(),
          onBack: () {
            setState(() {
              _assessmentStep = AssessmentStep.financial;
            });
          },
          onCheckEligibility: _executePrediction,
          onLoadDemo: () {
            setState(() {
              _application = LoanApplication.demo();
            });
          },
        );

      case AssessmentStep.processing:
        return ProcessingScreen(
          onComplete: _handleProcessingComplete,
        );

      case AssessmentStep.result:
        if (_predictionResult == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ResultScreen(
          result: _predictionResult!,
          applicant: _applicant ?? Applicant.demo(),
          application: _application ?? LoanApplication.demo(),
          onViewDetails: () {
            setState(() {
              _assessmentStep = AssessmentStep.assessmentDetails;
            });
          },
          onNewAssessment: _startNewAssessment,
        );

      case AssessmentStep.assessmentDetails:
        if (_predictionResult == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return AssessmentDetailsScreen(
          result: _predictionResult!,
          onNewAssessment: _startNewAssessment,
        );
    }
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return HomeScreen(
          onStartAssessment: _startNewAssessment,
          onViewDashboard: () => _navigateToTab(2),
        );
      case 1:
        return _buildAssessmentFlow();
      case 2:
        return DashboardScreen(
          onStartNewAssessment: _startNewAssessment,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    final appBar = AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance,
              color: AppTheme.primaryNavy,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isDesktop ? 'Loan Eligibility Prediction System' : 'Loan Prediction ML',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.primaryNavy,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Tooltip(
            message: 'Screening prototype for academic project evaluation',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryNavy.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTheme.successGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Demo Mode',
                    style: TextStyle(
                      color: AppTheme.primaryNavy,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_currentNavIndex != 1 || _assessmentStep != AssessmentStep.applicant)
          TextButton.icon(
            onPressed: _startNewAssessment,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Reset'),
          ),
        const SizedBox(width: 8),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentNavIndex,
              onDestinationSelected: (idx) {
                if (idx == 1 && _currentNavIndex != 1) {
                  _startNewAssessment();
                } else {
                  _navigateToTab(idx);
                }
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.white,
              indicatorColor: AppTheme.primaryNavy.withValues(alpha: 0.12),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Icon(Icons.hub_outlined, color: AppTheme.primaryNavy, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'ML-Core',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryNavy,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: IconButton(
                      tooltip: 'Quick 1-Click Demo Evaluation',
                      icon: const Icon(Icons.bolt, color: AppTheme.warningOrange),
                      onPressed: _loadFullDemoAndRun,
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppTheme.primaryNavy),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment, color: AppTheme.primaryNavy),
                  label: Text('New Assessment'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryNavy),
                  label: Text('Dashboard'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (idx) {
          if (idx == 1 && _currentNavIndex != 1) {
            _startNewAssessment();
          } else {
            _navigateToTab(idx);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppTheme.primaryNavy),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppTheme.primaryNavy),
            label: 'Assessment',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryNavy),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
