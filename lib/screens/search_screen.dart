import 'package:audiobookbay/constant.dart';
import 'package:audiobookbay/widgets/books_list_tile.dart';
import 'package:flutter/material.dart';
import '../Api/api.dart';

class SearchArguments {
  final String searchName;

  SearchArguments(this.searchName);
}

class SearchScreen extends StatefulWidget {
  static const routeName = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AudioBookBayApi audioBook = new AudioBookBayApi();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SearchArguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppLightColor,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Search",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: audioBook.scrapSearchData(args.searchName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final searchList = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < searchList.length; i++)
                    BookSListTile(
                      bookName: searchList[i]["title"],
                      img: searchList[i]["img"],
                      url: searchList[i]['url'],
                      cat: searchList[i]["cat"],
                      content: searchList[i]["postContent"],
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
