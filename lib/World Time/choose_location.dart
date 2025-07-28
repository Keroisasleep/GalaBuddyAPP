import 'package:flutter/material.dart';
import 'package:galaapp/services/world_time.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> location = [
    WorldTime(url: 'Europe/London', location: 'London', flag: 'uk.jpg'),
    WorldTime(url: 'Europe/Berlin', location: 'Berlin', flag: 'germany.jpg'),
    WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'egypt.jpg'),
    WorldTime(url: 'Asia/Manila', location: 'Manila', flag: 'philippines.jpg'),
    WorldTime(url: 'Asia/Tokyo', location: 'Tokyo', flag: 'japan.jpg'),
  ];

  void updateTime(index) async {
    WorldTime instance = location[index];
    await instance.getTime();

    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
      'url': instance.url,
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Choose a Location', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.white,),),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: location.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  updateTime(index);
                },
                title: Text(location[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${location[index].flag}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}