import 'package:flutter/material.dart';
import '../../../common/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import '../../common/services/auth_service.dart';

class WebLogin extends StatefulWidget {
  const WebLogin({super.key});

  @override
  _WebLoginState createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> _webLogin() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    setState(() {
      errorMessage = 'Vui lòng điền đầy đủ thông tin';
    });
    return;
  }

  try {
    // Call the auth service to log in
    final result = await authService.login(email, password, context);

    if (result != null) {
      final user = result['data']['user']; // Extract user details from response
      print('User ${user['email']}: ${user['is_complete']}');
      
      if (user['is_complete'] == false) {
        print('User ${user['email']} cần hoàn tất hồ sơ');
        context.go('/complete-profile', extra: {
          'userId': user['id'],
          'fromRegister': false
        });
      } else if (user['role'] == 'ADMIN') { // Check role from `details`
        print('Admin ${user['email']} đăng nhập thành công!');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/admin');
        });
      } else {
        print('${user['email']} đăng nhập thành công trên Website!');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home');
        });
      }
    } else {
      setState(() {
        errorMessage = 'Tài khoản hoặc mật khẩu không chính xác';
      });
    }
  } catch (e) {
    print("Lỗi đăng nhập: $e");
    setState(() {
      errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('HRM',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
                  const Text('Powered by iPOS.vn', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 50),
                  const Text(
                    'Chào mừng bạn\nđến với iPOS HRM\ndành cho Nhân Viên',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Center(
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      const SizedBox(height: 20),
                      buildCustomButton(
                        text: "Login",
                        onPressed: _webLogin,
                        backgroundColor: const Color(0xFF166FB1),
                        textColor: Colors.white,
                      ),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text("Don't have an account? Register"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
