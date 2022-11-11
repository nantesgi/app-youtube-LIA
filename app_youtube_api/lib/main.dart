import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:html_unescape/html_unescape.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App LIA',
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
  bool searchOpened = false;
  String header = "Pelo que você está procurando?";
  static String api_key = "AIzaSyDiiwePwEEhi6E3Rv77iar2gUgCs0EybL0";

  List<YouTubeVideo> results = [];

  YoutubeAPI yt = YoutubeAPI(api_key, maxResults: 50);

  @override
  void initState() {
    super.initState();
    callApi();
  }

  callApi() async {
    results = await yt.search(
      TextBox.ytsearch.text,
      order: 'relevance',
      videoDuration: 'any'
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.grey[900],
        title: searchOpened ? TextBox() : Text(header),
        leading: IconButton(
          icon: Icon(searchOpened ? Icons.done : Icons.search),
          onPressed: () {
            setState(() {
              searchOpened = !searchOpened;
            });
            if (searchOpened == false) {
              callApi();
            }
            if (TextBox.ytsearch.text == null) {
              header = 'Pelo você está buscando?';
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
                      HtmlUnescape().convert(video.title),
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
  const TextBox({super.key});
  static TextEditingController ytsearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15),
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white)),
            controller: ytsearch,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
