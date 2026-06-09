import 'package:flutter/material.dart';
import '../../admin/admin_service.dart';
import '../../admin/feedback_inbox_page.dart';
import '../../admin/job_management_page.dart';
import 'about_us_page.dart';
import 'contact_us_page.dart';
import 'Feedback_Support/feedback_support_page.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';
import '../Guide/work_guide_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await AdminService.isAdmin();
    if (mounted) setState(() => _isAdmin = admin);
  }

  void _push(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1F36),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F6EF7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.work_outline_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Trust Hire',
                      style: TextStyle(
                          color: Colors.white, fontSize: 22,
                          fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(color: Colors.white12, height: 1),
            ),

            // ── General items ────────────────────────────────
            _DrawerItem(
              icon: Icons.public_outlined,
              label: 'Remote Work Guide',
              onTap: () => _push(const RemoteWorkGuidePage()),
            ),
            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'About Us',
              onTap: () => _push(const AboutUsPage()),
            ),
            _DrawerItem(
              icon: Icons.mail_outline_rounded,
              label: 'Contact Us',
              onTap: () => _push(const ContactUsPage()),
            ),
            _DrawerItem(
              icon: Icons.feedback_outlined,
              label: 'Feedback & Support',
              onTap: () => _push(const FeedbackSupportPage()),
            ),
            _DrawerItem(
              icon: Icons.lock_outline_rounded,
              label: 'Privacy Policy',
              onTap: () => _push(const PrivacyPolicyPage()),
            ),
            _DrawerItem(
              icon: Icons.description_outlined,
              label: 'Terms & Conditions',
              onTap: () => _push(const TermsConditionsPage()),
            ),

            // ── Admin section ────────────────────────────────
            if (_isAdmin) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Divider(color: Colors.white12, height: 1),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 6),
                child: Text('ADMIN',
                    style: TextStyle(
                        color: Color(0xFF4F6EF7), fontSize: 11,
                        fontWeight: FontWeight.w800, letterSpacing: 1.2)),
              ),
              _DrawerItem(
                icon: Icons.work_outline_rounded,
                label: 'Job Management',
                onTap: () => _push(const JobManagementPage()),
              ),
              _DrawerItem(
                icon: Icons.inbox_rounded,
                label: 'Feedback Inbox',
                onTap: () => _push(const FeedbackInboxPage()),
              ),
            ],

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('v1.0.0',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      horizontalTitleGap: 8,
    );
  }
}
