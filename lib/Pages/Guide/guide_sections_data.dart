
import 'package:flutter/material.dart';
import 'package:trust_hire_app/Model/guide_section_model.dart';

class GuideSections {

  static const List<GuideSectionModel> all = [

    GuideSectionModel(

      title: 'How to Work Online',

      icon: Icons.laptop_mac_outlined,

      color: Color(0xFF1A56DB),       // ✅ নীল

      points: [],

    ),

    GuideSectionModel(

      title: 'Freelancing Basics',

      icon: Icons.work_outline,

      color: Color(0xFF16A34A),       // ✅ সবুজ — আগে ভুল করে নীল ছিল

      points: [

        '🧑‍💼 Build a strong profile with a professional photo and a bio that explains what problem you solve — not just your skill list.',

        '📝 Write personalized proposals. Address the client\'s exact need in the first two lines and never use copy-paste templates.',

        '🎯 Focus on one niche when starting out. Specialists get hired faster and earn more than generalists.',

        '💰 Set fair rates based on your skill level and market standards. Underpricing hurts your reputation long-term.',

        '⭐ Always ask satisfied clients for a review. A 5-star rating builds trust faster than any portfolio.',

        '📦 Deliver before deadlines whenever possible and communicate proactively — treat every client like a long-term partner.',

      ],

    ),

    GuideSectionModel(

      title: 'Payment Methods',

      icon: Icons.credit_card_outlined,

      color: Color(0xFF7C3AED),       // ✅ বেগুনি — আগে ভুল করে নীল ছিল

      points: [

        '💸 Use Wise for international transfers — it offers near mid-market exchange rates with the lowest fees available.',

        '🔁 Payoneer works great on platforms like Upwork and Fiverr. PayPal is fast but charges 2–5% per withdrawal.',

        '🧾 Always compare fees before withdrawing. Small percentage differences add up to hundreds of dollars over time.',

        '🚨 Never pay a "release fee" to receive your earnings — legitimate clients and platforms will never ask for this.',

        '📊 Request milestone payments for large projects so you are protected if a client disappears mid-way.',

        '🗂️ Keep records of every invoice, payment, and transaction for tax purposes and potential dispute resolution.',

      ],

    ),

    GuideSectionModel(

      title: 'Time Management',

      icon: Icons.access_time_outlined,

      color: Color(0xFFD97706),       // ✅ কমলা — আগে ভুল করে নীল ছিল

      points: [

        '🍅 Use the Pomodoro technique — work 25 minutes, rest 5. After 4 rounds take a 20-minute break. Sprints beat marathons.',

        '📅 Set a fixed daily schedule and treat remote work exactly like an office job. Start and end at the same time every day.',

        '📋 Write your top 3 priorities the night before. Starting with a clear plan removes decision fatigue in the morning.',

        '🔕 Turn off all social media notifications during work blocks. One interruption costs up to 23 minutes of refocus time.',

        '⏱️ Use time-tracking tools like Toggl or Clockify to see where your hours actually go and quote clients more accurately.',

        '🧠 Protect your deep work hours. Schedule calls and admin tasks only during your natural low-energy windows.',

      ],

    ),

    GuideSectionModel(

      title: 'Security Protocols',

      icon: Icons.security_outlined,

      color: Color(0xFFDC2626),       // ✅ লাল — আগে ভুল করে নীল ছিল

      points: [

        '🔐 Enable 2FA on every work account. Use an authenticator app — not SMS, which can be hijacked via SIM-swap attacks.',

        '🌐 Always use a VPN on public Wi-Fi. Coffee shops and airports are prime targets for data interception.',

        '🗝️ Use a password manager like Bitwarden or 1Password. Never reuse passwords — one breach can compromise everything.',

        '🚫 Never share login credentials, API keys, or sensitive files over chat or email. No legitimate platform will ever ask for this.',

        '💾 Back up your work files regularly to an encrypted cloud service and a local external drive.',

        '🎣 Watch out for phishing — always check the actual sender email address before clicking any link or downloading attachments.',

      ],

    ),

  ];

}