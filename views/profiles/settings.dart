import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/views/brand/add_brand.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/text_style.dart';
import '../home/home_screen.dart';

AuthController authController = Get.put(AuthController());

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: sfBold.copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // _buildSection('Account', [
                //   const Divider(
                //     color: Colors.grey,
                //   ),
                //   _buildSettingItem(Icons.star, 'Generated Posts', Colors.blue,
                //       () async {
                //     await firebaseController.getAllBrand();
                //     Get.to(() => const GeneratedPosts());
                //   }),
                //   const Divider(
                //     color: Colors.grey,
                //   ),
                //   _buildSettingItem(Icons.child_care, 'Brand\'s Profile',
                //       const Color.fromARGB(255, 7, 186, 138), () {
                //     Get.to(() => const ChildProfiles());
                //   }),
                //   const Divider(
                //     color: Colors.grey,
                //   ),
                // ]),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(19)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2), blurRadius: 2),
                      ]),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: Image.network(
                                FirebaseAuth.instance.currentUser!.photoURL!)
                            .image,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.email!,
                        style: sfBold.copyWith(fontSize: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildSection('Academics', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.data_array, 'Your Data', Colors.blue,
                      () {
                    Get.to(() => const StudentManagementScreen(
                          fromProfile: true,
                        ));
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),

                _buildSection('SHARE', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.email, 'Rate us on Play Store', Colors.blue, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.sms, 'Share App',
                      const Color.fromARGB(255, 7, 186, 138), () {
                    Share.share(
                        "Become Future Ready\nDownload Our App and Unleash your Potential");
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.share, 'Give Feedback', Colors.green,
                      () {
                    showBottomSheet(
                        context: context,
                        builder: (context) => const SupportBottomSheet());
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('PRIVACY POLICY', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.lock, 'Privacy Policy', Colors.purple, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.person, 'Terms & Conditions',
                      Colors.blueAccent, () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('UPGRADE TO PREMIUM', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.star, 'Upgrade to Premium',
                      const Color.fromRGBO(197, 73, 44, 1), () {}),
                  const Divider(
                    color: Colors.grey,
                  ),
                ]),
                _buildSection('Account Session', [
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(Icons.logout, 'LogOut', Colors.green, () {
                    authController.logout();
                  }),
                  const Divider(
                    color: Colors.grey,
                  ),
                  _buildSettingItem(
                      Icons.delete, 'Delete Account', Colors.red, () {}),
                  const Divider(
                    color: Colors.grey,
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              title,
              style: sfSemiBold.copyWith(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}


//Caption Generation
//Keywords Suggestion
//Blog Post Generation
//