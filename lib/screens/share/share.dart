import 'package:flutter/material.dart';

class Share extends StatefulWidget {
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  String txt = 'Exchangily Future Event, visit this link to join our event and get free coins : https://www.exchangily.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Share Page'),
      ),
      body: Container(
        child: ListView(
          children: [
            Text(txt),
            Image.network("https://techcrunch.com/wp-content/uploads/2017/02/chrome-qr-reader1.png")
          ],
        ),
      ),
    );
  }
}
