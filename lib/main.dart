import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const FluidWaterApp());
}

class FluidWaterApp extends StatelessWidget {
  const FluidWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Liquid UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0A192F)),
      home: const PureLiquidNavBar(),
    );
  }
}

class PureLiquidNavBar extends StatefulWidget {
  const PureLiquidNavBar({super.key});

  @override
  State<PureLiquidNavBar> createState() => _PureLiquidNavBarState();
}

class _PureLiquidNavBarState extends State<PureLiquidNavBar> {
  int selectedIndex = 0;
  final List<IconData> icons = [
    Icons.chat_bubble_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  // قائمة الشاشات التي سيتم التنقل بينها
  final List<Widget> _screens = [
    const ChatScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth / icons.length;

    return Scaffold(
      // عرض الشاشة بناءً على الأيقونة المحددة
      body: _screens[selectedIndex],
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Stack(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: selectedIndex.toDouble()),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                final currentPosition = (value + 0.5) * itemWidth;
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(screenWidth, 100),
                      painter: LiquidSocketPainter(currentPosition),
                    ),
                    Positioned(
                      left: currentPosition - 30,
                      top: 15,
                      child: const WaterDropItem(),
                    ),
                  ],
                );
              },
            ),
            Row(
              children: List.generate(icons.length, (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: itemWidth,
                    height: 100,
                    child: Center(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isSelected ? 0.0 : 1.0,
                        child: Icon(icons[index], color: Colors.white.withOpacity(0.6), size: 26),
                      ),
                    ),
                  ),
                );
              }),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: selectedIndex.toDouble()),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                final currentPosition = (value + 0.5) * itemWidth;
                return Positioned(
                  left: currentPosition - 13,
                  top: 31,
                  child: Icon(icons[selectedIndex], color: Colors.white, size: 26),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WaterDropItem extends StatelessWidget {
  const WaterDropItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.5), radius: 0.9,
          colors: [Color(0xFF89EEFF), Color(0xFF00A8E8), Color(0xFF005C8A)],
        ),
        boxShadow: [BoxShadow(color: const Color(0xFF002233).withOpacity(0.6), blurRadius: 12, offset: const Offset(0, 8))],
      ),
    );
  }
}

class LiquidSocketPainter extends CustomPainter {
  final double position;
  LiquidSocketPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF00A8E8)..style = PaintingStyle.fill;
    final path = Path();
    const double curveWidth = 110;
    const double curveDepth = 45;
    final double startX = position - (curveWidth / 2);
    final double endX = position + (curveWidth / 2);
    path.moveTo(0, 0); path.lineTo(startX, 0);
    path.cubicTo(position - 30, 0, position - 35, curveDepth, position, curveDepth);
    path.cubicTo(position + 35, curveDepth, position + 30, 0, endX, 0);
    path.lineTo(size.width, 0); path.lineTo(size.width, size.height); path.lineTo(0, size.height); path.close();
    canvas.drawPath(path, paint);
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    canvas.drawPath(path, highlightPaint);
  }
  @override
  bool shouldRepaint(covariant LiquidSocketPainter oldDelegate) => true;
}
