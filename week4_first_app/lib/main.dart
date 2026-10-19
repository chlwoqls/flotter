import 'package:flutter/material.dart';

void main() => runApp(const WidgetLabApp());

class WidgetLabApp extends StatelessWidget {
  const WidgetLabApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Week 04 Widget Lab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const WidgetLabPage(),
      );
}

class StudyItem {
  StudyItem({required this.title, this.isDone = false});
  final String title;
  bool isDone;
}

class WidgetLabPage extends StatefulWidget {
  const WidgetLabPage({super.key});

  @override
  State<WidgetLabPage> createState() => _WidgetLabPageState();
}

class _WidgetLabPageState extends State<WidgetLabPage> {
  final List<StudyItem> _items = [
    StudyItem(title: 'Flutter 위젯 역할 복습'),
    StudyItem(title: 'Row와 Column 차이 정리'),
    StudyItem(title: '버튼 이벤트 실행해 보기'),
  ];

  int get _completedCount => _items.where((item) => item.isDone).length;

  void _toggleItem(int index, bool? checked) {
    setState(() => _items[index].isDone = checked ?? false);
  }

  void _addItem() {
    setState(() => _items.add(StudyItem(title: '새 학습 항목 ${_items.length + 1}')));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('학습 항목을 추가했습니다.')),
    );
  }

  void _resetItems() {
    setState(() {
      for (final item in _items) {
        item.isDone = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 항목을 미완료로 바꿨습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _items.length;
    final progress = total == 0 ? 0.0 : _completedCount / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 학습'),
        actions: [
          IconButton(
            tooltip: '완료 상태 초기화',
            onPressed: _resetItems,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.school, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('학습 진행 상황',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('$_completedCount / $total개 완료'),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(value: progress),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text('학습 목록',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  FilledButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('추가'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _items.isEmpty
                    ? const Center(child: Text('학습 항목이 없습니다.'))
                    : ListView.separated(
                        itemCount: _items.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            child: CheckboxListTile(
                              value: item.isDone,
                              onChanged: (checked) => _toggleItem(index, checked),
                              controlAffinity: ListTileControlAffinity.leading,
                              secondary: Icon(
                                item.isDone ? Icons.check_circle : Icons.menu_book,
                                color: item.isDone ? Colors.green : Colors.indigo,
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  decoration: item.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(item.isDone ? '완료' : '진행 전'),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _resetItems,
                icon: const Icon(Icons.restart_alt),
                label: const Text('전체 완료 상태 원복'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
