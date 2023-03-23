import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application/Global/global.dart';
import 'package:flutter_application/Model/dataUser.dart';
import 'package:intl/intl.dart';

class addMoreData extends StatefulWidget {
  const addMoreData({super.key});

  @override
  State<addMoreData> createState() => _addMoreDataState();
}

class _addMoreDataState extends State<addMoreData> {
  final _formKey = GlobalKey<FormState>();
  final now = DateTime.now();

  TextEditingController nameInput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();
  TextEditingController dateInput = TextEditingController(
    text: DateFormat('yyyy-MM-dd hh:mm:ss').format(
      DateTime.now(),
    ),
  );

  convertToHour() {
    hours.clear();
    for (int i = 0; i < data.length; i++) {
      var durationSinceNow = now.difference(data[i].checkIn);

      setState(() {
        hours.add(durationSinceNow.inHours);
        // var inHor = durationSinceNow.inHours;
      });
    }
    logger.i(hours.length);
  }

  addNewData() {
    // 2023-03-21
    data.add(dataUser(nameInput.text, int.parse(phoneInput.text), DateTime.parse(dateInput.text)));
    convertToHour();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            addVerticalSpace(20.0),
            const Text(
              "Add more attendance",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    addVerticalSpace(10.0),
                    TextFormField(
                      controller: nameInput,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                    ),
                    addVerticalSpace(10.0),
                    const Text(
                      "Phone Number",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    addVerticalSpace(10.0),
                    TextFormField(
                      controller: phoneInput,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Phone Number';
                        }
                        return null;
                      },
                    ),
                    addVerticalSpace(10.0),
                    const Text(
                      "Attendance Date",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    addVerticalSpace(10.0),
                    TextFormField(
                      readOnly: true,
                      controller: dateInput,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          // logger.i(pickedDate);
                          String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(pickedDate);
                          logger.i(formattedDate);

                          setState(() {
                            dateInput.text = formattedDate;
                          });
                        } else {
                          logger.e("Date is not selected");
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Phone Number';
                        }
                        return null;
                      },
                    ),
                    addVerticalSpace(20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addNewData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Add Data Success',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Success"),
    content: const Text("Add Data Success"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
