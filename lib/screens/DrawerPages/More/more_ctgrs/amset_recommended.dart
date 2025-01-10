import 'package:flutter/material.dart';

class AmsetRecommendedPage extends StatefulWidget {
  const AmsetRecommendedPage({super.key});

  @override
  State<AmsetRecommendedPage> createState() => _AmsetRecommendedPageState();
}

class _AmsetRecommendedPageState extends State<AmsetRecommendedPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Amset recommended'),
      ),
    );
  }
}
