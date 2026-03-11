import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const TechCheckApp());
}

class TechCheckApp extends StatelessWidget {
  const TechCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechCheck Ultimate',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFF00FF41),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF41),
          secondary: Color(0xFF00FF41),
        ),
      ),
      home: const GetStartedPage(),
    );
  }
}

// --- 1. GET STARTED PAGE ---
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF002200), Color(0xFF0A0A0A)],
            radius: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.speed_rounded, size: 120, color: Color(0xFF00FF41)),
            const SizedBox(height: 20),
            const Text(
              "TECHCHECK",
              style: TextStyle(
                fontSize: 35, 
                fontWeight: FontWeight.w900, // PERBAIKAN: Dari .black ke .w900
                letterSpacing: 8,
              ),
            ),
            const Text("ULTIMATE DIAGNOSTIC SYSTEM v3.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF41),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => const MainNavigation()),
              ),
              child: const Text("MULAI ANALISIS", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. MAIN NAVIGATION ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  // State data user agar bisa diakses di Home dan Setting
  String userName = "M. Ilham Satriawan";
  String userEmail = "ilham@uty.ac.id";

  void _updateProfile(String name, String email) {
    setState(() {
      userName = name;
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman diletakkan di dalam build agar data userName terbaru selalu terupdate
    final List<Widget> pages = [
      HomePage(name: userName),
      const SearchDiagnosticPage(),
      SettingPage(name: userName, email: userEmail, onSave: _updateProfile),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFF00FF41),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.developer_board), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_suggest), label: "Setting"),
        ],
      ),
    );
  }
}

// --- 3. HOME PAGE (DETAIL SPECS) ---
class HomePage extends StatelessWidget {
  final String name;
  const HomePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DEVICE OVERVIEW"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Welcome, $name", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00FF41))),
          const SizedBox(height: 20),
          _buildDetailCard("Processor", [
            {"k": "Model", "v": "Snapdragon 8 Gen 3"},
            {"k": "Cores", "v": "8-Core (1x3.3 GHz & 5x3.2 GHz)"},
            {"k": "Arch", "v": "64-bit Armv9-A"},
          ]),
          _buildDetailCard("Memory Status", [
            {"k": "RAM Total", "v": "12 GB LPDDR5X"},
            {"k": "Available", "v": "4.2 GB"},
            {"k": "Type", "v": "UFS 4.0 Storage"},
          ]),
          _buildDetailCard("Display Info", [
            {"k": "Resolution", "v": "1440 x 3200 (WQHD+)"},
            {"k": "Refresh Rate", "v": "120 Hz (Adaptive)"},
            {"k": "PPI", "v": "522 Pixel Per Inch"},
          ]),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Map<String, String>> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF00FF41), fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['k']!, style: const TextStyle(color: Colors.grey)),
                  Text(item['v']!, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// --- 4. SEARCH PAGE (DIAGNOSTIC LIST) ---
class SearchDiagnosticPage extends StatefulWidget {
  const SearchDiagnosticPage({super.key});
  @override
  State<SearchDiagnosticPage> createState() => _SearchDiagnosticPageState();
}

class _SearchDiagnosticPageState extends State<SearchDiagnosticPage> {
  final List<Map<String, dynamic>> _allTests = [
    {"n": "Dead Pixel Test", "i": Icons.color_lens, "c": Colors.red, "p": const ColorTestPage()},
    {"n": "Touch Trace", "i": Icons.touch_app, "c": Colors.blue, "p": const TouchTestPage()},
    {"n": "Network Speed", "i": Icons.speed, "c": Colors.teal, "p": const NetworkSpeedPage()},
    {"n": "Speaker Check", "i": Icons.volume_up, "c": Colors.purple, "p": const SpeakerTestPage()},
    {"n": "Vibration Test", "i": Icons.vibration, "c": Colors.orange, "p": const VibrationTestPage()},
    {"n": "Light Sensor", "i": Icons.light_mode, "c": Colors.yellow, "p": const LightSensorPage()},
  ];

  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    _filtered = _allTests;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DIAGNOSTIC LAB")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _filtered = _allTests.where((t) => t['n'].toLowerCase().contains(v.toLowerCase())).toList()),
              decoration: InputDecoration(
                hintText: "Cari tes hardware...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (c, i) => ListTile(
                leading: Icon(_filtered[i]['i'], color: _filtered[i]['c']),
                title: Text(_filtered[i]['n']),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => _filtered[i]['p'])),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- 5. SETTING PAGE (EDIT PROFILE) ---
class SettingPage extends StatefulWidget {
  final String name;
  final String email;
  final Function(String, String) onSave;

  const SettingPage({super.key, required this.name, required this.email, required this.onSave});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;

  @override
  void initState() {
    nameCtrl = TextEditingController(text: widget.name);
    emailCtrl = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("USER SETTINGS")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Color(0xFF00FF41), child: Icon(Icons.person, size: 50, color: Colors.black)),
            const SizedBox(height: 30),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Alamat Email", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF41),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                widget.onSave(nameCtrl.text, emailCtrl.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil Berhasil Diupdate!")));
              },
              child: const Text("SIMPAN PERUBAHAN", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const GetStartedPage()), (r) => false),
              child: const Text("LOGOUT DEVICE", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}

