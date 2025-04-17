import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/services/auth_service.dart';

/// Widget hiển thị lịch làm việc của người dùng.
/// Dữ liệu ca làm được lấy từ backend theo tuần hiện tại (đăng ký pending hoặc approved).
class WebScheduleBox extends StatefulWidget {
  const WebScheduleBox({Key? key}) : super(key: key);

  @override
  _WebScheduleBoxState createState() => _WebScheduleBoxState();
}

class _WebScheduleBoxState extends State<WebScheduleBox> {
  // registrationMode: true → chế độ đăng ký mới (người dùng chọn ca)
  // false → chế độ xem (lấy dữ liệu schedule đã đăng ký từ backend)
  bool registrationMode = false;

  // Thay vì dùng ma trận boolean, ta dùng ma trận chứa String? (null nếu chưa chọn, "pending" hoặc "approved")
  late List<List<String?>> cellStatus;
  late DateTime currentMonday;

  // Đây là dữ liệu schedule của tuần hiện tại được lấy từ backend.
  // Cấu trúc: { "YYYY-MM-DD": { "morning": "pending"/"approved", "afternoon": "pending"/"approved", "evening": "pending"/"approved" } }
  Map<String, Map<String, String>> _registeredSchedule = {};

  @override
  void initState() {
    super.initState();
    // Khởi tạo ma trận 3x7 với giá trị null.
    cellStatus = List.generate(3, (_) => List.generate(7, (_) => null));
    final now = DateTime.now();
    // Tính ngày thứ Hai của tuần hiện tại.
    currentMonday = now.subtract(Duration(days: now.weekday - 1));
    // Nếu đang ở chế độ view, ta gọi lấy dữ liệu lịch đăng ký.
    if (!registrationMode) {
      _fetchRegisteredSchedule();
    }
  }

  /// Gọi API để lấy lịch làm việc của user cho tuần hiện tại.
  Future<void> _fetchRegisteredSchedule() async {
    try {
      String weekStartStr = currentMonday.toIso8601String().split("T")[0];
      final token = authService.token;
      // Ví dụ endpoint lấy schedule của user cho tuần, điều chỉnh URL nếu cần.
      final response = await http.get(
        Uri.parse('http://localhost:3000/work-request/my-schedule?week_start=$weekStartStr'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        // Giả sử API trả về dữ liệu dạng:
        // { "data": { "2025-04-21": {"morning": "pending", "afternoon": "approved", "evening": "pending"}, ... } }
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData.containsKey("data")) {
          setState(() {
            _registeredSchedule = Map<String, Map<String, String>>.from(
              (jsonData["data"] as Map).map((key, value) =>
                  MapEntry(key, Map<String, String>.from(value))),
            );
            // Sau khi có _registeredSchedule, thiết lập lại ma trận các ô.
            _setupCellStatus();
          });
        }
      } else {
        throw Exception("Fetch schedule failed: ${response.body}");
      }
    } catch (e) {
      // Có thể thông báo lỗi hoặc log ra console.
      print("Error fetching registered schedule: $e");
    }
  }

  /// Cập nhật trạng thái các ô dựa vào dữ liệu _registeredSchedule.
  void _setupCellStatus() {
    List<DateTime> weekDays =
        List.generate(7, (index) => currentMonday.add(Duration(days: index)));
    for (int col = 0; col < 7; col++) {
      String dateKey = weekDays[col].toIso8601String().split("T")[0];
      if (_registeredSchedule.containsKey(dateKey)) {
        Map<String, String> periodsStatus = _registeredSchedule[dateKey]!;
        for (int row = 0; row < 3; row++) {
          String period = row == 0
              ? "morning"
              : row == 1
                  ? "afternoon"
                  : "evening";
          if (periodsStatus.containsKey(period)) {
            cellStatus[row][col] = periodsStatus[period]; // "pending" hoặc "approved"
          } else {
            cellStatus[row][col] = null;
          }
        }
      } else {
        // Nếu không có dữ liệu cho ngày đó, reset về null
        for (int row = 0; row < 3; row++) {
          cellStatus[row][col] = null;
        }
      }
    }
  }

  void _goToPreviousWeek() {
    setState(() {
      currentMonday = currentMonday.subtract(const Duration(days: 7));
      // Reset ma trận và lấy lại dữ liệu mới cho tuần đó.
      cellStatus = List.generate(3, (_) => List.generate(7, (_) => null));
      // Nếu ở view mode, gọi API để lấy schedule của tuần mới.
      if (!registrationMode) {
        _fetchRegisteredSchedule();
      }
    });
  }

