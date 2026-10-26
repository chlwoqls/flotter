import 'package:flutter/material.dart';

void main() => runApp(const GoalLabApp());

class GoalLabApp extends StatelessWidget {
  const GoalLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 03 Goal Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GoalPage(),
    );
  }
}

class StudyGoal {
  StudyGoal({required this.title, this.isDone = false});

  final String title;
  bool isDone;
}

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final TextEditingController _controller = TextEditingController();
  final List<StudyGoal> _goals = [
    StudyGoal(title: 'Flutter 위젯 복습하기'),
    StudyGoal(title: '수용조건 AC1~AC3 확인하기'),
  ];
  String? _errorMessage;

  int get _completedCount => _goals.where((goal) => goal.isDone).length;

  void _addGoal() {
    final title = _controller.text.trim();

    if (title.isEmpty) {
      setState(() => _errorMessage = '목표를 입력하세요');
      return;
    }

    setState(() {
      _goals.add(StudyGoal(title: title));
      _controller.clear();
      _errorMessage = null;
    });
  }

  void _toggleGoal(int index, bool? value) {
    setState(() {
      _goals[index].isDone = value ?? false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 학습 목표'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('$_completedCount/${_goals.length} 완료'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '오늘 할 일을 정리해 보세요.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addGoal(),
                decoration: InputDecoration(
                  labelText: '학습 목표',
                  hintText: '예: Flutter 화면 만들기',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _addGoal,
                icon: const Icon(Icons.add),
                label: const Text('목표 추가'),
              ),
              const SizedBox(height: 16),
              const Text(
                '학습 목록',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _goals.isEmpty
                    ? const Center(child: Text('등록된 목표가 없습니다.'))
                    : ListView.separated(
                        itemCount: _goals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final goal = _goals[index];
                          return Card(
                            child: CheckboxListTile(
                              value: goal.isDone,
                              onChanged: (value) => _toggleGoal(index, value),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                goal.title,
                                style: TextStyle(
                                  decoration: goal.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(goal.isDone ? '완료' : '진행 중'),
                              secondary: Icon(
                                goal.isDone
                                    ? Icons.check_circle
                                    : Icons.flag_outlined,
                                color: goal.isDone ? Colors.green : Colors.indigo,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
