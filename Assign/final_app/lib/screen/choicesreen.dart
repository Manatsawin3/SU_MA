import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_app/screen/calculatorScreen.dart';

class choicesreen extends StatefulWidget {
  const choicesreen({super.key});

  @override
  State<choicesreen> createState() => _choicesreenState();
}

class _choicesreenState extends State<choicesreen> {
  static const double _thaiBahtGoldGrams = 15.244;
  static const double _troyOunceGrams = 31.1034768;
  static const double _thaiGoldPurity = 0.965;

  static const _surface = Color(0xFF141414);
  static const _border = Color(0xFF2A2A2A);
  static const _muted = Color(0xFF666666);

  final Map<TradeAsset, String> _priceLabels = {};
  Timer? _refreshTimer;
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    _fetchAllPrices();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchAllPrices();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchAllPrices() async {
    if (_fetching) return;
    _fetching = true;
    try {
      final results = await Future.wait([
        _fetchCoinGeckoBatch(),
        _fetchForexBatch(),
      ]);
      if (!mounted) return;
      final merged = <TradeAsset, String>{...results[0], ...results[1]};
      setState(() {
        _priceLabels
          ..clear()
          ..addAll(merged);
      });
    } finally {
      _fetching = false;
    }
  }

  Future<Map<TradeAsset, String>> _fetchCoinGeckoBatch() async {
    final assets =
        TradeAsset.values.where((a) => !a.isForex).toList();
    final ids = assets.map((a) => a.coinGeckoId).join(',');
    try {
      final response = await http
          .get(Uri.parse(
            'https://api.coingecko.com/api/v3/simple/price'
            '?ids=$ids&vs_currencies=thb',
          ))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return {for (final a in assets) a: '—'};
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final map = <TradeAsset, String>{};
      for (final asset in assets) {
        final row = data[asset.coinGeckoId] as Map<String, dynamic>?;
        final thb = (row?['thb'] as num?)?.toDouble();
        if (thb == null || thb <= 0) {
          map[asset] = '—';
          continue;
        }
        final normalized = asset.isThaiGold
            ? thb * (_thaiBahtGoldGrams / _troyOunceGrams) * _thaiGoldPurity
            : thb;
        map[asset] = '฿${_fmt(normalized)}';
      }
      return map;
    } catch (_) {
      return {for (final a in assets) a: '—'};
    }
  }

  Future<Map<TradeAsset, String>> _fetchForexBatch() async {
    final assets =
        TradeAsset.values.where((a) => a.isForex).toList();
    final codes = assets.map((a) => a.forexCode).join(',');
    try {
      final response = await http
          .get(Uri.parse(
            'https://api.frankfurter.app/latest?from=THB&to=$codes',
          ))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return {for (final a in assets) a: '—'};
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rates = data['rates'] as Map<String, dynamic>? ?? {};
      final map = <TradeAsset, String>{};
      for (final asset in assets) {
        final rate = (rates[asset.forexCode] as num?)?.toDouble();
        if (rate == null || rate <= 0) {
          map[asset] = '—';
          continue;
        }
        map[asset] = '฿${_fmt(1.0 / rate)}';
      }
      return map;
    } catch (_) {
      return {for (final a in assets) a: '—'};
    }
  }

  String _fmt(double value) {
    final fixed = value.toStringAsFixed(2);
    final dot = fixed.indexOf('.');
    final intPart = fixed.substring(0, dot);
    final decPart = fixed.substring(dot + 1);
    final grouped = intPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$grouped.$decPart';
  }

  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _assetTile(TradeAsset asset) {
    final price = _priceLabels[asset];
    final isLoading = price == null;
    final priceText = isLoading ? '...' : price;
    final color = asset.accentColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CalculatorScreen(asset: asset),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withAlpha(35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      asset.headerGlyph,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.titleUpper,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${asset.symbol} / THB',
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  priceText,
                  style: TextStyle(
                    color: isLoading ? _muted : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded, color: _muted, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LUNGBANK EXCHANGE'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('CRYPTO'),
              _assetTile(TradeAsset.bitcoin),
              _assetTile(TradeAsset.ethereum),
              _assetTile(TradeAsset.dogecoin),
              _sectionHeader('FIAT'),
              _assetTile(TradeAsset.forexUsd),
              _assetTile(TradeAsset.forexJpy),
              _assetTile(TradeAsset.forexCny),
              _sectionHeader('METAL'),
              _assetTile(TradeAsset.gold),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
