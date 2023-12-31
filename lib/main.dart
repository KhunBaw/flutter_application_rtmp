import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/platform_channel.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [
    Permission.camera,
    Permission.microphone,
  ].request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? showId;
  late RootEncoderViewController onTextViewCreated;

  TextEditingController? controllerRtmp = TextEditingController(text: "rtmps://live-api-s.facebook.com:443/rtmp/");
  TextEditingController? controllerKey = TextEditingController(text: "FB-2578257528998060-0-AbwCHnu-661m-XoX");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      print("startPreview");
      onTextViewCreated.startPreview();
    });
  }

  int indexFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // if (showId != null) SizedBox(height: MediaQuery.of(context).size.height - 500, child: const Texture(textureId: 1)),

            SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              width: MediaQuery.of(context).size.width,
              child: TextView(
                onTextViewCreated: (controller) {
                  setState(() {
                    onTextViewCreated = controller;
                  });
                },
              ),
            ),
            TextFormField(controller: controllerRtmp, decoration: const InputDecoration(labelText: "RTMP")),
            TextFormField(controller: controllerKey, decoration: const InputDecoration(labelText: "KEY")),
            // TextButton(
            //   onPressed: () async {
            //     // await PlatformChannel().startPreview();
            //     // await Future.delayed(const Duration(seconds: 5));
            //     // var data = await PlatformChannel().startService();
            //     // print("test $data");
            //     // await Future.delayed(Duration(seconds: 5));
            //     // await onTextViewCreated.startService();

            //     // await PlatformChannel().startPreview();
            //   },
            //   child: const Text("startService"),
            // ),
            TextButton(
              onPressed: () async {
                // await PlatformChannel().startPreview();
                // await Future.delayed(const Duration(seconds: 5));
                // var data = await PlatformChannel().startService();
                // print("test $data");
                // await Future.delayed(Duration(seconds: 5));
                // await onTextViewCreated.startService();

                // await PlatformChannel().startPreview();
                await onTextViewCreated.switchCamera();
              },
              child: const Text("switchCamera"),
            ),
            TextButton(
              onPressed: () async {
                // PlatformChannel().startStream(Uri.parse("${controllerRtmp?.text}${controllerKey?.text}"));
                await onTextViewCreated.startStream(Uri.parse("${controllerRtmp?.text}${controllerKey?.text}"));
              },
              child: const Text("startStream"),
            ),
            TextButton(
              onPressed: () async {
                // PlatformChannel().stopStream();
                await onTextViewCreated.stopStream();
              },
              child: const Text("stopStream"),
            ),
            TextButton(
              onPressed: () async {
                final ByteData bytes = await rootBundle.load('assets/Kit-Cat.png');
                final Uint8List list = bytes.buffer.asUint8List();
                print(indexFilter);
                // PlatformChannel().addOverlay(list, indexFilter++);
                await onTextViewCreated.addOverlay(data: list, filterPosition: 0);
                print(indexFilter);
              },
              child: const Text("addOverlay1"),
            ),
            TextButton(
              onPressed: () async {
                final ByteData bytes = await rootBundle.load('assets/pdchsfnwjapsf400-1_4.jpg');
                final Uint8List list = bytes.buffer.asUint8List();
                // PlatformChannel().addOverlay(list, indexFilter++);
                print("add image");
              },
              child: const Text("addOverlay2"),
            ),
            TextButton(
              onPressed: () async {
                if (indexFilter <= 0) {
                  return;
                }
                print("del image $indexFilter");
                // PlatformChannel().delOverlay(--indexFilter);
              },
              child: const Text("delOverlay"),
            ),
          ],
        ),
      ),
    );
  }
}
