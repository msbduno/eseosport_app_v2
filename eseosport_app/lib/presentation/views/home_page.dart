import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              'ESEOSPORT',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'PFE DESCRIPTION',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Launch date: September 16, 2024',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'The ESEOSPORT project is an innovative project designed to showcase the technological skills and expertise of ESEO, combining electronics and computer science. This application offers an immersive experience allowing users to explore various aspects of a velomobile and evaluate their physical performance.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      Image.asset('assets/solution.png'),
                      const SizedBox(height: 40),
                      const Text(
                        'The ESEOSPORT project operates through collaboration between several students. An electronics team installs and manages sensors on the velomobile, capturing key data such as speed, elevation, and physiological information.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      Image.asset('assets/hardware.png'),
                      const SizedBox(height: 40),
                      const Text(
                        'This data is then transmitted in real-time to the application via Bluetooth, allowing live display of performance on the user interface.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      Image.asset('assets/software.png'),
                      const SizedBox(height: 40),
                      const Text(
                        'The application also records each route, providing the user with a complete history to analyze their performance and track their progress. This system creates a connected, interactive, and optimized driving experience.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'In collaboration with Cycles JV Fenioux, a velomobile manufacturer, this project is designed to be scalable. It is part of a final year project for ESEO students.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          const url = 'https://www.eseo.fr';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: const Text(
                          'You can visit the ESEO website here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/record');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/activity');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}