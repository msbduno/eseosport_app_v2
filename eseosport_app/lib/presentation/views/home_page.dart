import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background color to white
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // Remove the back arrow
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'DESCRIPTION FIFE',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Date de lancement : 16 septembre 2024',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Le projet ESEOSPORT est un projet  innovant conçu pour illustrer les compétences technologiques et les savoir-faire de l’ESEO regroupant électronique et informatique. Cette application propose une expérience immersive permettant aux utilisateurs d’explorer divers aspects d’un vélomobile et d évaluer leur performances physique. ',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Le projet ESEOSPORT fonctionne grâce à une collaboration entre plusieurs étudiants. Une équipe électronique installe et gère des capteurs sur le vélomobile, capturant des données clés comme la vitesse, le dénivelé et des informations physiologiques. ',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Ces données sont ensuite transmises en temps réel à l’application via Bluetooth, permettant un affichage en direct des performances sur l’interface utilisateur.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'L’application enregistre également chaque parcours, offrant à l’utilisateur un historique complet pour analyser ses performances et suivre sa progression. Ce système crée une expérience de conduite connectée, interactive et optimisée.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'En collaboration avec Cycles JV Fenioux, fabricant de vélomobiles, ce projet est conçu pour être évolutif. Il s’inscrit dans le cadre d’un projet de fin d’études pour les étudiants de l’ESEO.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Pour plus de détails veuillez consulter notre site web',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Vous pouvez consulter le site de l’ESEO ici',
                        style: TextStyle(fontSize: 14),
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
          }else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}