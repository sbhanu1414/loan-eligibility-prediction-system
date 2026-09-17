import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/applicant.dart';
import 'package:loan_eligibility/theme/app_theme.dart';
import 'package:loan_eligibility/widgets/custom_text_field.dart';
import 'package:loan_eligibility/widgets/dropdown_field.dart';

class ApplicantScreen extends StatefulWidget {
  final Applicant? initialData;
  final VoidCallback onBack;
  final Function(Applicant) onNext;
  final VoidCallback onLoadDemo;

  const ApplicantScreen({
    super.key,
    this.initialData,
    required this.onBack,
    required this.onNext,
    required this.onLoadDemo,
  });

  @override
  State<ApplicantScreen> createState() => _ApplicantScreenState();
}

class _ApplicantScreenState extends State<ApplicantScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _dependentsController;
  
  String? _employmentType;
  String? _education;
  String? _maritalStatus;

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    _nameController = TextEditingController(text: init != null ? init.fullName : '');
    _ageController = TextEditingController(text: init != null && init.age > 0 ? init.age.toString() : '');
    _dependentsController = TextEditingController(text: init != null ? init.numberOfDependents.toString() : '');
    
    _employmentType = init?.employmentType;
    _education = init?.education;
    _maritalStatus = init?.maritalStatus;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dependentsController.dispose();
    super.dispose();
  }

  void _loadDemo() {
    widget.onLoadDemo();
    final demo = Applicant.demo();
    setState(() {
      _nameController.text = demo.fullName;
      _ageController.text = demo.age.toString();
      _dependentsController.text = demo.numberOfDependents.toString();
      _employmentType = demo.employmentType;
      _education = demo.education;
      _maritalStatus = demo.maritalStatus;
    });
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final applicant = Applicant(
        fullName: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        employmentType: _employmentType ?? 'Salaried',
        education: _education ?? 'Graduate',
        numberOfDependents: int.parse(_dependentsController.text.trim()),
        maritalStatus: _maritalStatus ?? 'Single',
      );
      widget.onNext(applicant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Applicant Information',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryNavy,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Personal and employment background',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Step 1 of 3',
                        style: TextStyle(
                          color: AppTheme.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter applicant full legal name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter applicant full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _ageController,
                          label: 'Age',
                          hint: 'e.g., 28',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.cake_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter applicant age';
                            }
                            final age = int.tryParse(value.trim());
                            if (age == null || age < 18 || age > 100) {
                              return 'Age must be between 18 and 100 years';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        DropdownField(
                          label: 'Employment Type',
                          value: _employmentType,
                          items: const ['Salaried', 'Self Employed', 'Business Owner', 'Student', 'Other'],
                          prefixIcon: Icons.work_outline,
                          onChanged: (val) => setState(() => _employmentType = val),
                          validator: (val) => val == null ? 'Please select employment type' : null,
                        ),
                        const SizedBox(height: 18),
                        DropdownField(
                          label: 'Education',
                          value: _education,
                          items: const ['Graduate', 'Post Graduate', 'Undergraduate', 'Other'],
                          prefixIcon: Icons.school_outlined,
                          onChanged: (val) => setState(() => _education = val),
                          validator: (val) => val == null ? 'Please select education qualification' : null,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _dependentsController,
                          label: 'Number of Dependents',
                          hint: 'e.g., 0, 1, 2',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.family_restroom_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter number of dependents';
                            }
                            final deps = int.tryParse(value.trim());
                            if (deps == null || deps < 0 || deps > 20) {
                              return 'Number of dependents must be between 0 and 20';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        DropdownField(
                          label: 'Marital Status',
                          value: _maritalStatus,
                          items: const ['Single', 'Married'],
                          prefixIcon: Icons.favorite_outline,
                          onChanged: (val) => setState(() => _maritalStatus = val),
                          validator: (val) => val == null ? 'Please select marital status' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: _loadDemo,
                    icon: const Icon(Icons.flash_on, size: 18),
                    label: const Text('Load Demo Applicant (Bhanu Pratap)'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                    FilledButton.icon(
                      onPressed: _onNext,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next Step'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

