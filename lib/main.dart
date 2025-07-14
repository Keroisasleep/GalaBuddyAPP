import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: const Text('GALABUDDY', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,

              ),),
              backgroundColor: Colors.grey[500]
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('KERO1', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300
                  ),),
                  Text('KERO2', style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600
                  ),),
                  Text('KERO3', style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w900
                  ),),
                ]
            ),
          )
      )
  ));
}