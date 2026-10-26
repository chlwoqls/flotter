import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const NoticeApp());
}

class NoticeApp extends StatelessWidget {
  const NoticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '크로스플랫폼 실시간 공지사항 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const NoticeHomeScreen(),
    );
  }
}

// 공지사항 데이터 모델
class NoticeItem {
  final int id;
  final String title;
  final String category;
  final String date;

  NoticeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
  });
}

class NoticeHomeScreen extends StatefulWidget {
  const NoticeHomeScreen({super.key});

  @override
  State<NoticeHomeScreen> createState() => _NoticeHomeScreenState();
}

class _NoticeHomeScreenState extends State<NoticeHomeScreen> {
  List<NoticeItem> _noticeList = [];
  bool _isLoadingList = true;

  // [Isolate 관련 상태]
  bool _isProcessingIsolate = false;
  String _isolateResult = "대용량 공지사항 데이터 백그라운드 연산을 실행해 보세요.";

  // [Stream 관련] 실시간 긴급 속보 스트림 컨트롤러
  late final StreamController<String> _emergencyStreamController;
  Timer? _emergencyTimer;

  @override
  void initState() {
    super.initState();
    _emergencyStreamController = StreamController<String>.broadcast();

    // 1. [async / await] 초기 공지 데이터 수신
    _loadInitialNotices();

    // 3. [Stream] 5초마다 실시간 속보 데이터 전송 시작
    _startEmergencyBroadcaster();
  }

  @override
  void dispose() {
    _emergencyTimer?.cancel();
    _emergencyStreamController.close();
    super.dispose();
  }

  // ===========================================================================
  // 1. [async / await] 앱 초기화 시 공지사항 목록 비동기 로딩
  // ===========================================================================
  Future<void> _loadInitialNotices() async {
    setState(() => _isLoadingList = true);

    // 서버 비동기 API 통신 지연 시뮬레이션 (1.5초)
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _noticeList = [
        NoticeItem(
            id: 101,
            title: '[안내] 2026년 4분기 시스템 정기 점검 일정',
            category: '점검',
            date: '2026.10.19'),
        NoticeItem(
            id: 102,
            title: '[업데이트] 비동기 엔진 기능 개선 및 보안 패치',
            category: '업데이트',
            date: '2026.10.15'),
        NoticeItem(
            id: 103,
            title: '[필독] 개인정보 처리방침 개정 및 동의 안내',
            category: '약관',
            date: '2026.10.01'),
        NoticeItem(
            id: 104,
            title: '[이벤트] 신규 회원 대상 서비스 가입 혜택 안내',
            category: '이벤트',
            date: '2026.09.28'),
      ];
      _isLoadingList = false;
    });
  }

  // ===========================================================================
  // 2. [Future] 공지사항 단건 상세 조회 (FutureBuilder와 연동)
  // ===========================================================================
  Future<Map<String, String>> _fetchNoticeDetail(int noticeId) async {
    // 1초 서버 통신 지연
    await Future.delayed(const Duration(seconds: 1));

    return {
      'content': '공지사항 #$noticeId 번의 본문 내용입니다.\n\n'
          '이 내용은 Future 개념을 사용하여 비동기로 데이터를 요청하고, '
          'FutureBuilder 위젯을 통해 화면에 전달받아 표시됩니다.',
      'writer': '관리자',
      'views': '1,284회',
    };
  }

  // ===========================================================================
  // 3. [Stream] 5초마다 실시간 긴급 속보 메시지 전송
  // ===========================================================================
  void _startEmergencyBroadcaster() {
    int count = 1;
    _emergencyTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_emergencyStreamController.isClosed) {
        _emergencyStreamController.add(
            '🚨 [실시간 긴급 속보 #$count] 새로운 보안 공지사항이 등록되었습니다. (${DateTime.now().second}초)');
        count++;
      }
    });
  }

  // ===========================================================================
  // 4. [Isolate] 대용량 데이터 검수/인덱싱 백그라운드 연산 (UI JANK 방지)
  // ===========================================================================
  static String _heavyNoticeDataProcessing(int taskCount) {
    // UI 스레드를 멈출 수 있는 복잡한 대량 데이터 가공 작업
    int calculatedHash = 0;
    for (int i = 0; i < taskCount; i++) {
      calculatedHash += (i * 3) % 7;
    }

    return "대용량 공지 데이터 백그라운드 분석 완료!\n"
        "• 총 처리 항목 수: ${taskCount}개\n"
        "• 데이터 해시 검증값: $calculatedHash\n"
        "• (Isolate 독립 스레드 연산으로 UI 멈춤 없음)";
  }

  Future<void> _runIsolateProcess() async {
    setState(() {
      _isProcessingIsolate = true;
      _isolateResult = "독립된 Isolate 스레드에서 5,000만 개 데이터 검수 중...";
    });

    // Isolate.run으로 UI 스레드 멈춤 없이 연산 처리
    final result = await Isolate.run(
      () => _heavyNoticeDataProcessing(50000000),
    );

    setState(() {
      _isolateResult = result;
      _isProcessingIsolate = false;
    });
  }

  // ===========================================================================
  // UI 레이아웃 구성 (크로스플랫폼 가로 분할 뷰)
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 통합 공지사항 센터'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialNotices,
            tooltip: '공지목록 새로고침 (async/await)',
          )
        ],
      ),
      body: Column(
        children: [
          // [StreamBuilder 영역] 상단 실시간 속보 브로드캐스트 배너
          Container(
            color: Colors.amber.shade100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: StreamBuilder<String>(
              stream: _emergencyStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      const Icon(Icons.campaign, color: Colors.deepOrange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          snapshot.data!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }
                return const Text('📡 [Stream] 실시간 긴급 속보 채널 연결 중...');
              },
            ),
          ),

          // 메인 콘텐츠 뷰 (좌우 2분할 레이아웃)
          Expanded(
            child: Row(
              children: [
                // 좌측 공지사항 목록
                Expanded(
                  flex: 3,
                  child: _isLoadingList
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('async/await 로 공지사항 불러오는 중...'),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _noticeList.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _noticeList[index];
                            return ListTile(
                              leading: Chip(
                                label: Text(item.category),
                                backgroundColor: Colors.blue.shade50,
                              ),
                              title: Text(item.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text('작성일: ${item.date}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _showNoticeDetailDialog(item),
                            );
                          },
                        ),
                ),

                const VerticalDivider(width: 1),

                // 우측 Isolate 백그라운드 연산 테스트 영역
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚙️ Isolate 백그라운드 엔진',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '대량 데이터 검수 연산을 메인 UI 스레드 영향 없이 Isolate로 처리합니다.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _isProcessingIsolate
                              ? null
                              : _runIsolateProcess,
                          icon: const Icon(Icons.memory),
                          label: const Text('Isolate 대량 데이터 처리'),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: _isProcessingIsolate
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 12),
                                        Text('Isolate 연산 실행 중...'),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Text(
                                      _isolateResult,
                                      style: const TextStyle(height: 1.5),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // [FutureBuilder 구역] 공지 상세 보기 팝업 창
  void _showNoticeDetailDialog(NoticeItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.title),
          content: FutureBuilder<Map<String, String>>(
            future: _fetchNoticeDetail(item.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Future 상세 데이터 수신 중...'),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('오류 발생: ${snapshot.error}');
              } else {
                final data = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('작성자: ${data['writer']}'),
                        const Spacer(),
                        Text('조회수: ${data['views']}'),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(data['content'] ?? ''),
                  ],
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            )
          ],
        );
      },
    );
  }
}