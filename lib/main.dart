import 'package:flutter/material.dart';

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
      // لون خلفية التطبيق (داكن لتعزيز بروز الماء)
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF121418)),
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
  // الخانات الثلاثة التي طلبتها
  int selectedIndex = 0;
  final List<IconData> icons = [
    Icons.chat_bubble_rounded, // الرسائل
    Icons.settings_rounded,    // الإعدادات
    Icons.person_rounded,      // الملف الشخصي
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth / icons.length;

    return Scaffold(
      body: Center(
        child: Text(
          _getScreenName(selectedIndex),
          style: const TextStyle(color: Colors.white38, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Stack(
          children: [
            // 1. الحركة السلسة جداً (Apple-like Smoothness)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: selectedIndex.toDouble()),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic, // انسيابية مائية بدون أي اهتزاز
              builder: (context, value, child) {
                final currentPosition = (value + 0.5) * itemWidth;

                return Stack(
                  children: [
                    // رسم السائل (الشريط)
                    CustomPaint(
                      size: Size(screenWidth, 100),
                      painter: LiquidSocketPainter(currentPosition),
                    ),
                    // قطرة الماء المتحركة 3D
                    Positioned(
                      left: currentPosition - 30, // 30 هو نصف عرض القطرة
                      top: 15, // مستوى الغوص في السائل
                      child: const WaterDropItem(),
                    ),
                  ],
                );
              },
            ),

            // 2. الأزرار الشفافة لالتقاط الضغطات وتغيير الأيقونات
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
                        // إخفاء الأيقونة من الشريط إذا كانت القطرة تقف عليها
                        opacity: isSelected ? 0.0 : 1.0,
                        child: Icon(
                          icons[index],
                          color: Colors.white54,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            
            // 3. الأيقونة التي تظهر داخل القطرة المائية
            // مفصولة هنا لتتحرك مع القطرة بسلاسة
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: selectedIndex.toDouble()),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                final currentPosition = (value + 0.5) * itemWidth;
                return Positioned(
                  left: currentPosition - 13, // لضبط الأيقونة في منتصف القطرة
                  top: 31,
                  child: Icon(
                    icons[selectedIndex],
                    color: Colors.white,
                    size: 26,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getScreenName(int index) {
    if (index == 0) return 'المراسلة';
    if (index == 1) return 'الإعدادات';
    return 'الملف الشخصي';
  }
}

// ==========================================
// كلاس خاص بـ "قطرة الماء" الثلاثية الأبعاد
// ==========================================
class WaterDropItem extends StatelessWidget {
  const WaterDropItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // تدرج لوني يحاكي سقوط الضوء على قطرة مياه حقيقية
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.5),
          radius: 0.9,
          colors: [
            Color(0xFF4A4E59), // لمعة الإضاءة من الأعلى
            Color(0xFF23262D), // لون السائل الأساسي
            Color(0xFF0D0F12), // الظل الداخلي العميق
          ],
        ),
        boxShadow: [
          // ظل قطرة الماء على الشريط
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// كلاس خاص برسم السائل المتصل وانحناء المياه
// ==========================================
class LiquidSocketPainter extends CustomPainter {
  final double position;
  LiquidSocketPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF23262D) // نفس لون السائل لدمج القطرة بالشريط
      ..style = PaintingStyle.fill;

    final path = Path();
    const double curveWidth = 110; // عرض الانحناء
    const double curveDepth = 45;  // عمق الغطسة

    final double startX = position - (curveWidth / 2);
    final double endX = position + (curveWidth / 2);

    path.moveTo(0, 0);
    path.lineTo(startX, 0);

    // معادلات فيزيائية لرسم توتر السائل (Liquid Tension)
    path.cubicTo(
      position - 30, 0,
      position - 35, curveDepth,
      position, curveDepth,
    );
    path.cubicTo(
      position + 35, curveDepth,
      position + 30, 0,
      endX, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    // رسم السائل الأساسي
    canvas.drawPath(path, paint);

    // إضافة لمعة خفيفة جداً على حافة السائل من الأعلى للـ 3D
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant LiquidSocketPainter oldDelegate) => true;
}
