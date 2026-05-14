import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landing_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(()=>LandingScreen());
  }
  String? uid;
  String? email;
  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid=user?.uid;
      email=user?.email;
    });

  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  /// Drawer Widget
  Widget mobileDrawer(){
    return Drawer(
      child: ListView(
        children: [

          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                CircleAvatar(
                  child: Image.asset(
                    "assets/img/shop_logo.png", // your shop logo
                    height: 200,
                    width: 200,
                  ),
                ),
                const Text(
                  "Gupta Bhelpuri & Sandwich",
                  style: TextStyle(color: Colors.black,fontSize: 20),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.more_horiz),
            title: const Text("About us"),
            onTap: (){},
          ),

          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Menu"),
            onTap: (){},
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Store Locator"),
            onTap: (){},
          ),

          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("Contacts"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: (){
              logout();
            },
          ),
        ],
      ),
    );
  }

  /// Web Header
  Widget webHeader(){
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [

          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Image.asset(
              "assets/img/shop_logo.png", // your shop logo

            ),
          ),

          const SizedBox(width: 10),

          const Row(
            children: [
              Text(
                "Gupta Bhelpuri & Sandwich",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.restaurant)
            ],
          ),

          const Spacer(),

          headerItem(Icons.more_horiz, "About", () {
            print("About Clicked");
            //Get.to(() => AboutScreen());
          }),

          const SizedBox(width: 25),

          headerItem(Icons.menu_book, "Menu", () {
            print("Menu Clicked");
            //Get.to(() => MenuScreen());
          }),

          const SizedBox(width: 25),

          headerItem(Icons.shopping_cart, "Store Locator", () {
            print("Store Locator Clicked");
            //Get.to(() => StoreLocatorScreen());
          }),

          const SizedBox(width: 25),

          headerItem(Icons.help_outline, "Help", () {
            print("Help Clicked");
            //Get.to(() => HelpScreen());
          }),

          const SizedBox(width: 25),

          headerItem(Icons.person_outline, "Profile", () {
            print("Profile Clicked");
            //Get.to(() => ProfileScreen());
          }),

          const SizedBox(width: 25),

          headerItem(Icons.phone, "Contacts", () {
            print("Contacts Clicked");
            //Get.to(() => ContactScreen());
          }),
        ],
      ),
    );
  }
  Widget headerItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15
            ),
          )
        ],
      ),
    );
  }
  Widget bannerSlider1(bool isMobile) {
    return SizedBox(
      height: isMobile ? 120 : 300,
      child: PageView(
        children: [
          Image.asset('assets/img/banner1.jpg', fit: BoxFit.contain),
          Image.asset('assets/img/banner1.jpg', fit: BoxFit.contain),
          Image.asset('assets/img/banner1.jpg', fit: BoxFit.contain),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    bool isMobile = width < 800;

    return Scaffold(

      /// Drawer only mobile
      drawer: isMobile ? mobileDrawer() : null,

      appBar: isMobile
          ? AppBar(
        backgroundColor: Colors.white60,
        title: const Text(
          "Gupta Bhelpuri & Sandwich",
          style: TextStyle(fontFamily: "serif",fontSize: 18),
        ),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.favorite_border_rounded))
        ],
        centerTitle: true,
      )
          : null,

        body: SingleChildScrollView(
          child: Column(
            children: [

              if(!isMobile) webHeader(),


    StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("banners")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var docs = snapshot.data!.docs;

        return CarouselSlider(
          options: CarouselOptions(
            height: isMobile ? 200 : 500, // mobile vs web
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: isMobile ? 1 : 0.8,
          ),
          items: docs.map((doc) {

            String img = doc["imageUrl"];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );

          }).toList(),
        );
      },
    ),

              Text(uid ?? "No User"),
              Text(email ?? "No User"),

            ],
          ),
        ),
    );
  }
}