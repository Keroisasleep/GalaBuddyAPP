import 'dart:async';
import 'package:flutter/material.dart';
import 'package:galaapp/services/world_time.dart';

class HomeTime extends StatefulWidget {
  const HomeTime({super.key});

  @override
  State<HomeTime> createState() => _HomeTimeState();
}

class _HomeTimeState extends State<HomeTime> {
  Map data = {};
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateTime());
  }

  Future<void> _updateTime() async {
    if (data['url'] == null) return; // no location to fetch

    try {
      WorldTime instance = WorldTime(
        location: data['location'] ?? '',
        url: data['url'] ?? '',
        flag: data['flag'] ?? '',
      );

      await instance.getTime();
      setState(() {
        data['time'] = instance.time;
        data['isDayTime'] = instance.isDayTime;
      });
    } catch (e) {
      setState(() {
        data['time'] = 'Failed to load';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer(); // begin repeating updates
  }

  @override
  void dispose() {
    _timer?.cancel(); // stop timer on exit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get data passed from route only once
    if (data.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        data = args;
        _updateTime(); // fetch right away
      }
    }

    String bgImage = data['isDayTime'] == true ? 'day.jpg' : 'night.jpg';
    Color? bgColor = data['isDayTime'] == true ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),
              Material(
                color: Colors.transparent,
                child: TextButton.icon(
                  onPressed: () async {
                    print('📍 Edit Location pressed');
                    dynamic result = await Navigator.pushNamed(context, '/choose_location');
                    print('📦 Returned from choose_location: $result');

                    if (result != null) {
                      setState(() {
                        data = {
                          'time': result['time'],
                          'location': result['location'],
                          'isDayTime': result['isDayTime'],
                          'flag': result['flag'],
                          'url': result['url'],
                        };
                      });
                      _updateTime();
                    }
                  },
                  icon: const Icon(Icons.edit_location, color: Colors.white),
                  label: const Text(
                    'Edit Location',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                data['location'] ?? '',
                style: const TextStyle(
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                data['time'] ?? '',
                style: const TextStyle(
                  fontSize: 66.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
