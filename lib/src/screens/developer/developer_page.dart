import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Developer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Gap(15),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/dev/99122172.jpeg'),
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  spreadRadius: 10,
                  blurRadius: 40,
                ),
              ],
            ),
          ),
          const Gap(20),
          const Center(
            child: Text(
              'Ismail Hossain',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'I am programmer who try to learn new things everyday. Focused on Full Stack Cross Platform supported Application development using flutter. I also love to play with IOT',
            textAlign: TextAlign.center,
          ),
          const Gap(20),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 40, right: 40),
            leading: const Icon(
              SimpleIcons.github,
            ),
            title: const Text(
              'Github',
            ),
            trailing: const Icon(
              Icons.link,
            ),
            onTap: () => launchUrl(
              Uri.parse(
                'https://github.com/IsmailHosenIsmailJames',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 40, right: 40),
            leading: Icon(
              SimpleIcons.linkedin,
              color: Colors.blue.shade700,
            ),
            title: const Text(
              'LinkedIn',
            ),
            trailing: const Icon(
              Icons.link,
            ),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.linkedin.com/in/ismail-hosen-james-3756a4211/',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 40, right: 40),
            leading: const Icon(
              SimpleIcons.facebook,
              color: Colors.blue,
            ),
            title: const Text(
              'Facebook',
            ),
            trailing: const Icon(
              Icons.link,
            ),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.facebook.com/IsmailHossainJames',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 40, right: 40),
            leading: const Icon(
              SimpleIcons.twitter,
              color: Colors.blue,
            ),
            title: const Text(
              'Twitter',
            ),
            trailing: const Icon(
              Icons.link,
            ),
            onTap: () => launchUrl(
              Uri.parse(
                'https://x.com/MDIsmailHo3357/',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 40, right: 40),
            leading: const Icon(
              SimpleIcons.gmail,
              color: Colors.red,
            ),
            title: const Text(
              'Email',
            ),
            trailing: const Icon(
              Icons.link,
            ),
            onTap: () => launchUrl(
              Uri.parse(
                'mailto:md.ismailhosenismailjames@gmail.com',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
