import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'sans-serif'),
      home: const VictimStoriesPage(),
    );
  }
}

class CaseData {
  final String initials, name, subtitle, riskLabel, quote, views, category;
  final Color avatarColor, riskColor, riskTextColor, borderColor;
  final List<String> wentWrong, howToAvoid;
  final String? amountLost;

  CaseData({
    required this.initials, required this.name, required this.subtitle,
    required this.riskLabel, required this.quote, required this.views,
    required this.category, required this.avatarColor, required this.riskColor,
    required this.riskTextColor, required this.borderColor,
    required this.wentWrong, required this.howToAvoid, this.amountLost,
  });
}

List<CaseData> allCases = [
  CaseData(
    initials: 'AT', name: 'Anika Tarannum', subtitle: 'CSE student · Sylhet',
    riskLabel: 'High risk', category: 'High risk',
    avatarColor: const Color(0xFFE8D5C4), riskColor: const Color(0xFFFFEBEB),
    riskTextColor: const Color(0xFFE05C5C), borderColor: const Color(0xFFE05C5C),
    quote: '"I paid ৳5,000 registration fee for a remote internship. After payment, they blocked me on WhatsApp instantly."',
    wentWrong: ['Upfront fee demanded', 'WhatsApp contact only', 'No interview held'],
    howToAvoid: ['Never pay before joining', 'Verify on LinkedIn', 'Demand an interview'],
    amountLost: '৳ 5,000', views: '1.2k views',
  ),
  CaseData(
    initials: 'M', name: 'Maisha', subtitle: 'Fresh graduate · Dhaka',
    riskLabel: 'Medium risk', category: 'Remote',
    avatarColor: const Color(0xFFD4C5E2), riskColor: const Color(0xFFFFF8E1),
    riskTextColor: const Color(0xFFD4A017), borderColor: const Color(0xFFD4A017),
    quote: '"They offered ৳80,000/month with zero experience. The email was from gmail.com — I almost applied."',
    wentWrong: ['Unrealistic salary', 'Free gmail domain'],
    howToAvoid: ['Research market rates', 'Check official domain'],
    amountLost: null, views: '2.4k views',
  ),
  CaseData(
    initials: 'S', name: 'Srabonti', subtitle: 'Student · Rajshahi',
    riskLabel: 'High risk', category: 'Internship',
    avatarColor: const Color(0xFFC8E6C9), riskColor: const Color(0xFFFFEBEB),
    riskTextColor: const Color(0xFFE05C5C), borderColor: const Color(0xFFE05C5C),
    quote: '"They promised a paid internship but asked for ৳3,000 first for training materials. Never heard from them again."',
    wentWrong: ['Asked for money upfront', 'No company website', 'Vague job description'],
    howToAvoid: ['Never pay for internships', 'Check company on Google', 'Ask for offer letter first'],
    amountLost: '৳ 3,000', views: '980 views',
  ),
];

class VictimStoriesPage extends StatefulWidget {
  const VictimStoriesPage({super.key});

  @override
  State<VictimStoriesPage> createState() => _VictimStoriesPageState();
}

class _VictimStoriesPageState extends State<VictimStoriesPage> {
  String _selected = 'All stories';

  @override
  Widget build(BuildContext context) {
    final filtered = allCases.where((c) =>
    _selected == 'All stories' || c.category == _selected).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: const Icon(Icons.crop_square, color: Colors.grey),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.crop_square, color: Colors.grey))],
        title: const Text('Victim Stories', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Real scam stories', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Learn from others — stay protected', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatCard(value: '1,240', label: 'Scams reported', valueColor: const Color(0xFFE05C5C)),
                const SizedBox(width: 8),
                _StatCard(value: '৳18L+', label: 'Total lost', valueColor: const Color(0xFFD4A017)),
                const SizedBox(width: 8),
                _StatCard(value: '890', label: 'Blocked', valueColor: const Color(0xFF4CAF50)),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All stories', 'High risk', 'Internship', 'Remote'].map((label) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = label),
                      child: _FilterChip(label: label, selected: _selected == label),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent cases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AllCasesPage()));
                    setState(() {});
                  },
                  child: Text('See all →', style: TextStyle(color: Colors.green[700], fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...filtered.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CaseCard(data: c),
            )),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareStoryPage()));
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.shield_outlined, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Protect someone today', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('Share your experience and help thousands of students avoid the same mistake.',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareStoryPage()));
          setState(() {});
        },
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(color: Color(0xFFE05C5C), shape: BoxShape.circle),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Share your story', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class AllCasesPage extends StatelessWidget {
  const AllCasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('All Cases', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allCases.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _CaseCard(data: allCases[i]),
        ),
      ),
    );
  }
}

