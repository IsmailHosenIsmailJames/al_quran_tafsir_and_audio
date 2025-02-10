import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDevelopedApps extends StatelessWidget {
  const MyDevelopedApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Developed Apps'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => launchUrl(
              Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.ismail_hosen_james.al_bayan_quran'),
            ),
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://raw.githubusercontent.com/IsmailHosenIsmailJames/al_quran_tafsir_and_audio/refs/heads/main/assets/img/QuranLogo.png',
                  ),
                ),
              ),
            ),
            title: const Text(
              'Al Quran Tafsir and Audio',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: const Text(
              'All in one Al Quran App with Translation, Tefsir, Quran Audio Book & Notes Backup',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            ),
          ),
          ListTile(
            onTap: () => launchUrl(
              Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.ismail_hosen.quran_audio'),
            ),
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://raw.githubusercontent.com/IsmailHosenIsmailJames/quran_audio/refs/heads/main/assets/AlQuranAudio.jpg',
                  ),
                ),
              ),
            ),
            title: const Text(
              'Al Quran Audio',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: const Text(
              'The Quran Audio Recitation App brings together a curated collection of 79 reciters, providing an immersive auditory experience of the Quran.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            ),
          ),
          ListTile(
            onTap: () => launchUrl(
              Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.rust_book.example'),
            ),
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://raw.githubusercontent.com/IsmailHosenIsmailJames/rust_book_multi_language/refs/heads/main/assets/img/logo.png',
                  ),
                ),
              ),
            ),
            title: const Text(
              'Rust Book',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: const Text(
              'A Cross Platform & 16 language supported App thats help Rust learners to increase their learning speed.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            ),
          ),
          ListTile(
            onTap: () => launchUrl(
              Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.rust_doc.md_ismail_hosen'),
            ),
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://play-lh.googleusercontent.com/_LSmIDVNFv3kplD5OEOmg0a3-rKYv3lj6oPlaOV6bHcIUYeYL5jcLXYyWXy17OHE_TQ=w240-h480-rw',
                  ),
                ),
              ),
            ),
            title: const Text(
              'Rust Doc - Everything',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: const Text(
              'Al in one app for Rust programming Language learners. This app contains each and evry documentation that came with Rust installation with lot of others features.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            ),
          ),
          ListTile(
            onTap: () => launchUrl(
              Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.rust_std.md_ismail_hosen'),
            ),
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://play-lh.googleusercontent.com/jAHyGvkFohth9zHwngB_YYS0kcfj5357LhDaeUKQX_ObSKpLE-R_M8RpWUj4GECo2Sk=w240-h480-rw',
                  ),
                ),
              ),
            ),
            title: const Text(
              'Rust STD & Core',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: const Text(
              'Al in one app for Rust programming Language learners. This app contains each and evry documentation that came with Rust installation with lot of others features.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
