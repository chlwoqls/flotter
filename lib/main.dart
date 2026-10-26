import 'package:flutter/material.dart';

void main() {
<<<<<<< HEAD
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
=======
  runApp(const StateAssignmentApp());
}

class StateAssignmentApp extends StatelessWidget {
  const StateAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5주차 상태 기능 과제',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TaskStatusPage(),
    );
  }
}

class TaskStatusPage extends StatefulWidget {
  const TaskStatusPage({super.key});

  @override
  State<TaskStatusPage> createState() => _TaskStatusPageState();
}

class _TaskStatusPageState extends State<TaskStatusPage> {
  // 원본 상태: 완료 여부만 저장한다.
  bool _isCompleted = false;

  // 계산값: 별도로 저장하지 않고 원본 상태에서 계산한다.
  String get _statusText => _isCompleted ? '완료' : '미완료';
  IconData get _statusIcon =>
      _isCompleted ? Icons.check_circle : Icons.radio_button_unchecked;

  void _toggleStatus() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _isCompleted ? Colors.green : Colors.blueGrey;

    return Scaffold(
      appBar: AppBar(title: const Text('상태 기능 과제')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '오늘의 할 일',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Icon(_statusIcon, size: 56, color: statusColor),
                  const SizedBox(height: 12),
                  Text(
                    '현재 상태: $_statusText',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _toggleStatus,
                    icon: Icon(
                      _isCompleted ? Icons.undo : Icons.check,
                    ),
                    label: Text(_isCompleted ? '완료 취소' : '완료하기'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '버튼을 누르면 상태가 바뀌고, 다시 누르면 원래 상태로 돌아옵니다.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
>>>>>>> ff33d80e7cdbf1ab969f6eb58e5f7f6dc7d65418
    );
  }
}
