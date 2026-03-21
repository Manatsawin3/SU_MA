import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_app/widget/inputcard.dart';

class CalScreen extends StatefulWidget {
  final String symbols;
  final Color color;

  const CalScreen({super.key, required this.symbols, required this.color});

  @override
  State<CalScreen> createState() => _CalScreenState();
}

class _CalScreenState extends State<CalScreen> {
  double? price;
  bool loading = true;
  String? error;

  final assetController = TextEditingController();
  final thbController = TextEditingController();

  // ป้องกันวนลูปตอนอัปเดตช่องอีกฝั่ง
  bool syncing = false;

  @override
  void initState() {
    super.initState();
    assetController.addListener(onAssetChanged);
    thbController.addListener(onThbChanged);
    fetchPrice();
  }

  @override
  void dispose() {
    assetController.dispose();
    thbController.dispose();
    super.dispose();
  }

  // แปลง ticker เป็น id ของ CoinGecko
  String? getCoinId(String ticker) {
    switch (ticker) {
      case 'BTC':
        return 'bitcoin';
      case 'ETH':
        return 'ethereum';
      case 'DOGE':
        return 'dogecoin';
      default:
        return null;
    }
  }

  String getTitle(String ticker) {
    switch (ticker) {
      case 'BTC':
        return 'Bitcoin';
      case 'ETH':
        return 'Ethereum';
      case 'DOGE':
        return 'Dogecoin';
      case 'USD':
        return 'US Dollar';
      case 'JPY':
        return 'Japanese Yen';
      case 'CNY':
        return 'Chinese Yuan';
      default:
        return ticker;
    }
  }

  Future<void> fetchPrice() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      double rate;
      final coinId = getCoinId(widget.symbols);

      if (coinId != null) {
        // crypto → ดึงจาก CoinGecko
        final url =
            'https://api.coingecko.com/api/v3/simple/price?ids=$coinId&vs_currencies=thb';
        final res = await http.get(Uri.parse(url));
        final data = jsonDecode(res.body);
        rate = (data[coinId]['thb'] as num).toDouble();
      } else {
        // fiat → ดึงจาก open.er-api
        final url = 'https://open.er-api.com/v6/latest/${widget.symbols}';
        final res = await http.get(Uri.parse(url));
        final data = jsonDecode(res.body);
        rate = (data['rates']['THB'] as num).toDouble();
      }

      if (!mounted) return;
      setState(() {
        price = rate;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  void onAssetChanged() {
    if (syncing || price == null) return;

    final text = assetController.text.trim();
    if (text.isEmpty) {
      syncing = true;
      thbController.text = '';
      syncing = false;
      return;
    }

    final amount = double.tryParse(text);
    if (amount == null) return;

    syncing = true;
    thbController.text = (amount * price!).toStringAsFixed(2);
    syncing = false;
  }

  void onThbChanged() {
    if (syncing || price == null) return;

    final text = thbController.text.trim();
    if (text.isEmpty) {
      syncing = true;
      assetController.text = '';
      syncing = false;
      return;
    }

    final thb = double.tryParse(text);
    if (thb == null) return;

    syncing = true;
    assetController.text = (thb / price!).toStringAsFixed(6);
    syncing = false;
  }

  @override
  Widget build(BuildContext context) {
    final title = getTitle(widget.symbols);

    return Scaffold(
      appBar: AppBar(
        title: Text('$title → THB'),
        actions: [
          IconButton(
            onPressed: loading ? null : fetchPrice,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // แสดงสถานะโหลด / error / ราคา
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Text(
                'เกิดข้อผิดพลาด: $error',
                style: const TextStyle(color: Colors.red),
              )
            else if (price != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.color.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1 ${widget.symbols} = ฿${price!.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // ช่องใส่จำนวนสกุลที่เลือก
            InputCard(
              label: 'จำนวน ${widget.symbols}',
              controller: assetController,
              onChanged: (_) {},
            ),

            const SizedBox(height: 16),

            const Center(child: Icon(Icons.swap_vert, size: 28)),

            const SizedBox(height: 16),

            // ช่องใส่จำนวนบาท
            InputCard(
              label: 'จำนวน THB (บาท)',
              controller: thbController,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
