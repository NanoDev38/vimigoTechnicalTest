import 'package:flutter/material.dart';
import 'package:flutter_application/Model/dataUser.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

var logger = Logger();
List<dataUser> data = [];
List<int> hours = [];

addVerticalSpace(height) {
  return SizedBox(height: height);
}

addHorizontalSpace(width) {
  return SizedBox(width: width);
}

void addData() {
  data.add(dataUser("bobby", 0152131113, DateTime.parse("2023-03-21 15:00:00")));
  data.add(dataUser("susan", 0161231346, DateTime.parse("2020-07-11 15:39:59")));
  data.add(dataUser("billy", 0158398109, DateTime.parse("2020-08-19 11:10:18")));
  data.add(dataUser("shane", 0168279101, DateTime.parse("2020-08-19 11:11:35")));
  data.add(dataUser("logan", 0112731912, DateTime.parse("2020-08-15 13:00:05")));
  data.add(dataUser("willy", 0172332743, DateTime.parse("2020-07-31 18:10:11")));
  data.add(dataUser("Yong Weng Kai", 0172332743, DateTime.parse("2020-07-31 18:10:11")));
  data.add(dataUser("Jayden Lee", 0191236439, DateTime.parse("2020-08-22 08:10:38")));
  data.add(dataUser("Kong Kah Yan", 0111931233, DateTime.parse("2020-07-11 12:00:00")));
  data.add(dataUser("Jasmine Lau", 0162879190, DateTime.parse("2020-08-01 12:10:05")));

  sortData(); //* function sort data
}

void sortData() {
  data.sort((a, b) => b.checkIn.compareTo(a.checkIn));
}

// {
// "user": "Chan Saw Lin"
// "phone": "0152131113"
// "check-in": 2020-06-30 16:10:05
// },
// {
// "user": "Lee Saw Loy"
// "phone": "0161231346"
// "check-in": 2020-07-11 15:39:59
// },
// {
// "user": "Khaw Tong Lin"
// "phone": "0158398109"
// "check-in": 2020-08-19 11:10:18
// },
// {
// "user": "Lim Kok Lin"
// "phone": "0168279101"
// "check-in": 2020-08-19 11:11:35
// },
// {
// "user": "Low Jun Wei"
// "phone": "0112731912"
// "check-in": 2020-08-15 13:00:05
// },
// {
// "user": "Yong Weng Kai"
// "phone": "0172332743"
// "check-in": 2020-07-31 18:10:11
// },
// {
// "user": "Jayden Lee"
// "phone": "0191236439"
// "check-in": 2020-08-22 08:10:38
// },
// {
// "user": "Kong Kah Yan"
// "phone": "0111931233"
// "check-in": 2020-07-11 12:00:00
// },
// {
// "user": "Jasmine Lau"
// "phone": "0162879190"
// "check-in": 2020-08-01 12:10:05
// },
// {
// "user": "Chan Saw Lin"
// "phone": "016783239"
// "check-in": 2020-08-23 11:59:05
// }