import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const FluidEApp());
}

class FluidEApp extends StatelessWidget {
  const FluidEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fluid_e 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.chat_bubble_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية التطبيق (تدرج لوني فخم لإبراز تأثير الزجاج)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: const Center(
          child: Text('3D Fluid Meniscus UI', 
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.5)),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _build3DFluidNavBar(),
    );
  }

  Widget _build3DFluidNavBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    // حساب المسافة لكل أيقونة
    final double itemWidth = screenWidth / icons.length; 
    
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          // 1. الشريط الزجاجي مع الانحناء المائي (Fluid Socket)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: selectedIndex.toDouble()),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut, // حركة فيزيائية مرنة
            builder: (context, value, child) {
              final currentPosition = (value + 0.5) * itemWidth;
              
              return Stack(
                children: [
                  // تأثير الزجاج الضبابي (Glassmorphism)
                  ClipPath(
                    clipper: FluidClipper(currentPosition),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.4), // لون زجاجي داكن
                      ),
                    ),
                  ),
                  // حدود لامعة للشريط (Glossy Border)
                  CustomPaint(
                    size: Size(screenWidth, 100),
                    painter: FluidPainter(currentPosition),
                  ),
                  // 2. الكرة ثلاثية الأبعاد (3D Orb)
                  Positioned(
                    left: currentPosition - 30, // 30 هو نصف عرض الكرة
                    top: 15, // غوص الكرة داخل التجويف
                    child: const Sphere3D(),
                  ),
                ],
              );
            },
          ),
          
          // 3. الأيقونات التفاعلية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: itemWidth,
                  height: 100,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(top: isSelected ? 30 : 0),
                      child: Icon(
                        icons[index],
                        size: isSelected ? 28 : 24,
                        color: isSelected ? Colors.cyanAccent : Colors.white54,
                        shadows: isSelected 
                          ? [const BoxShadow(color: Colors.cyanAccent, blurRadius: 10)] 
                          : [],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// === مكون الكرة 3D (الجرافيك العالي) ===
class Sphere3D extends StatelessWidget {
  const Sphere3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // التدرج الدائري لصنع إضاءة كروية 3D (نقطة ضوء من الأعلى)
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.5),
          radius: 0.8,
          colors: [
            Colors.white, // نقطة اللمعان
            Colors.cyan.shade400, // اللون الأساسي
            const Color(0xFF003344), // الظل السفلي للكرة
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
        boxShadow: [
          // التوهج الخارجي للكرة (Glow)
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
          // الظل السفلي العميق
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

// === حسابات مسار الانحناء (الرياضيات) ===
class FluidClipper extends CustomClipper<Path> {
  final double position;
  FluidClipper(this.position);

  @override
  Path getClip(Size size) {
    return _generateFluidPath(size, position);
  }
  @override
  bool shouldReclip(covariant FluidClipper oldClipper) => true;
}

class FluidPainter extends CustomPainter {
  final double position;
  FluidPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final path = _generateFluidPath(size, position);
    // رسم خط علوي مضيء خفيف يعطي إحساس السطح الزجاجي (Highlight)
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant FluidPainter oldDelegate) => true;
}

Path _generateFluidPath(Size size, double position) {
  final path = Path();
  const double curveWidth = 130;
  const double curveDepth = 45;

  final double startX = position - (curveWidth / 2);
  final double endX = position + (curveWidth / 2);

  path.moveTo(0, 0);
  path.lineTo(startX - 20, 0);

  // الانحناء السلس (Meniscus)
  path.cubicTo(
    startX, 0,
    position - 35, curveDepth,
    position, curveDepth,
  );
  path.cubicTo(
    position + 35, curveDepth,
    endX, 0,
    endX + 20, 0,
  );

  path.lineTo(size.width, 0);
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();
  
  return path;
}
