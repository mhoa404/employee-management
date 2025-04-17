import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../common/services/auth_service.dart';

class AdminWorkRequests extends StatefulWidget {
  const AdminWorkRequests({Key? key}) : super(key: key);

  @override
  _AdminWorkRequestsState createState() => _AdminWorkRequestsState();
}

class _AdminWorkRequestsState extends State<AdminWorkRequests> {
  List<dynamic> workRequests = [];
  IO.Socket? socket;
  final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchPendingRequests();
    initializeSocket();
  }

  void initializeSocket() {
    socket = IO.io(baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.on("connect", (_) {
      print("Socket connected: ${socket!.id}");
    });
    socket!.on("newWorkRequest", (data) {
      print("Received new work request via socket: $data");
      fetchPendingRequests();
    });
    socket!.on("disconnect", (_) => print("Socket disconnected"));
  }

  Future<void> fetchPendingRequests() async {
    try {
      final token = authService.token;
      final response = await http.get(Uri.parse("$baseUrl/work-request/pending"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          workRequests = data["data"];
        });
      }
    } catch (e) {
      print("Error fetching pending requests: $e");
    }
  }

  Future<void> approveRequest(int requestId) async {
    try {
      final token = authService.token;
      final response = await http.patch(Uri.parse("$baseUrl/work-request/approve/$requestId"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Work request approved")),
        );
        fetchPendingRequests();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Approve error: $e")),
      );
    }
  }

  Future<void> rejectRequest(int requestId, String reason) async {
    try {
      final token = authService.token;
      final response = await http.patch(Uri.parse("$baseUrl/work-request/reject/$requestId"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode({"reason": reason}));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Work request rejected")),
        );
        fetchPendingRequests();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reject error: $e")),
      );
    }
  }

  void showRejectDialog(int requestId) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reject Work Request"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: "Enter reason for rejection",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              rejectRequest(requestId, reasonController.text);
              Navigator.of(context).pop();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Widget buildWorkRequestCard(dynamic request) {
    DateTime weekStart = DateTime.parse(request["week_start"]);
    String formattedWeekStart =
        "${weekStart.day.toString().padLeft(2, '0')}/${weekStart.month.toString().padLeft(2, '0')}/${weekStart.year}";
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Employee: ${request["user"]["email"]}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Week Start: $formattedWeekStart"),
            const SizedBox(height: 8.0),
            const Text("Schedule:", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              child: ListView(
                children: request["schedule"].entries.map<Widget>((entry) {
                  String day = entry.key;
                  List<dynamic> periods = entry.value;
                  return Text("$day: ${periods.join(', ')}");
                }).toList(),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => showRejectDialog(request["id"]),
                  child: const Text("Reject", style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => approveRequest(request["id"]),
                  child: const Text("Approve"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return workRequests.isEmpty 
      ? const Center(child: Text("No pending work requests"))
      : ListView.builder(
          itemCount: workRequests.length,
          itemBuilder: (context, index) {
            return buildWorkRequestCard(workRequests[index]);
          },
        );
  }
}
