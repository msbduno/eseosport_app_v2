# ESEOSPORT

## Objectif
ESEOSPORT est une application mobile développée avec Flutter.  
Elle permet de récupérer des données via Bluetooth, de les afficher en temps réel et de gérer un historique.  
Un backend Spring Boot peut être utilisé pour le stockage des activités et des statistiques.

---

## Technologies utilisées
- Flutter / Dart  
- Plugins Bluetooth (flutter_blue, flutter_reactive_ble)  
- Spring Boot  
- PostgreSQL   
- Git / GitHub

---

## Architecture du projet

### Frontend (Flutter)

lib/

models/ — Données (Bluetooth, historique…)

blocs/ — Logique métier (BLoC)

viewmodels/ — Logique UI

views/ — Écrans

widgets/ — Composants réutilisables

main.dart — Point d’entrée de l’application



### Backend (Spring Boot)

src/

controllers/ — Endpoints REST

services/ — Logique métier

repositories/ — Accès aux données

models/ — Entités

config/ — Configuration


---

## Bluetooth
- Scan des appareils BLE  
- Connexion à l’appareil cible  
- Lecture de données via UUID de service et de caractéristique  
- Traitement local et affichage en temps réel  
- Envoi possible vers le backend

Paramètres utilisés :


SERVICE_UUID = "1111"
CHARACTERISTIC_UUID = "2222"


---

## Installation et lancement

### Prérequis
- Flutter installé  
- Android Studio ou VS Code  
- (Optionnel) PostgreSQL pour le backend  

### Cloner le projet


git clone https://github.com/msbduno/eseosport_app_v2.git


### Commandes Flutter


- flutter doctor
- flutter pub get
- flutter run


### Backend
Ouvrir le projet backend dans IntelliJ.  
Configurer la base PostgreSQL si nécessaire.

---

## Bonnes pratiques
- Architecture MVVM + BLoC  
- Conventions de nommage Dart  
- Tests unitaires, intégration et UI  
- Gestion du code via Git (feat, fix, refactor)

---

## Base de données et UML
- Modélisation basée sur Utilisateur, Activité et DataPoint  
- Script SQL disponible dans la documentation  
- Diagramme de classes générable avec l’outil dcdg

---

## Ajout d'images
Placez vos images dans un dossier `/assets` ou `/docs` et ajoutez-les ainsi :
