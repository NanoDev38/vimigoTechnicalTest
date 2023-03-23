import 'package:flutter/material.dart';
import 'package:flutter_application/Global/global.dart';
import 'package:flutter_application/Model/dataUser.dart';
import 'package:flutter_application/View/addMoreData.dart';
import 'package:flutter_application/View/userDetails.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homePage extends StatefulWidget {
  const homePage({super.key, required this.title});

  final String title;

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var hmsFormat = DateFormat('dd/MMM/yyyy hh:mm a');
  final now = DateTime.now();
  bool isChange = false, isLoading = true, isSearched = false;
  int _selectedIndex = 0;

  TextEditingController searchInput = TextEditingController();

  ScrollController listScrollSearched = ScrollController();
  double scrollPositionSearched = 0;
  ScrollController listScroll = ScrollController();
  double scrollPosition = 0;

  List<dataUser> searchRes = [];

  _scrollSearchedListener() {
    setState(() {
      scrollPositionSearched = listScrollSearched.position.pixels;
    });

    if (listScrollSearched.position.maxScrollExtent == scrollPositionSearched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You have reached the end of the list',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _scrollListener() {
    setState(() {
      scrollPosition = listScroll.position.pixels;
    });

    // logger.i(listScroll.position.maxScrollExtent);
    // logger.e(scrollPosition);
    if (listScroll.position.maxScrollExtent == scrollPosition) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You have reached the end of the list',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  saveSession() async {
    final prefs = await SharedPreferences.getInstance();

    if (isChange) {
      await prefs.setBool('hour', true);
    } else {
      await prefs.setBool('hour', false);
    }
  }

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

  checkSession() async {
    final prefs = await SharedPreferences.getInstance();

    addData();

    if (prefs.getBool("hour") == true) {
      setState(() {
        isLoading = false;
        isChange = true;
        convertToHour();
      });
    } else {
      setState(() {
        isLoading = false;
        isChange = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void searchFunction(String searchText) {
    searchRes.clear();

    if (searchRes.isEmpty) {
      setState(() {
        isSearched = true;
      });
      for (int i = 0; i < data.length; i++) {
        if (data[i].name.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchRes.add(dataUser(data[i].name, data[i].phone, data[i].checkIn));
          });
        }
      }
    } else if (searchText == "") {
      setState(() {
        isSearched = false;
      });
    }
    // logger.i(searchRes);
  }

  @override
  void initState() {
    super.initState();
    listScrollSearched.addListener(_scrollSearchedListener);
    listScroll.addListener(_scrollListener);
    setState(() {
      isChange = false;
    });
    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: isLoading
          ? SizedBox(
              width: width,
              height: height,
              child: const SpinKitDualRing(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : _selectedIndex == 0
              ? Column(
                  children: [
                    addVerticalSpace(10.0),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: searchInput,
                        onChanged: (value) {
                          searchFunction(value);
                        },
                        decoration: const InputDecoration(
                          hintText: "Search Data",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ),
                      ),
                    ),
                    isSearched
                        ? Expanded(
                            child: ListView.separated(
                              controller: listScrollSearched,
                              padding: const EdgeInsets.all(8),
                              itemCount: searchRes.length,
                              separatorBuilder: (context, index) => const Divider(
                                color: Colors.white,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => userDetails(name: searchRes[index].name, date: hmsFormat.format(searchRes[index].checkIn), phone: searchRes[index].phone.toString()));
                                  },
                                  child: Container(
                                    height: 50,
                                    color: Colors.amber,
                                    child: Center(
                                      child: Text(
                                        isChange ? "${hours[index].toString()} Hours ago" : "${searchRes[index].name} - ${searchRes[index].phone} - ${hmsFormat.format(searchRes[index].checkIn)}",
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              controller: listScroll,
                              padding: const EdgeInsets.all(8),
                              itemCount: data.length,
                              separatorBuilder: (context, index) => const Divider(
                                color: Colors.white,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => userDetails(name: data[index].name, date: hmsFormat.format(data[index].checkIn), phone: data[index].phone.toString()));
                                  },
                                  child: Container(
                                    height: 50,
                                    color: Colors.amber,
                                    child: Center(
                                      child: Text(
                                        isChange ? "${hours[index].toString()} Hours ago" : "${data[index].name} - ${data[index].phone} - ${hmsFormat.format(data[index].checkIn)}",
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                )
              : const addMoreData(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add Data',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isLoading) {
            setState(
              () {
                if (isChange == true) {
                  isChange = false;
                  saveSession();
                } else {
                  convertToHour();
                  isChange = true;
                  saveSession();
                }
              },
            );
          } else {
            logger.i("LOADING!!");
          }
          // logger.d(data[9].checkIn);
          // convertToHour(data[9].checkIn);
        },
        tooltip: 'Change',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
