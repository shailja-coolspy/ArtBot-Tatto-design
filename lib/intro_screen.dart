import 'package:ai_app/chat_page.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/intro_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black,
                    Color.fromARGB(59, 165, 194, 20),
                    Color.fromARGB(204, 32, 169, 228),
                    Color.fromARGB(133, 15, 200, 43),
                    Color.fromARGB(165, 236, 77, 202),
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              children: [
                const Column(
                  children: [
                    // Title and Description
                    Text(
                      "ArtBot",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Unlock All Features with Pro",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Features List
                SizedBox(
                  height: 210,
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 16, bottom: 0, left: 80, right: 70),
                    children: [
                      FeatureTile(
                        icon: Icons.check_circle,
                        text: "Fast processing",
                      ),
                      FeatureTile(
                        icon: Icons.check_circle,
                        text: "Unlimited artwork creation",
                      ),
                      FeatureTile(
                        icon: Icons.check_circle,
                        text: "Unlock 30+ styles",
                      ),
                      FeatureTile(
                        icon: Icons.check_circle,
                        text: "2x resolution artwork",
                      ),
                    ],
                  ),
                ),
                // Subscription Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SubscriptionOption(
                        title: "YEARLY ACCESS",
                        subtitle: "Just ₹3,850.00 per year",
                        price: "₹74.04 per week",
                        selected: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SubscriptionOption(
                        title: "WEEKLY ACCESS",
                        subtitle: "",
                        price: "₹690 per week",
                        selected: false,
                      ),
                      const SizedBox(height: 30),
                      // Continue Button
                      GradientButton(
                        text: "FREE TRIAL",
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const ResultPage(
                          //     image:
                          //         "https://i.pinimg.com/originals/e7/3c/b5/e73cb57f5cb5ff7af7ad7730740e1109.jpg",
                          //   ),
                          // ));

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChatPage(),
                          ));
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  FeatureTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool selected;

  SubscriptionOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? Colors.blue : Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        tileColor: selected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 14))
            : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        titleAlignment: ListTileTitleAlignment.top,
        onTap: () {},
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      // height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.blue,
            Color.fromARGB(173, 255, 255, 255),
            Color.fromARGB(204, 86, 171, 240)
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //leftIcon icon
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 25,
              )
            ]),
      ),
    );
  }
}