  void _goToNextWeek() {
    setState(() {
      currentMonday = currentMonday.add(const Duration(days: 7));
      cellStatus = List.generate(3, (_) => List.generate(7, (_) => null));
      if (!registrationMode) {
        _fetchRegisteredSchedule();
      }
    });
  }

  void _resetRegistration() {
    setState(() {
      registrationMode = false;
      _fetchRegisteredSchedule(); // Lấy lại dữ liệu từ backend.
    });
  }

  Future<void> _submitWorkRequest() async {
    List<DateTime> weekDays =
        List.generate(7, (index) => currentMonday.add(Duration(days: index)));
    Map<String, List<String>> schedule = {};
    List<String> periodKeys = ['morning', 'afternoon', 'evening'];
    for (int col = 0; col < 7; col++) {
      String dateKey = weekDays[col].toIso8601String().split("T")[0];
      List<String> periods = [];
      for (int row = 0; row < 3; row++) {
        if (cellStatus[row][col] != null) {
          periods.add(periodKeys[row]);
        }
      }
      schedule[dateKey] = periods;
    }

    String weekStartStr = currentMonday.toIso8601String().split("T")[0];
    Map<String, dynamic> requestPayload = {
      'request_type': 'register',
      'week_start': weekStartStr,
      'schedule': schedule,
      'reason': ''
    };

    try {
      final token = authService.token;
      final response = await http.post(
        Uri.parse('http://localhost:3000/work-request/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(requestPayload),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Work request registered successfully!")),
        );
        setState(() {
          registrationMode = false;
        });
        // Sau khi đăng ký thành công, gọi lại API lấy schedule để cập nhật giao diện.
        _fetchRegisteredSchedule();
      } else {
        throw Exception("Request failed: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error while submitting work request: $e")),
      );
    }
  }

  void _onRegister() {
    _submitWorkRequest();
  }

  final ScrollController scrollController = ScrollController();

  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 220,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 220,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// Lấy màu nền của ô dựa vào trạng thái.
  Color _getCellColor(String? status) {
    if (registrationMode) {
      return status != null ? Colors.yellow : Colors.white;
    } else {
      if (status == "pending") {
        return Colors.yellow;
      } else if (status == "approved") {
        return Colors.blue;
      } else {
        return Colors.grey.shade200;
      }
    }
  }

  /// Lấy kiểu chữ của ô (in đậm nếu có trạng thái).
  TextStyle _getCellTextStyle(String? status) {
    return TextStyle(
      color: Colors.black,
      fontWeight: status != null ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays =
        List.generate(7, (index) => currentMonday.add(Duration(days: index)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: tiêu đề, nút chuyển tuần và nút chuyển đổi giữa đăng ký và xem
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Lịch làm việc của bạn",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPreviousWeek,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _goToNextWeek,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: registrationMode ? Colors.blue : Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      registrationMode = !registrationMode;
                      if (registrationMode) {
                        // Reset các ô khi chuyển sang đăng ký.
                        cellStatus = List.generate(3, (_) => List.generate(7, (_) => null));
                      } else {
                        // Nếu chuyển về view mode, cập nhật lại theo dữ liệu từ backend.
                        _fetchRegisteredSchedule();
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: registrationMode ? Colors.grey.shade200 : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  TableRow(
                    children: List.generate(7, (col) {
                      String formattedDate =
                          "${weekDays[col].day.toString().padLeft(2, '0')}/${weekDays[col].month.toString().padLeft(2, '0')}";
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        color: Colors.black87,
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    }),
                  ),
                  for (int row = 0; row < 3; row++)
                    TableRow(
                      children: List.generate(7, (col) {
                        String? status = cellStatus[row][col];
                        return GestureDetector(
                          onTap: registrationMode
                              ? () {
                                  setState(() {
                                    // Khi đang ở đăng ký mode, toggle giữa chưa chọn và "pending"
                                    cellStatus[row][col] = cellStatus[row][col] == null
                                        ? "pending"
                                        : null;
                                  });
                                }
                              : null,
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _getCellColor(status),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Text(
                              row == 0
                                  ? "Ca sáng"
                                  : row == 1
                                      ? "Ca chiều"
                                      : "Ca tối",
                              style: _getCellTextStyle(status),
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              registrationMode
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _resetRegistration,
                          child: const Text("Hủy"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _onRegister,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text("Đăng ký"),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
