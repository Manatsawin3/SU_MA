import 'package:flutter/material.dart';
import 'package:final_app/screen/calscreen.dart';
import 'package:final_app/widget/optioncard.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LUNGBANK CALCULATOR')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OptionCard(
            name: 'BTC',
            subtitle: 'Bitcoin',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalScreen(symbols: 'BTC', color: Colors.orange),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OptionCard(
            name: 'ETH',
            subtitle: 'Ethereum',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalScreen(symbols: 'ETH', color: Colors.blue),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OptionCard(
            name: 'DOGE',
            subtitle: 'Dogecoin',
            color: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalScreen(symbols: 'DOGE', color: Colors.amber),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OptionCard(
            name: 'USD',
            subtitle: 'US Dollar',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalScreen(symbols: 'USD', color: Colors.green),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OptionCard(
            name: 'JPY',
            subtitle: 'Japanese Yen',
            color: Colors.pink,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalScreen(symbols: 'JPY', color: Colors.pink),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OptionCard(
            name: 'CNY',
            subtitle: 'Chinese Yuan',
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalScreen(symbols: 'CNY', color: Colors.red),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