// --- FITUR TES: SPEED TEST ---
class NetworkSpeedPage extends StatefulWidget {
  const NetworkSpeedPage({super.key});
  @override
  State<NetworkSpeedPage> createState() => _NetworkSpeedPageState();
}

class _NetworkSpeedPageState extends State<NetworkSpeedPage> {
  double speed = 0.0;
  bool running = false;
  void start() {
    setState(() { running = true; speed = 0.0; });
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() => speed += 3.2);
      if (speed >= 124.5) { t.cancel(); running = false; }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internet Speed")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${speed.toStringAsFixed(1)} Mbps", style: const TextStyle(fontSize: 60, color: Color(0xFF00FF41), fontWeight: FontWeight.bold)),
            const Text("DOWNLOAD SPEED"),
            const SizedBox(height: 50),
            ElevatedButton(onPressed: running ? null : start, child: Text(running ? "Measuring..." : "RUN TEST"))
          ],
        ),
      ),
    );
  }
}

// --- FITUR TES: TOUCH TEST ---
class TouchTestPage extends StatefulWidget {
  const TouchTestPage({super.key});
  @override
  State<TouchTestPage> createState() => _TouchTestPageState();
}

class _TouchTestPageState extends State<TouchTestPage> {
  final List<Offset?> _points = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Touch Trace")),
      body: GestureDetector(
        onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
        onPanEnd: (d) => setState(() => _points.add(null)),
        child: CustomPaint(painter: SmoothPainter(_points), size: Size.infinite),
      ),
    );
  }
}

class SmoothPainter extends CustomPainter {
  final List<Offset?> points;
  SmoothPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF00FF41)..strokeWidth = 5..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) canvas.drawLine(points[i]!, points[i+1]!, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

// --- FITUR TES: COLOR, SOUND, VIBRATE, LIGHT ---
class ColorTestPage extends StatefulWidget {
  const ColorTestPage({super.key});
  @override
  State<ColorTestPage> createState() => _ColorTestPageState();
}

class _ColorTestPageState extends State<ColorTestPage> {
  int i = 0;
  final colors = [Colors.red, Colors.green, Colors.blue, Colors.white, Colors.black];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => i < colors.length - 1 ? setState(() => i++) : Navigator.pop(context),
      child: Scaffold(backgroundColor: colors[i]),
    );
  }
}

class SpeakerTestPage extends StatefulWidget {
  const SpeakerTestPage({super.key});
  @override
  State<SpeakerTestPage> createState() => _SpeakerTestPageState();
}

class _SpeakerTestPageState extends State<SpeakerTestPage> {
  bool play = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Speaker Check")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.graphic_eq, size: 100, color: play ? Colors.purple : Colors.grey),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => setState(() => play = !play), child: Text(play ? "STOP AUDIO" : "PLAY TEST TONE")),
          ],
        ),
      ),
    );
  }
}

class VibrationTestPage extends StatefulWidget {
  const VibrationTestPage({super.key});
  @override
  State<VibrationTestPage> createState() => _VibrationTestPageState();
}

class _VibrationTestPageState extends State<VibrationTestPage> {
  bool active = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vibration Motor")),
      body: Center(
        child: ElevatedButton(onPressed: () => setState(() => active = !active), child: Text(active ? "STOP VIBRATING" : "START VIBRATING")),
      ),
    );
  }
}

class LightSensorPage extends StatefulWidget {
  const LightSensorPage({super.key});
  @override
  State<LightSensorPage> createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  double lux = 0.5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.black, Colors.white, lux),
      appBar: AppBar(title: const Text("Light Sensor Simulator")),
      body: Center(child: Slider(value: lux, onChanged: (v) => setState(() => lux = v))),
    );
  }
}