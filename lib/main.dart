import 'package:calculate_parking_fee/page/insert_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const InsertPage(),
        },
      ),
    );
