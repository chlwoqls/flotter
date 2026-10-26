import 'package:flutter/material.dart';

void main() => runApp(const SoHwakSikApp());

class SoHwakSikApp extends StatelessWidget {
  const SoHwakSikApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainBudgetScreen(),
    );
  }
}

class Restaurant {
  final String name, category, location, tip;
  final int price;
  Restaurant(this.name, this.category, this.price, this.location, this.tip);
}

class MainBudgetScreen extends StatefulWidget {
  const MainBudgetScreen({super.key});
  @override
  State<MainBudgetScreen> createState() => _MainBudgetScreenState();
}

class _MainBudgetScreenState extends State<MainBudgetScreen> {
  // 💡 가성비 맛집 10곳으로 데이터 대폭 확장
  final List<Restaurant> _all = [
    Restaurant('대박 듬뿍 김치찌개', '한식', 9000, '역삼역 3번 출구 도보 5분', '라면사리 무한 리필!'),
    Restaurant('카츠마니아', '일식/돈까스', 12000, '강남역 11번 출구 도보 3분', '안심카츠가 진짜 촉촉해요.'),
    Restaurant('진짜 파스타', '양식', 14000, '신논현역 5번 출구 인근', '매운 크림 파스타 강력 추천!'),
    Restaurant('칭따오 마라탕', '중식', 11000, '강남역 9번 출구 도보 8분', '꿔바로우 소자도 가성비 최고.'),
    Restaurant('할매 순대국', '한식', 8000, '뱅뱅사거리 골목 안쪽', '머리고기 서비스가 나옵니다.'),
    Restaurant('미소야 초밥', '일식', 14500, '역삼동 카페거리 초입', '점심 특선 세트가 든든해요.'),
    Restaurant('고고 즉석떡볶이', '분식', 7500, '선릉역 2번 출구 도보 4분', '치즈 볶음밥은 필수 코스!'),
    Restaurant('버거앤프라이즈', '패스트푸드', 9500, '양재역 1번 출구 인근', '수제 패티라 육즙이 가득함.'),
    Restaurant('홍콩반점', '중식', 8500, '강남역 지하상가 내', '기본 짬뽕 불맛이 아주 제대로.'),
    Restaurant('그린 샐러드 보울', '샐러드', 13000, '선릉역 7번 출구 도보 6분', '닭가슴살 토핑 양이 엄청나요.')
  ];

  double _budget = 15000;

  // 💡 클릭 시 하단에 위치 정보를 띄워주는 팝업 함수
  void _showDetail(Restaurant shop, Color color) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(shop.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('${shop.price}원', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
              const SizedBox(height: 4),
              Text(shop.category, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const Divider(height: 30, thickness: 1),
              const Text('📍 상세 위치', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 6),
              Text(shop.location, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 20),
              const Text('✨ 가성비 꿀팁', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 6),
              Text(shop.tip, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _all.where((shop) => shop.price <= _budget).toList();
    const primaryCoral = Color(0xFFFF5A5F);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('소확식 🍽️', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primaryCoral, Color(0xFFFF7A7E)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: primaryCoral.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('오늘 나의 외식 예산은?', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 6),
                Text('${_budget.toInt()}원 이하', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                Slider(
                  value: _budget,
                  min: 5000,
                  max: 20000,
                  divisions: 15,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                  onChanged: (val) => setState(() => _budget = val),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Text('추천 맛집 ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('${filtered.length}곳', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryCoral)),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('이 가격대의 맛集이 없어요 🥲'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final shop = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text(shop.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          trailing: Text('${shop.price}원', style: const TextStyle(fontWeight: FontWeight.bold, color: primaryCoral, fontSize: 16)),
                          onTap: () => _showDetail(shop, primaryCoral), // 💡 클릭 시 팝업 실행
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
