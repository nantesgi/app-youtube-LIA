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
  bool typing = false;
  String header = "Pelo que você está procurando?";
  static String api_key = "AIzaSyDiiwePwEEhi6E3Rv77iar2gUgCs0EybL0";

  List<YouTubeVideo> results = [];

  YoutubeAPI yt = YoutubeAPI(api_key);

  @override
  void initState() {
    super.initState();
    callApi();
  }

  callApi() async {
    try {
      results = await yt.search(
        TextBox.ytsearch.text,
        order: 'relevance',
        videoDuration: 'any',
      );
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.grey[900],
        title: typing ? TextBox() : Text(header),
        leading: IconButton(
          icon: Icon(typing ? Icons.done : Icons.search),
          onPressed: () {
            setState(() {
              typing = !typing;
            });
            if (typing == false) {
              callApi();
            }
            if (TextBox.ytsearch.text == null) {
              header = 'Pelo que você está procurando?';
            } else {
              header = TextBox.ytsearch.text;
            }
          },
        ),
      ),
      body: ListView(
        children: results.map<Widget>(listItem).toList(),
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return GestureDetector(
      child: Card(
        color: Colors.grey[850],
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.network(
                  video.thumbnail.small.url ?? '',
                  width: 120.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title,
                      softWrap: true,
                      style: TextStyle(fontSize: 18.0, color: Colors.grey[500]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        video.description ?? '',
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  static TextEditingController ytsearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: TextField(
          decoration:
              InputDecoration(border: InputBorder.none, hintText: 'Busque'),
          controller: ytsearch,
          style: TextStyle(color: Colors.white)
        ),
      ),
    );
  }
}