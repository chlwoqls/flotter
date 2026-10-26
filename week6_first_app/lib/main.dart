import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CryptoDashboardApp());
}

class CryptoDashboardApp extends StatelessWidget {
  const CryptoDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto & Stock Dashboard',
      debugShowCheckedModeBanner: false,
      // [UI/UX] 다크 모드 기반 고급 금융 대시보드 테마 설정
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12141C),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF1E2230),
          primary: Color(0xFF6C5CE7),
          secondary: Color(0xFF00CEC9),
        ),
        cardColor: const Color(0xFF1E2230),
        dividerColor: const Color(0xFF2D3446),
      ),
      home: const DashboardScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 데이터 모델 정의
// -----------------------------------------------------------------------------
class CryptoItem {
  final String symbol;
  final String name;
  double price;
  double changePercent;

  CryptoItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 상태 관리 변수
  List<CryptoItem> _cryptoList = [];
  CryptoItem? _selectedCrypto;
  bool _isInitLoading = true;

  // [Isolate 관련 연산 상태 변수]
  bool _isCalculatingMa = false;
  String _maAnalysisResult = "종목을 선택한 후 이동평균선(MA) 계산 버튼을 눌러주세요.";

  // [Stream] 실시간 체결 및 시세 변동 스트림 컨트롤러
  late final StreamController<List<CryptoItem>> _marketStreamController;
  Timer? _tickerTimer;

  @override
  void initState() {
    super.initState();
    _marketStreamController = StreamController<List<CryptoItem>>.broadcast();

    // 1. [async / await] 사용: 초기 자산 및 종목 목록 로드
    _initDashboardData();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _marketStreamController.close();
    super.dispose();
  }

  // ===========================================================================
  // 1. [async / await] 앱 초기화 시 사용자 보유 자산 & 기본 관심 종목 데이터 로딩
  // ===========================================================================
  Future<void> _initDashboardData() async {
    setState(() => _isInitLoading = true);

    // 네트워크/DB 비동기 조회 지연 시뮬레이션 (1.5초)
    await Future.delayed(const Duration(milliseconds: 1500));

    // 초기 종목 데이터 구성
    _cryptoList = [
      CryptoItem(symbol: 'BTC', name: '비트코인', price: 92500.0, changePercent: 1.25),
      CryptoItem(symbol: 'ETH', name: '이더리움', price: 3450.0, changePercent: -0.85),
      CryptoItem(symbol: 'SOL', name: '솔라나', price: 185.5, changePercent: 4.12),
      CryptoItem(symbol: 'XRP', name: '리플', price: 0.62, changePercent: -2.10),
      CryptoItem(symbol: 'ADA', name: '에이다', price: 0.45, changePercent: 0.50),
    ];

    // 기본 선택 종목 지정
    _selectedCrypto = _cryptoList.first;

    setState(() {
      _isInitLoading = false;
    });

    // 데이터 로딩 완료 후 실시간 웹소켓 시뮬레이터(Stream) 시작
    _startRealtimeMarketStream();
  }

  // ===========================================================================
  // 3. [Stream] 웹소켓을 모방한 실시간 시세 변동을 3초마다 브로드캐스트
  // ===========================================================================
  void _startRealtimeMarketStream() {
    final random = Random();

    // 3초마다 시세 무작위 변동 발생 시뮬레이션
    _tickerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_marketStreamController.isClosed) return;

      for (var item in _cryptoList) {
        // -2% ~ +2% 사이 무작위 가격 변동
        final deltaPercent = (random.nextDouble() * 4.0) - 2.0;
        item.price = item.price * (1 + (deltaPercent / 100));
        item.changePercent += deltaPercent;
      }

