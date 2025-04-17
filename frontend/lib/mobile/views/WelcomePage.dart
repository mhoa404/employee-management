import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_circle, color: Color(0xFFFFC013), size: 30),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_drop_down, size: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'HRM',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  'Powered by iPOS.vn',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 120),
              const Center(
                child: Text(
                  'Chào mừng bạn\nđến với iPOS HRM\ndành cho Nhân Viên',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              const Column(
                children: [
                  Text("Bạn có tài khoản HRM Nhân Viên chưa?"),
                  SizedBox(height: 10),
                  AuthButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthButtons extends StatelessWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildCustomButton(
            text: 'Đăng ký ngay',
        onPressed: () {
              context.go('/register');
        },
            backgroundColor: Colors.white,
            textColor: const Color(0xFF166FB1),
            borderColor: const Color(0xFF166FB1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildCustomButton(
            text: 'Đăng nhập',
            onPressed: () {
              context.go('/login');
    },
            backgroundColor: const Color(0xFF166FB1),
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

}
