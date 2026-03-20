import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

enum TradeAsset {
  bitcoin,
  ethereum,
  dogecoin,
  gold,
  forexUsd,
  forexJpy,
  forexCny,
}

extension TradeAssetUi on TradeAsset {
  bool get isForex => switch (this) {
    TradeAsset.forexUsd || TradeAsset.forexJpy || TradeAsset.forexCny => true,
    _ => false,
  };

  bool get show24hChange => !isForex;

  bool get isThaiGold => this == TradeAsset.gold;

  String get coinGeckoId => switch (this) {
    TradeAsset.bitcoin => 'bitcoin',
    TradeAsset.ethereum => 'ethereum',
    TradeAsset.dogecoin => 'dogecoin',
    TradeAsset.gold => 'pax-gold',
    _ => throw UnsupportedError('$this is not a CoinGecko asset'),
  };

  String get forexCode => switch (this) {
    TradeAsset.forexUsd => 'USD',
    TradeAsset.forexJpy => 'JPY',
    TradeAsset.forexCny => 'CNY',
    _ => throw UnsupportedError('$this is not forex'),
  };

  String get symbol => switch (this) {
    TradeAsset.bitcoin => 'BTC',
    TradeAsset.ethereum => 'ETH',
    TradeAsset.dogecoin => 'DOGE',
    TradeAsset.gold => 'XAU',
    TradeAsset.forexUsd => 'USD',
    TradeAsset.forexJpy => 'JPY',
    TradeAsset.forexCny => 'CNY',
  };

  String get resultUnit => switch (this) {
    TradeAsset.gold => 'บาท',
    _ => symbol,
  };

  String get titleUpper => switch (this) {
    TradeAsset.bitcoin => 'BITCOIN',
    TradeAsset.ethereum => 'ETHEREUM',
    TradeAsset.dogecoin => 'DOGECOIN',
    TradeAsset.gold => 'GOLD',
    TradeAsset.forexUsd => 'USD',
    TradeAsset.forexJpy => 'JPY',
    TradeAsset.forexCny => 'CNY',
  };

  String get titleCalculator => switch (this) {
    TradeAsset.bitcoin => 'BTC CALCULATOR',
    TradeAsset.ethereum => 'ETH CALCULATOR',
    TradeAsset.dogecoin => 'DOGE CALCULATOR',
    TradeAsset.gold => 'GOLD CALCULATOR',
    TradeAsset.forexUsd => 'USD CALCULATOR',
    TradeAsset.forexJpy => 'JPY CALCULATOR',
    TradeAsset.forexCny => 'CNY CALCULATOR',
  };

  String get subtitleTh => switch (this) {
    TradeAsset.bitcoin => 'แปลงบาทไทยเป็น Bitcoin',
    TradeAsset.ethereum => 'แปลงบาทไทยเป็น Ethereum',
    TradeAsset.dogecoin => 'แปลงบาทไทยเป็น Dogecoin',
    TradeAsset.gold => 'แปลงบาทไทยเป็นทองคำ (บาท)',
    TradeAsset.forexUsd => 'แปลงบาทไทยเป็นดอลลาร์สหรัฐ',
    TradeAsset.forexJpy => 'แปลงบาทไทยเป็นเยนญี่ปุ่น',
    TradeAsset.forexCny => 'แปลงบาทไทยเป็นหยวนจีน',
  };

  String get headerGlyph => switch (this) {
    TradeAsset.bitcoin => '₿',
    TradeAsset.ethereum => 'Ξ',
    TradeAsset.dogecoin => 'Ð',
    TradeAsset.gold => 'XAU',
    TradeAsset.forexUsd => r'$',
    TradeAsset.forexJpy => '¥',
    TradeAsset.forexCny => '元',
  };

