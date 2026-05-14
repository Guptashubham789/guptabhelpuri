import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guptabhelpuri/views/user_dashboard_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/sign_in_google_controller.dart';
import 'about_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final background=Colors.blue;
  Future<void> saveUserData(user) async {

    try {

      final prefs = await SharedPreferences.getInstance();

      String uid = user.user!.uid;
      String email = user.user!.email ?? "";
      String phone = user.user!.phoneNumber ?? "";
      String photo = user.user!.photoURL ?? "";

      await prefs.setString("uid", uid);
      await prefs.setString("email", email);
      await prefs.setString("phone", phone);
      await prefs.setString("photo", photo);

      String? token = await FirebaseMessaging.instance.getToken();

      print("TOKEN: $token");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({
        "uid": uid,
        "email": email,
        "phone": phone,
        "profilePic": photo,
        "deviceToken": token,
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("User saved successfully");

    } catch (e) {
      print("Firestore Error: $e");
    }

  }
  @override
  void initState() {
    super.initState();
    checkLoginState();
    getDeviceToken();
  }

  Future<void> checkLoginState() async {

    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    await Future.delayed(const Duration(seconds: 1));

    if(uid != null){
      Get.offAll(()=>UserDashboardScreen());
    }

  }



  Future<void> openSwiggy() async {
    final Uri url = Uri.parse("https://www.swiggy.com/menu/1342733?source=sharing");

    try {
      if (kIsWeb) {
        // Web ke liye
        await launchUrl(
          url,
          webOnlyWindowName: '_blank',
        );
      } else {
        // Mobile ke liye
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print("Error opening link: $e");
    }
  }
  Future<void> openMapLink() async {
    final Uri url = Uri.parse(
      "https://maps.app.goo.gl/ofS8EZzj5JpEhi8u8",
    );

    await launchUrl(
      url,
      mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
//------Feedback Start-----------
  String? deviceToken;

  Future<void> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (important for Android 13+ / iOS)
    await messaging.requestPermission();

    deviceToken = await messaging.getToken();

    print("Device Token: $deviceToken");
  }
  void feedbackDialog(BuildContext context) {
    double rating = 0;
    TextEditingController nameController = TextEditingController();
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      "How was your food experience? 🍔",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 15),

                    // Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Your Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // Rating Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Give Rating",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              rating = index + 1.0;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            size: 30,
                            color: index < rating
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 15),

                    // Feedback Field
                    TextField(
                      controller: feedbackController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Your Feedback",
                        hintText: "Tell us about your food experience...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (nameController.text.isEmpty || rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter name and rating")),
                            );
                            return;
                          }

                          try {

                            await FirebaseFirestore.instance.collection("feedback").add({
                              "name": nameController.text.trim(),
                              "rating": rating,
                              "feedback": feedbackController.text.trim(),
                              "token":deviceToken.toString(),
                              "timestamp": FieldValue.serverTimestamp(),
                            });

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text("Thanks for your feedback! ❤️")),
                            // );
                            Get.snackbar(
                              "Thanks for your feedback! ❤️",
                              "",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black,
                              colorText: Colors.white,
                              margin: EdgeInsets.all(10),
                              borderRadius: 8,
                              duration: Duration(seconds: 2),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            print("Error: $e");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to submit feedback")),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Submit",style:TextStyle(color:Colors.white)),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward,color:Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  //---------Feedback End------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 👈 yaha add karo
      appBar:AppBar(
          backgroundColor:Colors.white,
      ),
      drawer:Drawer(
        child: Column(
          children: [

            // Top space + Logo Center
            SizedBox(height: 50),

            Center(
              child: Image.asset(
                "assets/img/shop_logo.png", // apna logo path
                height: 120,
                width: 120,
              ),
            ),

            SizedBox(height: 30),

            Divider(),

            // Menu Items
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Home
              },
            ),

            ListTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
              onTap: () {
                Navigator.pop(context); // Drawer close karega

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Shop Locations"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Locations
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
        
                // ----------- TOP LOGO -----------
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/img/shop_logo.png", // your shop logo
                        height: 200,
                        width: 200,
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 10),
        
                // ----------- DESCRIPTION -----------
                Center(
                  child: const Text(
                    "Welcome To \n Gupta Bhelpuri & Sandwich",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Order your favorites \nfood on Swiggy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),

                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add Swiggy link launch here
                            openSwiggy();
                          },
                          icon: Icon(Icons.open_in_new, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: openMapLink,
                          icon: Icon(Icons.location_on_outlined, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => feedbackDialog(context),
                          icon: Icon(Icons.feedback, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Center(
                  child: const Text(
                    "Enjoy our delicious street food like Sandwich, Grill Sandwich, Pani Puri, Dahi Puri, Ragda Pattice, Sev Puri, Bhelpuri, Pattice Sandwich, Dahi Bhalla and Dahi Papdi Chaat – fresh, tasty and full of authentic flavor.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
        
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
        
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/1.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/9.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/4.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
        
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
        
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/2.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/8.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/3.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
        
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/5.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/6.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            "assets/img/7.jpg",
                            height: 120,
                            width: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //-----Review Show-----------
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("Honest Feedback ", style: TextStyle(color:Colors.black)),
                      Icon(Icons.star, size: 16)
                    ],
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("feedback")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No reviews yet"));
                      }

                      return CarouselSlider.builder(
                        itemCount: snapshot.data!.docs.length,
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          enlargeCenterPage: true, // ⭐ center focus
                          viewportFraction: 0.7,
                          autoPlayInterval: Duration(seconds: 3),
                        ),
                        itemBuilder: (context, index, realIndex) {
                          var data = snapshot.data!.docs[index];

                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.orange.shade100,
                                child: Icon(Icons.person, color: Colors.orange),
                              ),

                              SizedBox(height: 4),

                              Text(
                                data["name"] ?? "User",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                data["timestamp"] != null
                                    ? DateFormat("d MMM yyyy")
                                    .format((data["timestamp"] as Timestamp).toDate())
                                    : "",
                                style: TextStyle(fontSize: 10),
                              ),

                              SizedBox(height: 4),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (i) {
                                  return Icon(
                                    Icons.star,
                                    size: 14, // 👈 reduce size थोड़ा
                                    color: i < (data["rating"] ?? 0)
                                        ? Colors.orange
                                        : Colors.grey,
                                  );
                                }),
                              ),

                              SizedBox(height: 4),

                              // ✅ THIS FIXES OVERFLOW
                              Expanded(
                                child: Text(
                                  data["feedback"] ?? "",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                // ----------- SIGN UP BUTTON -----------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      Get.snackbar(
                        "Gupta Bhelpuri & Sandwich",
                        "Coming Soon..",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        borderRadius: 8,
                        duration: Duration(seconds: 2),
                      );
                      // UserCredential? user = await signInWithGoogle();
                      //
                      // if (user != null) {
                      //   print("Login Success");
                      //   print(user.user?.email);
                      //   print(user.user?.uid);
                      //
                      //   await saveUserData(user);
                      //
                      //   Get.offAll(() => UserDashboardScreen());
                      // }

                    },
                    icon: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/281/281764.png", // 🌐 Google icon URL
                      height: 22,
                      width: 22,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, size: 22); // fallback
                      },
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 10),
        
                // ----------- SKIP BUTTON -----------
                Container(
                   decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "© 2026 Gupta Bhelpuri & Sandwich - SGTech Technology Pvt Ltd",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
        
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
