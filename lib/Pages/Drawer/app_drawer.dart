import 'package:flutter/material.dart';
import 'about_us_page.dart';
import 'contact_us_page.dart';
import 'Feedback_Support/feedback_support_page.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';
import '../Guide/work_guide_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1F36),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F6EF7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.work_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Trust Hire',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(color: Colors.white12, height: 1),
            ),

            // Nav items
            _DrawerItem(
              icon: Icons.public_outlined,
              label: 'Remote Work Guide',
              onTap: () => _push(context, const RemoteWorkGuidePage()),
            ),
            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'About Us',
              onTap: () => _push(context, const AboutUsPage()),
            ),
            _DrawerItem(
              icon: Icons.mail_outline_rounded,
              label: 'Contact Us',
              onTap: () => _push(context, const ContactUsPage()),
            ),
            _DrawerItem(
              icon: Icons.feedback_outlined,
              label: 'Feedback & Support',
              onTap: () => _push(context, const FeedbackSupportPage()),
            ),
            _DrawerItem(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy Policy',
              onTap: () => _push(context, const PrivacyPolicyPage()),
            ),
            _DrawerItem(
              icon: Icons.description_outlined,
              label: 'Terms & Conditions',
              onTap: () => _push(context, const TermsConditionsPage()),
            ),

            const Spacer(),

            // Version tag at bottom
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.pop(context); // close drawer first
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white24,
        size: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      horizontalTitleGap: 8,
    );
  }
}
