import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<String> menuTitles = [
    'HOME',
    'ABOUT US',
    'MENU',
    'FRANCHISE',
    'STORE LOCATOR',
    'GALLERY',
    'CONTACTS',
  ];
  final List<String> bannerImages = [

    'assets/img/banner2.jpg',
    'assets/img/banner3.jpg',
    'assets/img/banner4.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;

        return Scaffold(
          drawer: isMobile ? mobileDrawer() : null,
          appBar: isMobile
              ? null
              : null,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile) topHeader(),
                mainHeader(isMobile),

                // ----------- BANNER IMAGE -----------
                bannerSlider(isMobile),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Our Menus",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "serif",
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menuList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,        // 2 cards in one row
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = menuList[index];
                      return _menuGridCard(
                        title: item['title'] ?? "No Name",
                        imageUrl: item['image'] ?? "",
                      );
                    },
                  ),
                ),


                const SizedBox(height: 12),


                // ----------- FOOTER -----------
                footer(),
              ],
            ),
          ),

        );
      },
    );
  }
  final List<Map<String, String>> menuList = [
    {
      "title": "Sandwich",
      "image":
      "assets/img/sandwich.jpg"
    },
    {
      "title": "Sevpuri",
      "image":
      "assets/img/sevpuri1.jpg"
    },
    {
      "title": "Bhelpuri",
      "image":
      "assets/img/sevpuri2.jpg"
    },
    {
      "title": "Ragda Paties",
      "image":
      "assets/img/sevpuri2.jpg"
    },
    {
      "title": "Panipuri",
      "image":
      "assets/img/panipuri.jpg"
    },
    {
      "title": "Dahi Bhalle",
      "image":
      "assets/img/dahipuri.jpg"
    },
  ];
  Widget _menuGridCard({
    required String title,
    required String imageUrl,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 8,
              left: 10,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---------------- TOP HEADER ---------------- */

  Widget topHeader() {
    return Container(
      height: 40,
      color: Colors.brown,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.call, color: Colors.yellow, size: 16),
          const SizedBox(width: 6),
          const Text(
            '+91 9594419414 | sg731159@gmail.com',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          socialIcon(Icons.facebook),
          socialIcon(Icons.play_circle_fill),
          socialIcon(Icons.camera_alt),
        ],
      ),
    );
  }

  /* ---------------- MAIN HEADER (RESPONSIVE) ---------------- */

  Widget mainHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.white,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 30,
        runSpacing: 16,
        children: [
          // LOGO
          SizedBox(
            width: isMobile ? 120 : 180,
            height: isMobile ? 120 : 180,
            child: Image.asset(
              'assets/img/logo.jpg',
              fit: BoxFit.contain,
            ),
          ),

          // MENU
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            runSpacing: 10,
            children: List.generate(
              menuTitles.length,
                  (index) => menuItem(menuTitles[index], index, isMobile),
            ),
          ),
        ],
      ),
    );
  }

  /* ---------------- MENU ITEM ---------------- */

  Widget menuItem(String title, int index, bool isMobile) {
    bool isActive = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() => selectedIndex = index);
        if (title == 'ABOUT US') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const AboutScreen()),
          // );
        }
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: isMobile ? 16 : 14,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.orange : Colors.black,
        ),
      ),
    );
  }

  /* ---------------- MOBILE DRAWER ---------------- */

  Widget mobileDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/img/logo.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Gupta Bhelpuri & Sandwich',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          for (int i = 0; i < menuTitles.length; i++)
            drawerItem(menuTitles[i], i),
        ],
      ),
    );
  }

  Widget drawerItem(String title, int index) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() => selectedIndex = index);
        if (title == 'ABOUT US') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const AboutScreen()),
          // );
        }
      },
    );
  }

  /* ---------------- SOCIAL ICON ---------------- */

  Widget socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.red,
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
  /* ---------------- Footer ---------------- */
  Widget footer() {
    return Container(
      width: double.infinity,
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "© 2026 Gupta Bhelpuri & Sandwich",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialIcon(Icons.facebook),
              socialIcon(Icons.play_circle_fill),
              socialIcon(Icons.camera_alt),
            ],
          ),
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
  /* banner*/
  Widget bannerSlider(bool isMobile) {
    return CarouselSlider(
      options: CarouselOptions(
        height: isMobile ? 305 : 500,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        viewportFraction: 1,
        enlargeCenterPage: false,
      ),
      items: bannerImages.map((image) {
        return Image.asset(
          image,
          width: double.infinity,
          fit: BoxFit.contain,
        );
      }).toList(),
    );
  }



}