import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'App LIA - Youtube API'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static String api_key = "AIzaSyDiiwePwEEhi6E3Rv77iar2gUgCs0EybL0";

  List<Object> results = [];

  YoutubeAPI yt = YoutubeAPI(api_key);

  @override
  void initState() {
    super.initState();
    callApi();
  }

  callApi() async {
    try {
      results = await yt.search("jorge");
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Projeto Youtube API - LIA',
            ),
            Text(
              'LIA',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
