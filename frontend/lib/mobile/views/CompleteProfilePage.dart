// lib/web/views/CompleteProfilePage.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/services/auth_service.dart';

class CompleteProfilePage extends StatefulWidget {
  final int userId;
  final bool fromRegister;
  const CompleteProfilePage({super.key, required this.userId, required this.fromRegister});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedDepartment = "";
  String _errorMessage = "";
  
  final AuthService authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty || _selectedDepartment.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng điền đầy đủ thông tin!";
      });
      return;
    }

    if (!RegExp(r"^\d{10,11}$").hasMatch(phone)) {
      setState(() {
        _errorMessage = "Số điện thoại không hợp lệ!";
      });
      return;
    }

    try {
      final result = await authService.completeProfile(widget.userId, name, phone, _selectedDepartment);
      if (result['status'] == 200) {
        // Nếu hoàn thiện hồ sơ từ quá trình đăng ký, chuyển về trang đăng nhập.
        // Nếu nhập sau khi đăng nhập, chuyển về trang home.
        widget.fromRegister ? context.go('/login') : context.go('/home');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? "Đã xảy ra lỗi!";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Đã xảy ra lỗi: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Hoàn thiện thông tin cá nhân"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedDepartment.isEmpty ? null : _selectedDepartment,
              items: const [
                DropdownMenuItem(value: "Bộ phận phục vụ", child: Text("Bộ phận phục vụ")),
                DropdownMenuItem(value: "Bộ phận pha chế", child: Text("Bộ phận pha chế")),
                DropdownMenuItem(value: "Bộ phận bếp bánh", child: Text("Bộ phận bếp bánh")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value ?? "";
                });
              },
              decoration: InputDecoration(
                labelText: "Chọn bộ phận",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF166FB1),
                ),
                child: const Text("Hoàn tất"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
