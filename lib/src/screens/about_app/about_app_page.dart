import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Gap(20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/img/QuranLogo.png",
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.2),
                        spreadRadius: 10,
                        blurRadius: 40,
                      ),
                    ]),
                height: 150,
                width: 150,
              ),
            ),
            Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Al Quran (Tafsir & Audio)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: const Text(
                    'A Cross Platform Al Quran application with Translation, Tafsir, and Audio functionalities.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Core Features',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'This application provides the following core functionalities:',
                ),
                const SizedBox(height: 10),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.translate,
                    color: Colors.green,
                  ),
                  title: Text('Quran Translation in 69 Languages'),
                  subtitle: Text(
                      'Access over 120+ Translation Books in various languages.'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.book,
                    color: Colors.green,
                  ),
                  title: Text('Tafsir of Quran in 6 Languages'),
                  subtitle: Text(
                      'Read from 30+ different Tafsir books with different scholars interpretation.'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.audiotrack,
                    color: Colors.green,
                  ),
                  title: Text('Quran Audio'),
                  subtitle: Text(
                      'Listen to the Quran recitation from over 40+ reciters.'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.cloud_upload,
                    color: Colors.green,
                  ),
                  title: Text('Notes with Cloud Backup'),
                  subtitle: Text(
                      'Save notes and keep them backed up to cloud service.'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.screen_share,
                    color: Colors.green,
                  ),
                  title: Text('Cross-Platform Support'),
                  subtitle: Text(
                    'Supported on Android, Web, Linux, and Windows.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.settings_voice,
                    color: Colors.green,
                  ),
                  title: Text('Background Audio Playback'),
                  subtitle: Text(
                    'Continue listening to Quran recitation even when the app is in the background.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.offline_bolt,
                    color: Colors.green,
                  ),
                  title: Text('Audio Caching'),
                  subtitle: Text(
                    'Improved playback and offline capabilities with audio caching feature.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.design_services,
                    color: Colors.green,
                  ),
                  title: Text('Minimalistic & Clean Interface'),
                  subtitle: Text(
                    'Easy to navigate interface with focus on user experience.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.sim_card_download,
                    color: Colors.green,
                  ),
                  title: Text('Smaller App Size'),
                  subtitle: Text(
                    'The application contains a lot of features and documents with smaller app size.',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This app has been built to seek the pleasure of Allah.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technology & Resources',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'This app utilizes the following technologies and resources:',
                ),
                const SizedBox(height: 10),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.audiotrack,
                    color: Colors.green,
                  ),
                  title: Text('Audio Playback'),
                  subtitle: Text(
                    'Powered by the `just_audio` Flutter package for robust audio playback and control.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.headphones,
                    color: Colors.green,
                  ),
                  title: Text('Background Audio'),
                  subtitle: Text(
                    'Implemented using the `just_audio_background` package, enabling background playback and notifications.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.data_usage,
                    color: Colors.green,
                  ),
                  title: Text('Quran Data'),
                  subtitle: Text(
                    'The Al Quran texts are obtained from Quran.com and it\'s developer API.',
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.multitrack_audio,
                    color: Colors.green,
                  ),
                  title: Text('Audio Resources'),
                  subtitle: Text(
                    'The audio files are collected from Everyayah.com and Quran.com\'s audio API.',
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cross Platform Support',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                    'This application is cross platform supported and can be used in '),
                const SizedBox(height: 10),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.android,
                    color: Colors.green,
                  ),
                  title: Text('Android'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.web,
                    color: Colors.green,
                  ),
                  title: Text('Web'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.computer,
                    color: Colors.green,
                  ),
                  title: Text('Linux'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.desktop_windows,
                    color: Colors.green,
                  ),
                  title: Text('Windows'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
