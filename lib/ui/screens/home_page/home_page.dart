import 'dart:convert';
import 'package:http/http.dart';
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

  bool pendingLoad = true;

  void _setCurrentCategory(int newIndex) {
    setState(() {
      pendingLoad = true;

      try {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 0),
          curve: Curves.easeOut,
        );
        // ignore: empty_catches
      } catch (e) {}

      categoryIndex = newIndex;
    });
  }

  ScrollController scrollController = ScrollController();
  _getPosts(String currentCategory) async {
    try {
      final httpResponse = await get(
        Uri.parse(
            "https://newsapi.org/v2/top-headlines?country=us&category=$currentCategory&apiKey=5185057d777d40a4bce3280e8a4671ce"),
      );
      if (httpResponse.statusCode == 200) {
        pendingLoad = false;
        return utf8.decode(httpResponse.bodyBytes);
      } else {
        pendingLoad = false;
        return null;
      }
    } catch (e) {
      pendingLoad = false;
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: const Text(
          "News App",
        ),
        backgroundColor: const Color(0xffffffff),
        foregroundColor: const Color(0xff303030),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _getPosts(categories[categoryIndex]),
        builder: (context, snapshot) {
          if (pendingLoad) {
            return const Center(
              //By default it only be displayed if is always trying getting
              //the data
              child: CircularProgressIndicator(
                color: Color(0xff202020),
              ),
            );
          } else if (snapshot.data.toString().contains("Failed host lookup")) {
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
          } else if (snapshot.hasData) {
            dynamic data = jsonDecode(snapshot.data.toString())['articles'];
            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemCount: data.length,
              itemBuilder: (context, index) => NewsCard(
                postIndex: index + 1,
                providerName: data[index]['source']['name'],
                postTitle: data[index]['title'],
                imageUrl: data[index]['urlToImage'],
                postContent: data[index]['content'],
              ),
            );
          } else {
            return const Center(
              //By default it only be displayed if is always trying getting
              //the data
              child: CircularProgressIndicator(
                color: Color(0xff202020),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        selectedLabelStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
        unselectedLabelStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
        ),
        selectedItemColor: const Color(0xff202020),
        unselectedItemColor: const Color(0xff808080),
        currentIndex: categoryIndex,
        showUnselectedLabels: true,
        onTap: (index) => _setCurrentCategory(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: "General",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_rounded),
            label: "Business",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_roll_rounded),
            label: "Entertainment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tungsten_rounded),
            label: "Science",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_rounded),
            label: "Health",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics_rounded),
            label: "Sports",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.computer_rounded),
            label: "Technology",
          ),
        ],
      ),
    );
  }
}
