import 'package:flutter/material.dart';
import 'view_export.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: SizedBox(
                height: screenHeight * 0.70,
                width: screenWidth,
                child: Image.asset(
                  "images/UPEI-GIF.gif",
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/newsList');
                    },
                    child: const Text('Start Reading', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