      // 스트림 구독자(StreamBuilder)에게 새 파이프라인 데이터 전송
      _marketStreamController.add(List.from(_cryptoList));
    });
  }

  // ===========================================================================
  // 2. [Future] 선택 종목의 상세 분석 리포트 및 기업 개요 비동기 요청
  // ===========================================================================
  Future<Map<String, dynamic>> _fetchCryptoDetailReport(String symbol) async {
    // 서버 비동기 API 통신 지연 시뮬레이션 (1초)
    await Future.delayed(const Duration(seconds: 1));

    return {
      'symbol': symbol,
      'marketCap': '\$${(symbol.length * 154.2).toStringAsFixed(1)}B',
      'volume24h': '\$${(symbol.length * 12.8).toStringAsFixed(1)}M',
      'high24h': '\$${(_selectedCrypto!.price * 1.05).toStringAsFixed(2)}',
      'low24h': '\$${(_selectedCrypto!.price * 0.95).toStringAsFixed(2)}',
      'summary': '$symbol 자산은 고성능 탈중앙화 네트워크를 기반으로 분산 금융 생태계를 제공하는 핵심 암호화폐입니다.',
    };
  }

  // ===========================================================================
  // 4. [Isolate] 과거 1년치(365일) 봉차트 분석 및 MA5, MA20 백그라운드 계산
  // ===========================================================================
  static String _calculateTechnicalIndicators(double currentPrice) {
    final random = Random();
    List<double> dailyPrices = [];
    double price = currentPrice;

    for (int i = 0; i < 365; i++) {
      price += (random.nextDouble() * 200) - 100;
      if (price <= 0) price = 10.0;
      dailyPrices.add(price);
    }

    double sum5 = 0;
    for (int i = 365 - 5; i < 365; i++) {
      sum5 += dailyPrices[i];
    }
    double ma5 = sum5 / 5;

    double sum20 = 0;
    for (int i = 365 - 20; i < 365; i++) {
      sum20 += dailyPrices[i];
    }
    double ma20 = sum20 / 20;

    // 더미 무거운 연산 시뮬레이션
    for (int i = 0; i < 30000000; i++) {
      sin(i.toDouble());
    }

    final signal = ma5 > ma20 ? "매수 (Golden Cross)" : "매도 (Dead Cross)";
    return "365일 차트 데이터 백그라운드 분석 완료!\n\n"
        "• 5일 이동평균(MA5): \$${ma5.toStringAsFixed(2)}\n"
        "• 20일 이동평균(MA20): \$${ma20.toStringAsFixed(2)}\n"
        "• 기술적 지표 신호: $signal\n"
        "• (Isolate 병렬 스레드 연산 완료)";
  }

  Future<void> _runIsolateAnalysis() async {
    if (_selectedCrypto == null) return;

    setState(() {
      _isCalculatingMa = true;
      _maAnalysisResult = "독립된 Isolate 스레드에서 1년 치 이동평균선 연산 중...";
    });

    final result = await Isolate.run(
      () => _calculateTechnicalIndicators(_selectedCrypto!.price),
    );

    setState(() {
      _maAnalysisResult = result;
      _isCalculatingMa = false;
    });
  }

  // ===========================================================================
  // UI 빌드
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.candlestick_chart, color: Color(0xFF6C5CE7)),
            SizedBox(width: 8),
            Text('Crypto & Stock Live Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFF1E2230),
        elevation: 0,
      ),
      body: _isInitLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF6C5CE7)),
                  SizedBox(height: 16),
                  Text('async/await로 데이터 로딩 중...'),
                ],
              ),
            )
          : Row(
              children: [
                // 좌측: 실시간 가격 스트림 목록
                Expanded(
                  flex: 35,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(color: Color(0xFF2D3446), width: 1)),
                    ),
                    child: _buildLeftMarketListPanel(),
                  ),
                ),
                // 우측: Future 상세 리포트 & Isolate 연산
                Expanded(
                  flex: 65,
                  child: _buildRightDetailPanel(),
                ),
              ],
            ),
    );
  }

  Widget _buildLeftMarketListPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '실시간 시장 시세 (3초 자동 갱신)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<CryptoItem>>(
            stream: _marketStreamController.stream,
            initialData: _cryptoList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = snapshot.data!;
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = _selectedCrypto?.symbol == item.symbol;
                  final isPositive = item.changePercent >= 0;
                  final color = isPositive
                      ? const Color(0xFF00B894)
                      : const Color(0xFFFF7675);

                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: const Color(0xFF2D3446),
                    onTap: () {
                      setState(() {
                        _selectedCrypto = item;
                        _maAnalysisResult = "종목이 변경되었습니다. MA 계산 버튼을 눌러주세요.";
                      });
                    },
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF12141C),
                      child: Text(
                        item.symbol.substring(0, 2),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    title: Text(item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.symbol,
                        style: const TextStyle(color: Colors.grey)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%',
                          style: TextStyle(color: color, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRightDetailPanel() {
    if (_selectedCrypto == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_selectedCrypto!.name} (${_selectedCrypto!.symbol})',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                ),
                onPressed: _isCalculatingMa ? null : _runIsolateAnalysis,
                icon: const Icon(Icons.memory, color: Colors.white),
                label: const Text('Isolate 차트 분석',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // FutureBuilder 영역
          FutureBuilder<Map<String, dynamic>>(
            future: _fetchCryptoDetailReport(_selectedCrypto!.symbol),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              final data = snapshot.data!;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📊 Future 상세 정보',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C5CE7))),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetricItem('시가총액', data['marketCap']),
                          _buildMetricItem('24h 거래량', data['volume24h']),
                          _buildMetricItem('24h 최고가', data['high24h']),
                          _buildMetricItem('24h 최저가', data['low24h']),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Isolate 결과 영역
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF12141C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isCalculatingMa
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        _maAnalysisResult,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 14),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}