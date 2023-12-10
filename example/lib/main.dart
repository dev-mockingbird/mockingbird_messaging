import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird_messaging/mockingbird_messaging.dart';

Future<bool> installService(String token) async {
  var miaoba = Miaoba(
    transport: WebsocketTransport("ws://127.0.0.1:9000/ws"),
    encoding: JsonEncoding(),
    cryptoMethod:
        kIsWeb ? AcceptCrypto.methodPlaintext : AcceptCrypto.methodAesRsaSha256,
    token: token,
  );
  Mockingbird.instance.addEventListener((Event e) {
    print("${e.type}: ${e.payload}");
  });
  return await Mockingbird.instance.initialize(
    userId: "000004ydgqcv7aio",
    proto: miaoba,
    db: await Sqlite().getdb(),
    clientId: "xxxxxx",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await installService("MDAwMDA1Z3g3b3RmaHc1Yw==");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String fileInfos = "";
  File? _file;
  TextEditingController controller = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final List<XFile> media = await picker.pickMultipleMedia();
                _uploadMedia(media);
              },
              child: const Text("上传图片"),
            ),
            Text(fileInfos),
            TextField(controller: controller),
            ElevatedButton(
              onPressed: () async {
                var cacher = FileCacher(
                  fileManager: HttpFileManager(
                    helper: DioHelper(domain: "http://127.0.0.1:9000"),
                  ),
                );
                var file = await cacher.cacheFile(
                  controller.text,
                  size: ImageSize.origin,
                );
                if (file != null) {
                  setState(() {
                    _file = file;
                  });
                }
              },
              child: const Text("下载图片"),
            ),
            if (_file != null) Image.file(_file!),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _uploadMedia(List<XFile> files) async {
    var uploader = FileUploader(
      fileManager: HttpFileManager(
        helper: DioHelper(
          domain: "http://127.0.0.1:9000",
        ),
      ),
    );
    var infos = await uploader.upload(files, onFail: (file, code, info) {
      print("${file.name}, $code, $info");
    });
    for (var i = 0; i < infos.length; i++) {
      if (infos[i] == null) {
        infos.removeAt(i);
      }
    }
    setState(() {
      controller.text = jsonEncode(infos);
    });
  }
}
