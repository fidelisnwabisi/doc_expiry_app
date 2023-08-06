import 'package:flutter/material.dart';

void main() {
  runApp(const DocExpiryApp());
}

class DocExpiryApp extends StatelessWidget {
  const DocExpiryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DocExpire',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: DocList(),
    );
  }
}
