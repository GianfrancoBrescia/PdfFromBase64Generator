import 'package:flutter/material.dart';

import 'FileProcess.dart';

class MyHomePage extends StatefulWidget {
  final String base64String;

  const MyHomePage({super.key, required this.base64String});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fileName = "scheda_usca";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await FileProcess.downloadFile(widget.base64String, fileName);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      _getSnackBarPAI("Scheda USCA scaricata", "Apri"));
                }
              },
              child: Container(
                color: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  "Download Pdf relativo ad una Scheda USCA",
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  SnackBar _getSnackBarPAI(String contentSnackbarPAI, String labelSnackbarPAI) {
    return SnackBar(
        content: Text(contentSnackbarPAI),
        duration: const Duration(minutes: 5),
        action: SnackBarAction(
          label: labelSnackbarPAI,
          onPressed: () => FileProcess.openFile(fileName),
        ));
  }
}
