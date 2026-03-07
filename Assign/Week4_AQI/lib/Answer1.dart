import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AQIApp());
}

class AQIApp extends StatelessWidget {
  const AQIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AQIHome(),
    );
  }
}

class AQIHome extends StatefulWidget {
  const AQIHome({super.key});

  @override
  State<AQIHome> createState() => _AQIHomeState();
}

class _AQIHomeState extends State<AQIHome> {
  final token = "28f639b7dcb8edc81e5e15c8967d66988f6019e7";

  String city = "";
  int aqi = 0;
  double temp = 0;

  TextEditingController searchController = TextEditingController();

  List<String> thaiCities = [
    "bangkok",
    "chiang mai",
    "phuket",
    "chonburi",
    "nakhon ratchasima",
    "khon kaen",
    "hat yai",
  ];

  Future fetchAQI(String cityName) async {
    final url = "https://api.waqi.info/feed/$cityName/?token=$token";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        city = data["data"]["city"]["name"];

        aqi = data["data"]["aqi"];

        temp = data["data"]["iaqi"]["t"]["v"].toDouble();
      });
    }
  }

  Color getAQIColor(int value) {
    if (value <= 50) return Colors.green;
    if (value <= 100) return Colors.yellow;
    if (value <= 150) return Colors.orange;
    if (value <= 200) return Colors.red;
    if (value <= 300) return Colors.purple;

    return Colors.brown;
  }

  String getAQIStatus(int value) {
    if (value <= 50) return "Good";
    if (value <= 100) return "Moderate";
    if (value <= 150) return "Unhealthy (Sensitive)";
    if (value <= 200) return "Unhealthy";
    if (value <= 300) return "Very Unhealthy";

    return "Hazardous";
  }

  String provinceOnly(String name) {
    List parts = name.split(",");

    if (parts.length > 1) {
      return parts[1].trim();
    }

    return parts[0];
  }

  @override
  void initState() {
    super.initState();
    fetchAQI("bangkok");
  }

  @override
  Widget build(BuildContext context) {
    Color aqiColor = getAQIColor(aqi);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("AQI Air Quality"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 178, 229, 255),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search city in the world...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    fetchAQI(searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              children: thaiCities.map((city) {
                return ElevatedButton(
                  onPressed: () {
                    fetchAQI(city);
                  },
                  child: Text(city),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            Text(
              provinceOnly(city),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Container(
              width: 200,
              height: 200,

              decoration: BoxDecoration(
                color: aqiColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0, 5),
                  ),
                ],
              ),

              child: Center(
                child: Text(
                  "$aqi",
                  style: const TextStyle(
                    fontSize: 70,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              getAQIStatus(aqi),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: aqiColor,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.thermostat, size: 40),

                    const SizedBox(width: 10),

                    Text(
                      "$temp °C",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