class CaseDetailPage extends StatelessWidget {
  final CaseData data;
  const CaseDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(data.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(backgroundColor: data.avatarColor, radius: 30,
                    child: Text(data.initials, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(data.subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border(left: BorderSide(color: data.borderColor, width: 4)),
              ),
              child: Text(data.quote, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15)),
            ),
            const SizedBox(height: 20),
            const Text('What went wrong', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...data.wentWrong.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.cancel, color: Color(0xFFE05C5C), size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
                ],
              ),
            )),
            const SizedBox(height: 16),
            const Text('How to avoid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...data.howToAvoid.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
                ],
              ),
            )),
            if (data.amountLost != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFFFF0F0), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount lost', style: TextStyle(color: Color(0xFFE05C5C), fontWeight: FontWeight.w600)),
                    Text(data.amountLost!, style: const TextStyle(color: Color(0xFFE05C5C), fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ShareStoryPage extends StatefulWidget {
  const ShareStoryPage({super.key});

  @override
  State<ShareStoryPage> createState() => _ShareStoryPageState();
}

class _ShareStoryPageState extends State<ShareStoryPage> {
  final _nameController = TextEditingController();
  final _storyController = TextEditingController();
  String _selectedCategory = 'High risk';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Share Your Story', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your name', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(
              children: ['High risk', 'Internship', 'Remote'].map((label) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = label),
                    child: _FilterChip(label: label, selected: _selectedCategory == label),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Your story', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _storyController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe what happened...',
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                if (_nameController.text.isEmpty || _storyController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                  return;
                }
                allCases.insert(0, CaseData(
                  initials: _nameController.text[0].toUpperCase(),
                  name: _nameController.text,
                  subtitle: 'Submitted · Bangladesh',
                  riskLabel: _selectedCategory,
                  category: _selectedCategory,
                  avatarColor: const Color(0xFFB2DFDB),
                  riskColor: const Color(0xFFFFEBEB),
                  riskTextColor: const Color(0xFFE05C5C),
                  borderColor: const Color(0xFFE05C5C),
                  quote: '"${_storyController.text}"',
                  wentWrong: ['Reported by user'],
                  howToAvoid: ['Stay alert'],
                  amountLost: null,
                  views: '0 views',
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your story has been submitted!'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                child: const Center(
                  child: Text('Submit Story', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color valueColor;
  const _StatCard({required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? Colors.black : Colors.grey.shade300),
      ),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 13)),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final CaseData data;
  const _CaseCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(top: BorderSide(color: data.borderColor, width: 3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: data.avatarColor, radius: 22,
                  child: Text(data.initials, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(data.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: data.riskColor, borderRadius: BorderRadius.circular(6)),
                child: Text(data.riskLabel, style: TextStyle(color: data.riskTextColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: data.borderColor, width: 3)),
            ),
            child: Text(data.quote, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.black87)),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _InfoBox(title: 'WENT WRONG', items: data.wentWrong,
                  titleColor: const Color(0xFFE05C5C), bgColor: const Color(0xFFFFF0F0))),
              const SizedBox(width: 8),
              Expanded(child: _InfoBox(title: 'HOW TO AVOID', items: data.howToAvoid,
                  titleColor: const Color(0xFF4CAF50), bgColor: const Color(0xFFF0FFF0))),
            ],
          ),
          if (data.amountLost != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFFFFF0F0), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount lost', style: TextStyle(color: Color(0xFFE05C5C), fontWeight: FontWeight.w600)),
                  Text(data.amountLost!, style: const TextStyle(color: Color(0xFFE05C5C), fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(data.views, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CaseDetailPage(data: data))),
                child: Text('Read full case →', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color titleColor, bgColor;
  const _InfoBox({required this.title, required this.items, required this.titleColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 11)),
          const SizedBox(height: 6),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: titleColor, fontWeight: FontWeight.bold)),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 12))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}