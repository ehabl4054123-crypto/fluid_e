import 'package:flutter/material.dart';
import 'water_drop_button.dart';

// الدالة الأساسية لتشغيل التطبيق
void main() {
  runApp(const FluidEApp());
}

class FluidEApp extends StatelessWidget {
  const FluidEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fluid_e',
      debugShowCheckedModeBanner: false,
      // تحديد لون الخلفية الداكن
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1E1E1E)),
      home: const Scaffold(
        body: Center(
          child: Text('fluid_e Native UI', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        // استدعاء شريط التنقل المخصص
        bottomNavigationBar: FluidNavBar(),
      ),
    );
  }
}

// تصميم هيكل شريط التنقل
class FluidNavBar extends StatelessWidget {
  const FluidNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. خلفية الشريط نفسه
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
          ),
          // 2. زر قطرة الماء (مرفوع قليلاً للأعلى)
          const Positioned(
            top: -20, left: 0, right: 0,
            child: Center(child: WaterDropButton()),
          ),
        ],
      ),
    );
  }
}

