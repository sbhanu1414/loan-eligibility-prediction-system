class Applicant {
  final String fullName;
  final int age;
  final String employmentType;
  final String education;
  final int numberOfDependents;
  final String maritalStatus;

  const Applicant({
    required this.fullName,
    required this.age,
    required this.employmentType,
    required this.education,
    required this.numberOfDependents,
    required this.maritalStatus,
  });

  Applicant copyWith({
    String? fullName,
    int? age,
    String? employmentType,
    String? education,
    int? numberOfDependents,
    String? maritalStatus,
  }) {
    return Applicant(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      employmentType: employmentType ?? this.employmentType,
      education: education ?? this.education,
      numberOfDependents: numberOfDependents ?? this.numberOfDependents,
      maritalStatus: maritalStatus ?? this.maritalStatus,
    );
  }

  factory Applicant.demo() {
    return const Applicant(
      fullName: 'Bhanu Pratap',
      age: 24,
      employmentType: 'Salaried',
      education: 'Graduate',
      numberOfDependents: 2,
      maritalStatus: 'Married',
    );
  }
}
