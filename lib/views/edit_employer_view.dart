import 'package:employee_management_system/views/employers_view.dart';
import 'package:flutter/material.dart';

import '../db/employer_database.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';

class EditEmployerPage extends StatefulWidget {
  final int id;
  const EditEmployerPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditEmployerPage> createState() => _EditEmployerPageState(this.id);
}

class _EditEmployerPageState extends State<EditEmployerPage> {
  final int id;
  final _formKey = GlobalKey<FormState>();

  TextEditingController empIdController = TextEditingController();
  TextEditingController empNameController = TextEditingController();
  TextEditingController empEmailController = TextEditingController();
  TextEditingController empMobileController = TextEditingController();
  TextEditingController empDateController = TextEditingController();
  String employerType = 'permanent';

  _EditEmployerPageState(this.id);

  Future getEmployerData() async {
    Employer employer = await EmployerDatabase.instance.getEmployer(id);
    empIdController.text = employer.empId.toString();
    empNameController.text = employer.empName;
    empEmailController.text = employer.empEmail;
    empMobileController.text = employer.empMobile;
    empDateController.text = employer.empDob;
    employerType = employer.empType;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEmployerData();
  }

  @override
  void dispose() {
    super.dispose();
    empIdController.dispose();
    empNameController.dispose();
    empEmailController.dispose();
    empMobileController.dispose();
    empDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(border: Border.all()),
                  child: const Icon(
                    Icons.person,
                    size: 80.0,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: empIdController,
                  validator: (empID) =>
                      empID!.isEmpty ? "Employee Id Can't be empty" : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Employee Id',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: const EdgeInsets.only(left: 10.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: empNameController,
                  validator: (name) =>
                      name!.isEmpty ? "Employee Name Can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: 'Employee Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: const EdgeInsets.only(left: 10.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: empEmailController,
                  validator: (email) =>
                      email!.isEmpty ? "Employee Email Can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: 'Email Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: const EdgeInsets.only(left: 10.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: empMobileController,
                  validator: (email) =>
                      email!.isEmpty ? "Employee Mobile Can't be empty" : null,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: const EdgeInsets.only(left: 10.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: empDateController,
                  validator: (dob) =>
                      dob!.isEmpty ? "Employee DOB Can't be empty" : null,
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1995),
                            lastDate: DateTime(2800))
                        .then((date) {
                      if (date != null) {
                        setState(() {
                          empDateController.text = dateFormatConst.format(date);
                        });
                      }
                    });
                  },
                  decoration: InputDecoration(
                      hintText: dateFormatConst.format(DateTime.now()),
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: const EdgeInsets.only(left: 10.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'permanent',
                          groupValue: employerType,
                          onChanged: (value) {
                            setState(() {
                              employerType = value.toString();
                            });
                          },
                        ),
                        const Text('Permanent'),
                      ],
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'temporary',
                          groupValue: employerType,
                          onChanged: (value) {
                            setState(() {
                              employerType = value.toString();
                            });
                          },
                        ),
                        const Text('Temporary')
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          final updatedEmployer = Employer(
                              id: id,
                              empId: int.parse(empIdController.text),
                              empName: empNameController.text,
                              empEmail: empEmailController.text,
                              empMobile: empMobileController.text,
                              empType: employerType,
                              empDob: empDateController.text);

                          int count = await EmployerDatabase.instance
                              .updateEmployer(updatedEmployer);
                          if (count == 1) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployersPage()));
                            final snackBar = SnackBar(
                              content: const Text('Employer Updated'),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                              content: const Text('Error Occured'),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
