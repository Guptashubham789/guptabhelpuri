import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "GUPTA BHELPURI & SANDWICH",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Taste jo dil mein bas jaaye… since 2001",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Founded in 2001 in Malad, Mumbai, Gupta Bhelpuri & Sandwich ek chhoti si street food stall se shuru hua aur aaj area ka ek trusted aur favourite food spot ban chuka hai...\n\n"
                  "Yahan har dish banayi jaati hai quality, hygiene aur fresh ingredients ke saath...\n\n"
                  "Gupta Bhelpuri & Sandwich ka focus simple hai — fresh banao, tasty banao aur dil se serve karo...\n\n"
                  "Menu mein aapko milta hai bhelpuri, sev puri, pani puri, sandwiches aur aur bhi kai tasty street snacks...\n\n"
                  "Agar aap Malad mein ho toh yeh ek must-visit spot hai.",
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/team/img.png", // apna logo path
                      height: 120,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Mr. Prakash Gupta || Mr. Bablu Gupta",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/team/img_2.png"),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Sushil Gupta",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/team/img_1.png"),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Rajesh Yadav",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}