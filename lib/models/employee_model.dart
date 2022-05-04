const String tableEmployers = 'employers';

const String columnID = '_id';
const String columnEmpId = 'emp_id';
const String columnEmpName = 'emp_name';
const String columnEmpEmail = 'emp_email';
const String columnEmpMobile = 'emp_mobile';
const String columnEmpType = 'emp_type';
const String columnEmpDob = 'emp_dob';

class Employer {
  final int? id;
  final int empId;
  final String empName;
  final String empEmail;
  final String empMobile;
  final String empType;
  final String empDob;

  Employer(
      {this.id,
      required this.empId,
      required this.empName,
      required this.empEmail,
      required this.empMobile,
      required this.empType,
      required this.empDob});

  factory Employer.fromMap(Map<String, dynamic> json) => Employer(
        id: json[columnID] as int?,
        empId: json[columnEmpId] as int,
        empName: json[columnEmpName],
        empEmail: json[columnEmpEmail],
        empMobile: json[columnEmpMobile],
        empType: json[columnEmpType],
        empDob: json[columnEmpDob],
      );

  Map<String, Object?> toMap() => {
        columnID: id,
        columnEmpId: empId,
        columnEmpName: empName,
        columnEmpEmail: empEmail,
        columnEmpMobile: empMobile,
        columnEmpType: empType,
        columnEmpDob: empDob,
      };
}
