import 'package:employee_management_system/views/edit_employer_view.dart';
import 'package:flutter/material.dart';
import '../db/employer_database.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';

class EmployersPage extends StatefulWidget {
  const EmployersPage({Key? key}) : super(key: key);

  @override
  State<EmployersPage> createState() => _EmployersPageState();
}

class _EmployersPageState extends State<EmployersPage> {
  TextEditingController empIdController = TextEditingController();
  TextEditingController empNameController = TextEditingController();
  TextEditingController empEmailController = TextEditingController();
  TextEditingController empMobileController = TextEditingController();
  TextEditingController empDateController = TextEditingController();
  String employerType = 'permanent';
  final _formKey = GlobalKey<FormState>();

  // delete Employer
  Widget deleteEmployer(BuildContext context, Employer employer) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext newContext) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: Column(
                    children: [
                      Stack(
                        fit: StackFit.passthrough,
                        children: [
                          const Center(
                            child: Text(
                              'Warning',
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close)))
                        ],
                      ),
                    ],
                  ),
                  content: Text(
                      'Are you sure you want to delete this employer (id: ${employer.empId})?'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        onPressed: () {
                          Navigator.pop(newContext);
                        },
                        child: const Text('No')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () async {
                          Navigator.pop(newContext);
                          int count = await EmployerDatabase.instance
                              .deleteEmployer(employer.id!);
                          if (count == 1) {
                            final snackBar = SnackBar(
                              content: const Text('Employer Deleted'),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {});
                          } else {
                            final snackBar = SnackBar(
                              content: const Text('Error Occured'),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: const Text('Yes'))
                  ],
                );
              });
        },
        icon: const Icon(Icons.delete));
  }

  @override
  void initState() {
    super.initState();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
          showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: ((context, setState) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Employee Details'),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: empIdController,
                                  keyboardType: TextInputType.number,
                                  validator: (empID) => empID!.isEmpty
                                      ? "Employee Id Can't be empty"
                                      : null,
                                  decoration: InputDecoration(
                                      hintText: 'Employee Id',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10.0)),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: empNameController,
                                  validator: (name) => name!.isEmpty
                                      ? "Employee Name Can't be empty"
                                      : null,
                                  decoration: InputDecoration(
                                      hintText: 'Employee Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10.0)),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: empEmailController,
                                  validator: (email) => email!.isEmpty
                                      ? "Employee Email Can't be empty"
                                      : null,
                                  decoration: InputDecoration(
                                      hintText: 'Email Address',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10.0)),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: empMobileController,
                                  validator: (email) => email!.isEmpty
                                      ? "Employee Mobile Can't be empty"
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      hintText: 'Mobile Number',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10.0)),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: empDateController,
                                  validator: (dob) => dob!.isEmpty
                                      ? "Employee DOB Can't be empty"
                                      : null,
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
                                          empDateController.text =
                                              dateFormatConst.format(date);
                                        });
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: dateFormatConst
                                          .format(DateTime.now()),
                                      suffixIcon:
                                          const Icon(Icons.calendar_month),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10.0)),
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
                                          Navigator.pop(context);
                                          final newEmployer = Employer(
                                              empId: int.parse(
                                                  empIdController.text),
                                              empName: empNameController.text,
                                              empEmail: empEmailController.text,
                                              empMobile:
                                                  empMobileController.text,
                                              empType: employerType,
                                              empDob: empDateController.text);

                                          int id = await EmployerDatabase
                                              .instance
                                              .addEmployer(newEmployer);
                                          if (!id.isNaN) {
                                            final snackBar = SnackBar(
                                              content:
                                                  const Text('Employer Added'),
                                              action: SnackBarAction(
                                                label: '',
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);

                                            setState(() {
                                              empIdController.clear();
                                              empNameController.clear();
                                              empEmailController.clear();
                                              empMobileController.clear();
                                              empDateController.clear();
                                              employerType = '';
                                            });
                                          } else {
                                            final snackBar = SnackBar(
                                              content:
                                                  const Text('Error Occured'),
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
                        )
                      ],
                    ),
                  );
                }));
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            FutureBuilder(
                future: EmployerDatabase.instance.getAllEmployers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.data.length > 0) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              Employer employer = snapshot.data[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 70.0,
                                        width: 60.0,
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: const Icon(Icons.person),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Employee No: ${employer.empId}'),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                                'Employee Name: ${employer.empName}'),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                                'Date of Birth: ${employer.empDob}'),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                Chip(
                                                    padding: EdgeInsets.zero,
                                                    backgroundColor:
                                                        employer.empType ==
                                                                'temporary'
                                                            ? Colors.red
                                                            : Colors.green,
                                                    label:
                                                        Text(employer.empType)),
                                                const Spacer(),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditEmployerPage(
                                                                    id: employer
                                                                        .id!,
                                                                  )));
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit)),
                                                deleteEmployer(
                                                    context, employer),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Align(
                          alignment: Alignment.center,
                          child: Text('Currently No data Available'));
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                })
          ],
        ),
      )),
    );
  }
}
