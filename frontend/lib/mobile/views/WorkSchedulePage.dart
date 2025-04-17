import 'package:flutter/material.dart';

class WorkSchedulePage extends StatefulWidget {
  const WorkSchedulePage({Key? key}) : super(key: key);

  @override
  State<WorkSchedulePage> createState() => _WorkSchedulePageState();
}

class _WorkSchedulePageState extends State<WorkSchedulePage> {
  String? _selectedShift;
  DateTime? _selectedDate;
  String? _reason;
  String? _editReason;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAddForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đăng kí ca làm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedShift,
                items: const [
                  DropdownMenuItem(value: "Ca sáng", child: Text("Ca sáng")),
                  DropdownMenuItem(value: "Ca tối", child: Text("Ca tối")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedShift = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Chọn ca"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickDate(context),
                child: const Text("Chọn ngày"),
              ),
              if (_selectedDate != null)
                Text("Ngày đã chọn: ${_selectedDate!.toLocal()}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                // Mock adding schedule data
                if (_selectedShift != null && _selectedDate != null) {
                  print("Added Schedule: $_selectedShift, $_selectedDate");
                }
                Navigator.pop(context);
              },
              child: const Text("Hoàn thành"),
            ),
          ],
        );
      },
    );
  }

  void _showEditForm(Map<String, dynamic> schedule) {
    _selectedShift = schedule['shift'];
    _selectedDate = schedule['date'];

    _editReason = schedule['reason'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chỉnh sửa ca làm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedShift,
                items: const [
                  DropdownMenuItem(value: "Ca sáng", child: Text("Ca sáng")),
                  DropdownMenuItem(value: "Ca tối", child: Text("Ca tối")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedShift = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Chọn ca"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickDate(context),
                child: const Text("Chọn ngày"),
              ),
              if (_selectedDate != null)
                Text("Ngày đã chọn: ${_selectedDate!.toLocal()}"),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  _editReason = value;
                },
                decoration: const InputDecoration(
                  labelText: "Lí do thay đổi",
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: _editReason),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                // Mock updating schedule data
                if (_selectedShift != null && _selectedDate != null) {
                  print("Updated Schedule: $_selectedShift, $_selectedDate, $_editReason");
                }
                Navigator.pop(context);
              },
              child: const Text("Cập nhật"),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveForm(Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đăng kí nghỉ"),
          content: TextField(
            onChanged: (value) {
              _reason = value;
            },
            decoration: const InputDecoration(
              labelText: "Lí do xin nghỉ",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                // Mock deleting schedule after adding leave reason
                if (_reason != null) {
                  print("Leave Reason: $_reason");
                  print("Deleted Schedule: ${schedule['shift']}");
                }
                Navigator.pop(context);
              },
              child: const Text("Hoàn thành"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for schedules
    final List<Map<String, dynamic>> schedules = [
      {
        'shift': 'Ca sáng',
        'date': DateTime.now(),
        'reason': 'Có việc gia đình',
      },
      {
        'shift': 'Ca tối',
        'date': DateTime.now().add(Duration(days: 1)),
        'reason': '',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Làm"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: schedules.map((schedule) {
            // Check shift and choose corresponding gradient
            LinearGradient gradient;
            Color textColor;

            if (schedule['shift'] == 'Ca tối') {
              gradient = LinearGradient(
                colors: [Color(0xFFA33757), Color(0xFF852E4E), Color(0xFF4C1D3D)],
              );
              textColor = Colors.white;
            } else {
              gradient = LinearGradient(
                colors: [Color(0xFFFFBB94), Color(0xFFFB9590), Color(0xFFDC586D)],
              );
              textColor = Colors.black;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: gradient, // Apply gradient background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule['shift'],
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor), // Text color based on shift
                        ),
                        Text(
                          schedule['date'].toString(),
                          style: TextStyle(color: textColor), // Text color based on shift
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Edit icon with background
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Black with opacity
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _showEditForm(schedule),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete icon with background
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Black with opacity
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => _showLeaveForm(schedule),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
