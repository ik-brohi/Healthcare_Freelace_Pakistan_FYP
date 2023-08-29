import 'package:carousel_slider/carousel_slider.dart';
import 'package:healthcare_pakistan/data.dart';
import 'package:healthcare_pakistan/screens/DoctorListScreen.dart';
import '/HealthcareTipsDoctorPage.dart';
import '/HealthcareTipsPage.dart';
import '/Widgets/catagory.dart';
import '/Widgets/catalogue.dart';
import '/Widgets/responsive.dart';
import '/Messages.dart';
import '/DoctorCat.dart';
import '/detailpage.dart';
import '/myOrderpage.dart';
import '/notifications.dart';
import '/profile.dart';
import '/profileDoctor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'DoctorOrderPage.dart';
import 'homepage.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? role;
  String _city = '';

  @override
  void initState() {
    _getRoleFromSharedPreferences();
    super.initState();
  }

  Future<void> _getRoleFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? '';
    });
  }

  // int index = 0;
  // List pages = [
  //   Dashboard(),
  //   Messages(showbtn: false),
  //   MyOrders(),
  //   Profile(),
  //   ProfileDoctor(),
  //   DoctorOrderPage(),
  // ];

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _city = 'Location services are disabled.';
      });
      return;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _city = 'Location permissions are permanently denied.';
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      // Request location permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _city = 'Location permissions are denied.';
        });
        return;
      }
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        _city = placemarks.first.locality ?? 'Unknown';
      });
    } catch (e) {
      setState(() {
        _city = 'Could not fetch location.';
      });
    }
  }

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  void _onSearchPressed() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _onSearchConfirmPressed() {
    // Navigate to the next screen with the search query
    String searchQuery = _searchController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorListScreen(cityName: searchQuery),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // (index == 3) ? (role == 'HEALTHCARE PROFESSIONAL' ? pages[4] : pages[3]) : ((index == 2 && role == 'HEALTHCARE PROFESSIONAL') ? pages[5] : pages[index]);
    List brands = [
      Image.asset("images/promo1.png"),
      Image.asset("images/promo2.png"),
      Image.asset("images/promo3.png"),
      Image.asset("images/promo4.png"),
    ];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight + 50,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search...",
                ),
                onSubmitted: (_) => _onSearchConfirmPressed(),
              )
            : Text(
                "Health Care Pakistan",
                style: GoogleFonts.ubuntu(color: Colors.black),
              ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: _onSearchPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.grey[900]),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 150,
                    //aspectRatio: 25 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Container(
                    child: brands[itemIndex],
                  ),
                ),
                SizedBox(
                  height: countHeight(5, context),
                ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //    verticalDirection: VerticalDirection.down,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => DoctorCat(
                                      name: "Psychologists",
                                    )));
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: catagory("Physiologist",
                                "images/generalphysican.png", context),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => DoctorCat(
                                      name: "Neurologists",
                                    )));
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: catagory("Neurologist",
                                "images/Neurologist.png", context),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => DoctorCat(
                                      name: "Epidemiologists",
                                    )));
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: catagory("Epidemiologist",
                                "images/Epidemiologist.png", context),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => DoctorCat(
                                      name: "Chaplains",
                                    )));
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: catagory(
                                "Chaplain", "images/Chaplain.png", context),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => DoctorCat(
                                      name: "Nurses",
                                    )));
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                catagory("Nurse", "images/Nurse.png", context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => DoctorCat(name: "summer SAle")));
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Online Healthcare Professionals",
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: countHeight(278, context),
                      //width: countWidth(350, context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (builder) =>
                                      DoctorCat(name: "Online Doctors")));
                            }),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: Image.asset(
                                  "images/onlinespecialist.png",
                                  fit: BoxFit.fill,
                                  //   height: 300.0,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (builder) =>
                                      DoctorCat(name: "Online Nurse")));
                            }),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: Image.asset(
                                  "images/onlinenurse.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) =>
                            DoctorCat(name: "featured brands")));
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Healthcare Tips",
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() async {
                    if (currentRole == "doctor") {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => HealthcareTipsDoctorPage()));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => HealthcareTipsPage()));
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: countHeight(195, context),
                                  width: countWidth(360, context),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 90, 163, 234),
                                    //borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.asset(
                                      "images/healthcaretips.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                // Container(
                                //   height: countHeight(195, context),
                                //   width: countWidth(150, context),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //
                                //   ),
                                //   // child: Image.asset(
                                //   //   "images/levisdiscount.webp",
                                //   //   fit: BoxFit.fill,
                                //   // ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Tips",
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w700, fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "To ensure your health",
                              style: GoogleFonts.openSans(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => DoctorCat(name: "trending")));
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popular",
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    addRepaintBoundaries: true,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 9.9,
                    mainAxisSpacing: 15.0,
                    crossAxisCount: 2,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => Details(
                                    price: "1050 RS",
                                    image: "images/doctor1.jpg",
                                    title: "Doctor Saif",
                                  )));
                        },
                        child: catalogue("images/doctor1.jpg", "Doctor Saif",
                            "2000 Rs", context),
                      ),
                      catalogue("images/doctor2.png", "Maria Ali", "1000 Rs",
                          context),
                      catalogue(
                          "images/doctor1.jpg", "M Din", "1500 Rs", context),
                      catalogue("images/doctor1.jpg", "Abdul Salam", "1000 Rs",
                          context),
                      catalogue("images/doctor1.jpg", "Doctor Shamas",
                          "3000 Rs", context),
                      catalogue(
                          "images/doctor1.jpg", "Asad Ali", "1000 Rs", context),
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),

      // bottomNavigationBar:  BottomNavigationBar(
      //       currentIndex: index,
      //       onTap: (value) {
      //         setState(() {
      //           index = value;
      //         });
      //       },
      //       backgroundColor: Colors.white,
      //       elevation: 0.0,
      //       unselectedItemColor: Colors.grey[900],
      //       showSelectedLabels: false,
      //       selectedItemColor: Colors.grey[900],
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.home_outlined),
      //           label: "HOME",
      //           activeIcon: Icon(
      //             Icons.home_filled,
      //           ),
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.send_outlined),
      //           label: "Messages",
      //           activeIcon: Icon(
      //             Icons.send,
      //           ),
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.schedule_outlined),
      //           label: "Appointments",
      //           activeIcon: Icon(
      //             Icons.schedule,
      //           ),
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person_outline_sharp),
      //           label: "Profile",
      //           activeIcon: Icon(
      //             Icons.person,
      //           ),
      //         ),
      //       ]),
    );
  }
}
