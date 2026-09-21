import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. 학습 목표 객체 (데이터와 상태 변경 규칙인 toggle 책임을 함께 가짐)
class StudyGoal {
  StudyGoal(this.title);

  final String title;
  bool _isDone = false;

  bool get isDone => _isDone;

  void toggle() {
    _isDone = !_isDone;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Goal App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const StudyGoalPage(),
    );
  }
}

class StudyGoalPage extends StatefulWidget {
  const StudyGoalPage({super.key});

  @override
  State<StudyGoalPage> createState() => _StudyGoalPageState();
}

class _StudyGoalPageState extends State<StudyGoalPage> {
  final TextEditingController _controller = TextEditingController();
  final List<StudyGoal> _goals = [];
  String? _errorMessage;

  // 목표 추가 및 검증 로직 (AC1, AC2)
  void _addGoal() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = "목표를 입력하세요";
      });
      return;
    }

    setState(() {
      _goals.add(StudyGoal(text));
      _controller.clear();
      _errorMessage = null;
    });
  }

  // 완료 상태 전환 로직 (AC3)
  void _toggleGoal(StudyGoal goal) {
    setState(() {
      goal.toggle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('나의 학습 목표 관리')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 입력 영역
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '학습 목표 입력',
                errorText: _errorMessage,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addGoal,
              child: const Text('목표 추가'),
            ),
            const SizedBox(height: 24),
            // 목록 표시 영역
            Expanded(
              child: _goals.isEmpty
                  = const Center(child: Text('등록된 목표가 없습니다.'))
                  : ListView.builder(
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        final goal = _goals[index];
                        return ListTile(
                          leading: Checkbox(
                            value: goal.isDone,
                            onChanged: (bool? value) {
                              _toggleGoal(goal); // AC3 연결
                            },
                          ),
                          title: Text(
                            goal.title,
                            style: TextStyle(
                              decoration: goal.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}