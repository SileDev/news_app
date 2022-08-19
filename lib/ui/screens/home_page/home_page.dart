import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_app/ui/screens/home_page/components/news_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int categoryIndex = 0;
  List<String> categories = [
    "general",
    "business",
    "entertainment",
    "science",
    "health",
    "sports",
    "technology",
  ];

  void _setCurrentCategory(int index) {
    setState(() {
      categoryIndex = index;
    });
  }

  Future<Map<dynamic, dynamic>> _getPosts(String currentCategory) async {
    final httpResponse = await http.get(
      Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&category=$currentCategory&apiKey=5185057d777d40a4bce3280e8a4671ce"),
    );
    return jsonDecode(utf8.decode(httpResponse.bodyBytes));
    /*try {
        final httpResponse = await http.get(
          Uri.parse(
              "https://newsapi.org/v2/top-headlines?country=us&apiKey=5185057d777d40a4bce3280e8a4671ce"),
        );

        if (httpResponse.statusCode == 200) {
          var body = jsonDecode(utf8.decode(httpResponse.bodyBytes));
          return body['articles'];
        } else {
          //To catch the null assertion
          return null;
        }
      } catch (e) {
        //To catch the error message and use it in FutureBuilder
        return e;
      }
      */
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: const Color(0xfff7f7f7),
        appBar: AppBar(
          title: const Text(
            "News App",
          ),
          backgroundColor: const Color(0xffffffff),
          foregroundColor: const Color(0xff303030),
          bottom: TabBar(
            indicatorColor: const Color(0xffa7a7a7),
            labelPadding: const EdgeInsets.all(4),
            isScrollable: true,
            labelColor: const Color(0xff505050),
            labelStyle: Theme.of(context).textTheme.labelSmall,
            tabs: [
              InkWell(
                onTap: () => _setCurrentCategory(0),
                child: Column(
                  children: const [
                    Icon(Icons.newspaper_rounded),
                    Text("General"),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _setCurrentCategory(1),
                child: Column(
                  children: const [
                    Icon(Icons.business_center_rounded),
                    Text("Business"),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _setCurrentCategory(2),
                child: Column(
                  children: const [
                    Icon(Icons.camera_roll_rounded),
                    Text("Entertainment"),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _setCurrentCategory(3),
                child: Column(
                  children: const [
                    Icon(Icons.tungsten_rounded),
                    Text("Science"),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _setCurrentCategory(4),
                child: Column(
                  children: const [
                    Icon(Icons.monitor_heart_rounded),
                    Text("Health"),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _setCurrentCategory(5),
                child: Column(
                  children: const [
                    Icon(Icons.sports_gymnastics_rounded),
                    Text("Sports"),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _setCurrentCategory(6),
                child: Column(
                  children: const [
                    Icon(Icons.computer_rounded),
                    Text("Technology"),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _getPosts(categories[categoryIndex]),
          builder: (BuildContext ontext, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              Map obtainedData = snapshot.data!;
              List posts = obtainedData['articles'];
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemCount: posts.length,
                itemBuilder: (context, index) => NewsCard(
                  postIndex: index + 1,
                  providerName: posts[index]['source']['name'],
                  postTitle: posts[index]['title'],
                  imageUrl: posts[index]['urlToImage'],
                  postContent: posts[index]['content'],
                ),
              );
            } else {
              return const Center(
                //By default it only be displayed if is always trying getting
                //the data
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}































/*class Post {
  final String title;

  const Post({required this.title});

  static Post fromJson(json) => Post(title: json['posts']['title']);
}*/

/*builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(
              child: Text("Done"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },*/

/*
        import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_app/ui/screens/home_page/components/news_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Map> _getPosts() async {
      final httpResponse = await http.get(
        Uri.parse(
            "https://newsapi.org/v2/top-headlines?country=us&apiKey=5185057d777d40a4bce3280e8a4671ce"),
      );

      //if (httpResponse.statusCode == 200) {
      var body = jsonDecode(utf8.decode(httpResponse.bodyBytes));
      //print(body['articles']);
      return body;
    }

    return Scaffold(
      //appBar: AppBar(),
      body: FutureBuilder(
        future: _getPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            Map posts = snapshot.data;
            return ListView.builder(
              itemCount: posts['articles'].length,
              itemBuilder: (context, index) =>
                  Text(posts['articles'][index]['title']),
            );
          }
          if (snapshot.data.toString().contains("Failed host lookup")) {
            //"Failed host lookup" is the commonly message for a network connection error,
            //Check if the data is an error data type for network connection and show it to
            //users
            return const Center(
              child: Text("Network error"),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null) {
            return const Center(
              child: Text("Data not found"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              //By default it only be displayed if is always trying getting
              //the data
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Post {
  final String title;

  const Post({required this.title});

  static Post fromJson(json) => Post(title: json['posts']['title']);
}


/*builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(
              child: Text("Done"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },*/
        */
