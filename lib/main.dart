import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

void main() => runApp(MaterialApp(
  title: "NFC example project",
  home: NFCReader()),
);

class NFCReader extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State {
  bool _supportsNFC = false;
  bool _reading = false;
  StreamSubscription<NDEFMessage> _stream;
  String text ="default" ;

  @override
  void initState() {
    super.initState();
    // 기기가 NFC 지원하는지 체크
    // ios 시뮬레이터에서는 아직 지원 안함.
    // android 에뮬레이터에서 돌리려면 추가 옵션 필요
    NFC.isNDEFSupported
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return Scaffold(
        body: Center(
          child: RaisedButton(
            child: const Text("NFC를 지원하지 않는 기기입니다."),
            onPressed: null,
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text(_reading ? "인식 중지" : "인식 시작"),
                onPressed: () {
                  if (_reading) {
                    _stream?.cancel();
                    setState(() {
                      _reading = false;
                    });
                  } else {
                    setState(() {
                      _reading = true;
                      // Start reading using NFC.readNDEF()
                      _stream = NFC.readNDEF(
                        once: true,
                        throwOnUserCancel: false,
                      ).listen((NDEFMessage message) {
                        print("read NDEF message: ${message.payload}");
                        setState(() {
                          text = message.payload;
                        });
                      }, onError: (e) {
                        // Check error handling guide below
                      });
                    });
                  }
                }
            ),
            SizedBox(height: 30.0,),
            Text("메시지 : $text"),
          ],
        ),
      ),
    );
  }
}