  Color get accentColor => switch (this) {
    TradeAsset.bitcoin => const Color(0xFFF7931A),
    TradeAsset.ethereum => const Color(0xFF627EEA),
    TradeAsset.dogecoin => const Color(0xFFC2A633),
    TradeAsset.gold => const Color(0xFFD4AF37),
    TradeAsset.forexUsd => const Color(0xFF85BB65),
    TradeAsset.forexJpy => const Color(0xFFE91E8C),
    TradeAsset.forexCny => const Color(0xFFE53935),
  };
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, this.asset = TradeAsset.bitcoin});

  final TradeAsset asset;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  // Approximate conversion from spot gold (THB/troy oz) to Thai baht-gold (96.5%).
  static const double _thaiBahtGoldGrams = 15.244;
  static const double _troyOunceGrams = 31.1034768;
  static const double _thaiGoldPurity = 0.965;

  final TextEditingController _thbController = TextEditingController();
  final TextEditingController _assetController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _assetFocusNode = FocusNode();
  bool _isSyncingFields = false;
  bool _lastEditedIsThb = true;

  double? _priceThb;
  double _change24h = 0;
  bool _isLoading = false;
  bool _hasError = false;
  DateTime? _lastUpdate;
  Timer? _autoRefreshTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const _surface = Color(0xFF111111);
  static const _surface2 = Color(0xFF1A1A1A);
  static const _border = Color(0xFF2A2A2A);
  static const _muted = Color(0xFF666666);
  static const _green = Color(0xFF00D68F);
  static const _red = Color(0xFFFF4D4D);

  Color get _accent => widget.asset.accentColor;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fetchPrice();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchPrice();
    });
    _focusNode.addListener(_onFocusNodeChange);
  }

  void _onFocusNodeChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _thbController.dispose();
    _assetController.dispose();
    _focusNode.removeListener(_onFocusNodeChange);
    _focusNode.dispose();
    _assetFocusNode.dispose();
    _pulseController.dispose();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPrice() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      if (widget.asset.isForex) {
        final code = widget.asset.forexCode;
        final response = await http
            .get(
              Uri.parse('https://api.frankfurter.app/latest?from=THB&to=$code'),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final rates = data['rates'] as Map<String, dynamic>?;
          final rate = (rates?[code] as num?)?.toDouble();
          if (rate == null || rate <= 0) {
            throw Exception('Missing rate for $code');
          }
          setState(() {
            _priceThb = 1.0 / rate;
            _change24h = 0;
            _lastUpdate = DateTime.now();
            _isLoading = false;
          });
          _syncFromActiveSide();
        } else {
          throw Exception('Bad status: ${response.statusCode}');
        }
      } else {
        final id = widget.asset.coinGeckoId;
        final response = await http
            .get(
              Uri.parse(
                'https://api.coingecko.com/api/v3/simple/price'
                '?ids=$id&vs_currencies=thb&include_24hr_change=true',
              ),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final row = data[id] as Map<String, dynamic>?;
          if (row == null) throw Exception('Missing $id in response');
          final thbPrice = (row['thb'] as num).toDouble();
          final normalizedThbPrice = widget.asset.isThaiGold
              ? thbPrice *
                    (_thaiBahtGoldGrams / _troyOunceGrams) *
                    _thaiGoldPurity
              : thbPrice;
          setState(() {
            _priceThb = normalizedThbPrice;
            _change24h = (row['thb_24h_change'] as num).toDouble();
            _lastUpdate = DateTime.now();
            _isLoading = false;
          });
          _syncFromActiveSide();
        } else {
          throw Exception('Bad status: ${response.statusCode}');
        }
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  double get _btcResult {
    final input = double.tryParse(_thbController.text) ?? 0;
    if (_priceThb == null || input <= 0) return 0;
    return input / _priceThb!;
  }

  String _formatBtc(double btc) {
    if (btc == 0) return '—';
    if (btc >= 0.001) return btc.toStringAsFixed(6);
    if (btc >= 0.000001) return btc.toStringAsFixed(8);
    return btc.toStringAsExponential(4);
  }

  String _formatOutcome(double amount) {
    if (amount == 0) return '—';
    if (widget.asset.isForex) {
      if (amount >= 1) return amount.toStringAsFixed(2);
      if (amount >= 0.01) return amount.toStringAsFixed(4);
      return amount.toStringAsExponential(4);
    }
    return _formatBtc(amount);
  }

  String _formatThb(double value) {
    final neg = value < 0;
    final abs = neg ? -value : value;
    final fixed = abs.toStringAsFixed(2);
    final dot = fixed.indexOf('.');
    final intPart = fixed.substring(0, dot);
    final decPart = fixed.substring(dot + 1);
    final grouped = intPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${neg ? '-' : ''}$grouped.$decPart';
  }

  String _toEditable(double value, {int maxDecimals = 8}) {
    var text = value.toStringAsFixed(maxDecimals);
    text = text.replaceFirst(RegExp(r'\.?0+$'), '');
    return text.isEmpty ? '0' : text;
  }

  void _setTextNoLoop(TextEditingController controller, String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _syncFromThbInput() {
    if (_isSyncingFields) return;
    _lastEditedIsThb = true;
    final thb = double.tryParse(_thbController.text) ?? 0;
    final asset = (_priceThb != null && thb > 0) ? thb / _priceThb! : 0.0;
    _isSyncingFields = true;
    _setTextNoLoop(_assetController, asset == 0 ? '' : _toEditable(asset));
    _isSyncingFields = false;
    setState(() {});
  }

  void _syncFromAssetInput() {
    if (_isSyncingFields) return;
    _lastEditedIsThb = false;
    final asset = double.tryParse(_assetController.text) ?? 0;
    final thb = (_priceThb != null && asset > 0) ? asset * _priceThb! : 0.0;
    _isSyncingFields = true;
    _setTextNoLoop(
      _thbController,
      thb == 0 ? '' : _toEditable(thb, maxDecimals: 2),
    );
    _isSyncingFields = false;
    setState(() {});
  }

  void _syncFromActiveSide() {
    if (_lastEditedIsThb) {
      _syncFromThbInput();
    } else {
      _syncFromAssetInput();
    }
  }

  void _setQuickAmount(double amount) {
    _lastEditedIsThb = true;
    _setTextNoLoop(_thbController, amount.toInt().toString());
    _syncFromThbInput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildPriceTicker(),
              const SizedBox(height: 12),
              if (_hasError) _buildErrorBanner(),
              _buildInputCard(),
              const SizedBox(height: 16),
              const Icon(Icons.keyboard_arrow_down, color: _muted),
              const SizedBox(height: 8),
              _buildResultCard(),
              const SizedBox(height: 16),
              _buildRefreshRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final c = widget.asset;
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (_, _) => Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accent.withOpacity(_pulseAnimation.value * 0.45),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                c.headerGlyph,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          c.titleCalculator,
          style: TextStyle(
            color: _accent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 4),
        Text(c.subtitleTh, style: const TextStyle(color: _muted, fontSize: 13)),
      ],
    );
  }

  Widget _buildPriceTicker() {
    final priceText = _priceThb != null
        ? '฿${_formatThb(_priceThb!)}'
        : _isLoading
        ? 'กำลังโหลด...'
        : 'โหลดไม่ได้';

    final changeText = _priceThb != null
        ? (widget.asset.show24hChange
              ? '${_change24h >= 0 ? '+' : ''}${_change24h.toStringAsFixed(2)}% (24h)'
              : '—')
        : '—';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, _) => Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: _green.withOpacity(_pulseAnimation.value),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${widget.asset.symbol} / THB',
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                changeText,
                style: TextStyle(
                  color: widget.asset.show24hChange
                      ? (_change24h >= 0 ? _green : _red)
                      : _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _red.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: _red, size: 14),
          SizedBox(width: 8),
          Text(
            'ไม่สามารถดึงข้อมูลราคาได้ กรุณาลองใหม่',
            style: TextStyle(
              color: _red,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ใส่จำนวนเงิน',
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? _accent.withOpacity(0.6)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: _border)),
                    ),
                    child: Text(
                      'THB',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _thbController,
                      focusNode: _focusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        hintText: '0',
                        hintStyle: TextStyle(color: _border),
                      ),
                      onChanged: (_) => _syncFromThbInput(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(right: BorderSide(color: _border)),
                  ),
                  child: Text(
                    widget.asset.resultUnit,
                    style: TextStyle(
                      color: _accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _assetController,
                    focusNode: _assetFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      hintText: '0',
                      hintStyle: const TextStyle(color: _border),
                      suffixText: widget.asset.symbol,
                      suffixStyle: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    onChanged: (_) => _syncFromAssetInput(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _quickBtn('฿100', 100),
              _quickBtn('฿1K', 1000),
              _quickBtn('฿10K', 10000),
              _quickBtn('฿100K', 100000),
              _quickBtn('฿1M', 1000000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickBtn(String label, double amount) {
    return GestureDetector(
      onTap: () => _setQuickAmount(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: _surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final btc = _btcResult;
    final hasResult = btc > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasResult ? _accent : _border),
      ),
      child: Column(
        children: [
          Text(
            '${widget.asset.titleUpper} ที่ได้รับ',
            style: TextStyle(
              color: _accent,
              fontSize: 11,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hasResult
                ? '${_formatOutcome(btc)} ${widget.asset.resultUnit}'
                : '—',
            style: TextStyle(
              color: _accent,
              fontSize: hasResult ? 28 : 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            _priceThb != null
                ? widget.asset.isThaiGold
                      ? 'ราคาทองคำไทย 1 บาท ฿${_formatThb(_priceThb!)}'
                      : 'ราคา ${widget.asset.symbol} ปัจจุบัน ฿${_formatThb(_priceThb!)}'
                : 'กรอกจำนวนเงินเพื่อคำนวณ',
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _isLoading ? null : _fetchPrice,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                _isLoading
                    ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: _accent,
                        ),
                      )
                    : const Text(
                        '↻',
                        style: TextStyle(color: _muted, fontSize: 14),
                      ),
                const SizedBox(width: 6),
                const Text(
                  'อัปเดตราคา',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_lastUpdate != null) ...[
          const SizedBox(width: 10),
          Text(
            'อัปเดต ${_lastUpdate!.hour.toString().padLeft(2, '0')}:${_lastUpdate!.minute.toString().padLeft(2, '0')}:${_lastUpdate!.second.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ],
    );
  }
}
