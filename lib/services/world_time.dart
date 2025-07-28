import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String url;
  String flag;
  String time = '';
  bool isDayTime = true;

  WorldTime({
    required this.location,
    required this.url,
    required this.flag,
  });

  Future<void> getTime() async {
    try {
      // TimeAPI.io returns current time using region or IP
      final response = await http.get(
        Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'),
      );

      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final now = DateTime.parse(data['dateTime']);

      isDayTime = now.hour >= 6 && now.hour < 18;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('❌ getTime() error: $e');
      time = 'Failed to load';
    }
  }
}
