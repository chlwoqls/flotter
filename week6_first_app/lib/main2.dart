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
      // [UI/UX] 촌스럽고 눈 아픈 90년대풍 테마 적용
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFF00FF), // 핫핑크 배경
        cardColor: const Color(0xFFFFFF00), // 형광 노랑 카드
        dividerColor: Colors.red,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 데이터 모델 정의 (성능 및 로직 동일)
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
  List<CryptoItem> _cryptoList = [];
  CryptoItem? _selectedCrypto;
  bool _isInitLoading = true;

  bool _isCalculatingMa = false;
  String _maAnalysisResult = "종목을 선택한 후 이동평균선(MA) 계산 버튼을 눌러주세요.";

  late final StreamController<List<CryptoItem>> _marketStreamController;
  Timer? _tickerTimer;

  @override
  void initState() {
    super.initState();
    _marketStreamController = StreamController<List<CryptoItem>>.broadcast();
    _initDashboardData();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _marketStreamController.close();
    super.dispose();
  }

  // ===========================================================================
  // 1. [async / await] 기능/성능 동일
  // ===========================================================================
  Future<void> _initDashboardData() async {
    setState(() => _isInitLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    _cryptoList = [
      CryptoItem(symbol: 'BTC', name: '비트코인', price: 92500.0, changePercent: 1.25),
      CryptoItem(symbol: 'ETH', name: '이더리움', price: 3450.0, changePercent: -0.85),
      CryptoItem(symbol: 'SOL', name: '솔라나', price: 185.5, changePercent: 4.12),
      CryptoItem(symbol: 'XRP', name: '리플', price: 0.62, changePercent: -2.10),
      CryptoItem(symbol: 'ADA', name: '에이다', price: 0.45, changePercent: 0.50),
    ];

    _selectedCrypto = _cryptoList.first;

    setState(() {
      _isInitLoading = false;
    });

    _startRealtimeMarketStream();
  }

  // ===========================================================================
  // 3. [Stream] 기능/성능 동일
  // ===========================================================================
  void _startRealtimeMarketStream() {
    final random = Random();

    _tickerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_marketStreamController.isClosed) return;

      for (var item in _cryptoList) {
        final deltaPercent = (random.nextDouble() * 4.0) - 2.0;
        item.price = item.price * (1 + (deltaPercent / 100));
        item.changePercent += deltaPercent;
      }

      _marketStreamController.add(List.from(_cryptoList));
    });
  }

  // ===========================================================================
  // 2. [Future] 기능/성능 동일
  // ===========================================================================
  Future<Map<String, dynamic>> _fetchCryptoDetailReport(String symbol) async {
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
  // 4. [Isolate] 기능/성능 동일
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
  // UI 디자인
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '★☆주식&코인 대시보드☆★',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isInitLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red, strokeWidth: 10),
                  SizedBox(height: 16),
                  Text(
                    '로딩중임 기다리셈...',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // 좌측: 형광 연두색 배경
                Expanded(
                  flex: 35,
                  child: Container(
                    color: const Color(0xFF00FF00),
                    child: _buildLeftMarketListPanel(),
                  ),
                ),
                // 우측: 핫핑크 배경
                Expanded(
                  flex: 65,
                  child: Container(
                    color: const Color(0xFFFF00FF),
                    child: _buildRightDetailPanel(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLeftMarketListPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.orange,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            '실시간시세목록(3초갱신)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
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
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = _selectedCrypto?.symbol == item.symbol;
                  final isPositive = item.changePercent >= 0;

                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.cyan : Colors.white,
                      border: Border.all(color: Colors.red, width: 4),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedCrypto = item;
                          _maAnalysisResult = "종목이 변경되었습니다. MA 계산 버튼을 눌러주세요.";
                        });
                      },
                      leading: Container(
                        color: Colors.brown,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          item.symbol,
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            color: isPositive ? Colors.red : Colors.blue,
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              '${isPositive ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  '${_selectedCrypto!.name} [${_selectedCrypto!.symbol}]',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.lime,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: _isCalculatingMa ? null : _runIsolateAnalysis,
                  child: const Text(
                    '★Isolate계산버튼★',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // FutureBuilder 영역
          FutureBuilder<Map<String, dynamic>>(
            future: _fetchCryptoDetailReport(_selectedCrypto!.symbol),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.yellow,
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: Text(
                      'Future 로딩중...',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              return Container(
                color: Colors.yellow,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(color: Colors.green, width: 5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '상세정보(Future)',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetricItem('시가총액', data['marketCap']),
                        _buildMetricItem('24h거래량', data['volume24h']),
                        _buildMetricItem('최고가', data['high24h']),
                        _buildMetricItem('최저가', data['low24h']),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          // Isolate 결과 영역
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.purple, width: 6),
              ),
              child: _isCalculatingMa
                  ? const Center(
                      child: Text(
                        'Isolate 열일중...',
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Text(
                        _maAnalysisResult,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.black, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}