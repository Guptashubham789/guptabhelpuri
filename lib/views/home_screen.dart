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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;

        return Scaffold(
          drawer: isMobile ? mobileDrawer() : null,
          appBar: isMobile
              ? AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Gupta Bhelpuri & Sandwich',
              style: TextStyle(color: Colors.white),
            ),
          )
              : null,
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (!isMobile) topHeader(),
                mainHeader(isMobile),

                // ----------- BANNER IMAGE -----------
                AspectRatio(
                  aspectRatio: isMobile ? 21 / 5 : 35 / 9,
                  child: Image.asset(
                    'assets/img/banner1.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),



                const SizedBox(height: 40),

                // ----------- FOOTER -----------
                footer(),
              ],
            ),
          ),

        );
      },
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
            '+91 9270142040 | sg731159@gmail.com',
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
}