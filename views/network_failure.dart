import 'package:flutter/material.dart';

class NoNetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
         
          const SizedBox(height: 5,),
          const Text(' connection failure')
        ],
      ),
    );
  }
}
