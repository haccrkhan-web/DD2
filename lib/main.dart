import 'package:flutter/material.dart';

void main() {
  runApp(const DD1CasinoApp());
}

class DD1CasinoApp extends StatelessWidget {
  const DD1CasinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DD1.COM',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF120C0C),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const MainCasinoHome(),
    );
  }
}

class MainCasinoHome extends StatefulWidget {
  const MainCasinoHome({super.key});

  @override
  State<MainCasinoHome> createState() => _MainCasinoHomeState();
}

class _MainCasinoHomeState extends State<MainCasinoHome> {
  int _selectedCategory = 0;
  int _currentNavIndex = 0;
  double _walletBalance = 100.00; // Starting demo coins

  final List<Map<String, dynamic>> _categories = [
    {'name': 'HOT', 'icon': Icons.local_fire_department, 'color': Colors.redAccent},
    {'name': 'CASINO', 'icon': Icons.style, 'color': Colors.orangeAccent},
    {'name': 'SLOT', 'icon': Icons.casino, 'color': Colors.amber},
    {'name': 'GAMES', 'icon': Icons.videogame_asset, 'color': Colors.purpleAccent},
    {'name': 'FISHING', 'icon': Icons.phishing, 'color': Colors.lightBlueAccent},
  ];

  final List<Map<String, String>> _games = [
    {'title': 'Aviator', 'tag': 'CRASH', 'color': '0xFF8B0000', 'type': 'aviator'},
    {'title': '7Up 7Down', 'tag': 'TOP', 'color': '0xFF1B2A47', 'type': 'dice'},
    {'title': 'Fortune Gems 2', 'tag': 'SLOT', 'color': '0xFFB8860B', 'type': 'slot'},
    {'title': 'Money Coming', 'tag': 'HOT', 'color': '0xFF006400', 'type': 'slot'},
    {'title': 'KoolBet Live', 'tag': 'LIVE', 'color': '0xFF2E1C2B', 'type': 'casino'},
    {'title': 'Chicken Dash', 'tag': 'NEW', 'color': '0xFFD2691E', 'type': 'games'},
  ];

  // Deposit Popup (Buy Coins with Real Money)
  void _showDepositDialog() {
    int selectedAmount = 500;
    final amounts = [100, 300, 500, 1000, 2000, 5000];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1413),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('BUY COINS (ADD MONEY)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Select Deposit Amount (1 ₹ = 1 Coin):', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: amounts.map((amt) {
                    final isSel = selectedAmount == amt;
                    return ChoiceChip(
                      label: Text('₹$amt', style: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                      selected: isSel,
                      selectedColor: Colors.amber,
                      backgroundColor: const Color(0xFF2E1C1B),
                      onSelected: (val) {
                        setModalState(() => selectedAmount = amt);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code_2, color: Colors.amber, size: 36),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Instant UPI / QR Code / NetBanking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('You will receive $selectedAmount Coins', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        _walletBalance += selectedAmount;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green.shade900,
                          content: Text('Payment Successful! ₹$selectedAmount added as $selectedAmount Coins.'),
                        ),
                      );
                    },
                    child: Text('PROCEED TO PAY ₹$selectedAmount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }

  // Withdraw Popup
  void _showWithdrawDialog() {
    final upiController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1413),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('WITHDRAW TO BANK / UPI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            Text('Available Balance: ₹ ${_walletBalance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Withdraw Coins / Rupees',
                prefixText: '₹ ',
                filled: true,
                fillColor: Color(0xFF2E1C1B),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: upiController,
              decoration: const InputDecoration(
                labelText: 'UPI ID (e.g. mobile@upi)',
                filled: true,
                fillColor: Color(0xFF2E1C1B),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                onPressed: () {
                  final double? req = double.tryParse(amountController.text);
                  if (req == null || req <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid amount!')));
                    return;
                  }
                  if (req > _walletBalance) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance!')));
                    return;
                  }
                  if (upiController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter UPI ID!')));
                    return;
                  }

                  setState(() {
                    _walletBalance -= req;
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: Colors.green.shade900, content: Text('Withdrawal request of ₹$req submitted to UPI: ${upiController.text}')),
                  );
                },
                child: const Text('SUBMIT WITHDRAWAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // Mini Aviator / Game Test Popup
  void _playGame(String title) {
    if (_walletBalance < 10) {
      _showDepositDialog();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient coins! Minimum bet is 10 Coins. Please buy coins.')));
      return;
    }

    setState(() {
      _walletBalance -= 10;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A1513),
        title: Text('$title Bet Placed!', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.rocket_launch, color: Colors.redAccent, size: 60),
            const SizedBox(height: 12),
            const Text('10 Coins deducted for this round.', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text('Current Balance: ₹ ${_walletBalance.toStringAsFixed(2)} Coins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _walletBalance += 25; // Win prize
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.amber, content: Text('🎉 WINNER! You won 25 Coins!')));
            },
            child: const Text('Cash Out 2.5x (+25 Coins)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF221110),
        elevation: 0,
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ).createShader(bounds),
              child: const Text(
                'DD1.COM',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: _showDepositDialog, icon: const Icon(Icons.account_balance_wallet, color: Colors.amber)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.support_agent, color: Colors.amber)),
        ],
      ),
      body: ListView(
        children: [
          // Banner
          Container(
            margin: const EdgeInsets.all(12),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF203A43), Color(0xFF0F2027)],
              ),
              border: Border.all(color: Colors.amber.shade700, width: 1.5),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  top: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
                    onPressed: () => _playGame('Cricket Crash'),
                    child: const Text('PLAY NOW', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PLAY & WIN 100x COINS', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('MEGA JACKPOT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Live Withdrawal Ticker
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.volume_up, color: Colors.amber, size: 18),
                SizedBox(width: 8),
                Text('Player9355**** successfully withdraws ₹ 1,250', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),

          // User Profile & Real Money Deposit / Withdraw Strip
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A1513),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.person, color: Colors.black, size: 28),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Player93551841', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 12)),
                      Row(
                        children: [
                          Text('₹ ${_walletBalance.toStringAsFixed(2)} Coins', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), padding: const EdgeInsets.symmetric(horizontal: 10)),
                  onPressed: _showDepositDialog,
                  icon: const Icon(Icons.add_circle, size: 16, color: Colors.white),
                  label: const Text('Deposit', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), padding: const EdgeInsets.symmetric(horizontal: 10)),
                  onPressed: _showWithdrawDialog,
                  icon: const Icon(Icons.account_balance, size: 16, color: Colors.white),
                  label: const Text('Withdraw', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Game Grid with Sidebar
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 75,
                margin: const EdgeInsets.only(left: 8),
                child: Column(
                  children: List.generate(_categories.length, (index) {
                    final item = _categories[index];
                    final isSelected = _selectedCategory == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFD32F2F) : const Color(0xFF2A1513),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? Colors.amber : Colors.transparent, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Icon(item['icon'] as IconData, color: isSelected ? Colors.white : item['color'] as Color, size: 28),
                            const SizedBox(height: 4),
                            Text(
                              item['name'] as String,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    final game = _games[index];
         
