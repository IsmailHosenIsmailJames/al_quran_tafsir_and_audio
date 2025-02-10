import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Gap(30),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      spreadRadius: 8,
                      blurRadius: 20,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/img/QuranLogo.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Al Quran (Tafsir & Audio)',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(15),
                Center(
                  child: Text(
                    'A Cross-Platform Al Quran application enriched with Translation, Tafsir, and Audio functionalities to help you understand and connect with the Holy Quran.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const Gap(30),
            const Divider(thickness: 1.5),
            const Gap(30),
            Card(
              elevation: 0,
              color: Colors.red.withValues(alpha: 0.1),
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Note: Quran, Tafsir & Audio are sourced from quran.com & everyayah.com',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.orange.shade800,
                      ),
                ),
              ),
            ),
            Gap(10),
            Card(
              elevation: 0,
              color: Colors.green.withValues(alpha: 0.1),
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'This app has been built to seek the pleasure of Allah. So, No Adds will appear',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.green.shade800,
                      ),
                ),
              ),
            ),
            const Gap(30),
            const Divider(thickness: 1.5),
            const Gap(30),
            Text(
              'Core Features',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(15),
            const Text(
              'Explore the key functionalities that make this application a valuable tool for Quranic study:',
            ),
            const Gap(15),
            const FeatureTile(
              icon: Icons.translate,
              title: 'Quran Translation in 69 Languages',
              subtitle:
                  'Access over 120+ Translation Books in various languages.',
            ),
            const FeatureTile(
              icon: Icons.book,
              title: 'Tafsir of Quran in 6 Languages',
              subtitle:
                  'Read from 30+ different Tafsir books with different scholars interpretation.',
            ),
            const FeatureTile(
              icon: Icons.audiotrack,
              title: 'Quran Audio',
              subtitle:
                  'Listen to the Quran recitation from over 40+ reciters.',
            ),
            const FeatureTile(
              icon: Icons.cloud_upload,
              title: 'Notes with Cloud Backup',
              subtitle: 'Save notes and keep them backed up to cloud service.',
            ),
            const FeatureTile(
              icon: Icons.screen_share,
              title: 'Cross-Platform Support',
              subtitle: 'Supported on Android, Web, Linux, and Windows.',
            ),
            const FeatureTile(
              icon: Icons.settings_voice,
              title: 'Background Audio Playback',
              subtitle:
                  'Continue listening to Quran recitation even when the app is in the background.',
            ),
            const FeatureTile(
              icon: Icons.offline_bolt,
              title: 'Audio Caching',
              subtitle:
                  'Improved playback and offline capabilities with audio caching feature.',
            ),
            const FeatureTile(
              icon: Icons.design_services,
              title: 'Minimalistic & Clean Interface',
              subtitle:
                  'Easy to navigate interface with focus on user experience.',
            ),
            const FeatureTile(
              icon: Icons.sim_card_download,
              title: 'Smaller App Size',
              subtitle:
                  'The application contains a lot of features and documents with smaller app size.',
            ),
            const Gap(20),
            const Gap(30),
            const Divider(thickness: 1.5),
            const Gap(30),
            Text(
              'Language Support',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(15),
            const Text(
              'This application is designed to be accessible to a global audience with support for the following languages (and more are continuously being added):',
            ),
            const Gap(15),
            const Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Chip(label: Text('English')),
                Chip(label: Text('Arabic')),
                Chip(label: Text('Urdu')),
                Chip(label: Text('French')),
                Chip(label: Text('German')),
                Chip(label: Text('Spanish')),
                Chip(label: Text('Indonesian')),
                Chip(label: Text('Malay')),
                Chip(label: Text('Turkish')),
                Chip(label: Text('Bengali')),
                Chip(label: Text('Russian')),
                Chip(label: Text('Chinese')),
                Chip(label: Text('Japanese')),
                Chip(label: Text('Korean')),
                Chip(label: Text('Persian')),
                Chip(label: Text('Italian')),
                Chip(label: Text('Dutch')),
                Chip(label: Text('Portuguese')),
                Chip(label: Text('Hindi')),
                Chip(label: Text('Swahili')),
              ],
            ),
            const Gap(30),
            const Divider(thickness: 1.5),
            const Gap(30),
            Text(
              'Technology & Resources',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(15),
            const Text(
              'This app is built using cutting-edge technologies and reliable resources:',
            ),
            const Gap(15),
            const FeatureTile(
              icon: Icons.audiotrack,
              title: 'Audio Playback',
              subtitle:
                  'Powered by the `just_audio` Flutter package for robust audio playback and control.',
            ),
            const FeatureTile(
              icon: Icons.headphones,
              title: 'Background Audio',
              subtitle:
                  'Implemented using the `just_audio_background` package, enabling background playback and notifications.',
            ),
            const FeatureTile(
              icon: Icons.data_usage,
              title: 'Quran Data',
              subtitle:
                  'The Al Quran texts are obtained from Quran.com and it\'s developer API.',
            ),
            const FeatureTile(
              icon: Icons.multitrack_audio,
              title: 'Audio Resources',
              subtitle:
                  'The audio files are collected from Everyayah.com and Quran.com\'s audio API.',
            ),
            const Gap(30),
            const Divider(thickness: 1.5),
            const Gap(30),
            Text(
              'Cross Platform Support',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(15),
            const Text(
              'Enjoy seamless access across various platforms:',
            ),
            const Gap(15),
            const PlatformTile(icon: Icons.android, title: 'Android'),
            const PlatformTile(icon: Icons.web, title: 'Web'),
            const PlatformTile(icon: Icons.computer, title: 'Linux'),
            const PlatformTile(icon: Icons.desktop_windows, title: 'Windows'),
            const Gap(30),
            const Divider(thickness: 1.5),
            const Gap(30),
            Card(
              elevation: 0,
              color: Colors.green.withValues(alpha: 0.1),
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_rounded,
                        color: Colors.green, size: 40),
                    const Gap(15),
                    Text(
                      'Our Lifetime Promise',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(15),
                    Text(
                      'I personally promise to provide continuous support and maintenance for this application throughout my life, In Sha Allah. My goal is to ensure this app remains a beneficial resource for the Ummah for years to come.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.grey.withValues(alpha: 0.1),
        leading: Icon(
          icon,
          color: Colors.green,
          size: 32,
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class PlatformTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const PlatformTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.grey.withValues(alpha: 0.1),
        leading: Icon(
          icon,
          color: Colors.green,
          size: 32,
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
