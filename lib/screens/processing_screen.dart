import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

class ProcessingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const ProcessingScreen({super.key, required this.onComplete});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _currentStep = 0;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  void _startProcessing() {
    // Step 0 -> Step 1: 500ms
    _timers.add(Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _currentStep = 1);
    }));
    
    // Step 1 -> Step 2: 1100ms
    _timers.add(Timer(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() => _currentStep = 2);
    }));
    
    // Step 2 -> Step 3: 1700ms
    _timers.add(Timer(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _currentStep = 3);
    }));
    
    // Step 3 -> Step 4 (Model evaluation finalized): 2500ms
    _timers.add(Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _currentStep = 4);
    }));
    
    // Auto-navigate to result: 3000ms
    _timers.add(Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        widget.onComplete();
      }
    }));
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  Widget _buildStep(int stepIndex, String text) {
    final bool isCompleted = _currentStep > stepIndex;
    final bool isActive = _currentStep == stepIndex;
    
    Widget leadingWidget;
    if (isCompleted) {
      leadingWidget = Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppTheme.successGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    } else if (isActive) {
      leadingWidget = const SizedBox(
        width: 28,
        height: 28,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppTheme.primaryNavy,
          ),
        ),
      );
    } else {
      leadingWidget = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(Icons.circle, size: 8, color: Colors.grey.shade400),
      );
    }

    return AnimatedOpacity(
      opacity: _currentStep >= stepIndex ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
        decoration: BoxDecoration(
          color: isActive 
              ? AppTheme.primaryNavy.withValues(alpha: 0.05) 
              : (isCompleted ? Colors.white : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive 
                ? AppTheme.primaryNavy.withValues(alpha: 0.3) 
                : (isCompleted ? Colors.grey.shade200 : Colors.grey.shade100),
          ),
        ),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.normal,
                  color: isCompleted ? const Color(0xFF1E293B) : (isActive ? AppTheme.primaryNavy : Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      size: 34,
                      color: AppTheme.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Assessing Application',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryNavy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Running multi-feature decision screening model...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildStep(0, 'Applicant information verified'),
                  _buildStep(1, 'Financial information analyzed'),
                  _buildStep(2, 'Loan details validated'),
                  _buildStep(3, 'Running eligibility model inference...'),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentStep / 4.0).clamp(0.05, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryNavy),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Synthesizing risk profile and recommendation',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

