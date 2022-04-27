import 'package:audiobookbay/constant.dart';
import 'package:audiobookbay/data/models/bookmark_model.dart';
import 'package:audiobookbay/widgets/books_list_tile.dart';
import 'package:flutter/material.dart';

import '../data/database/bookmarks_db.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  static const routeName = 'bookmark';

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  late List<Bookmark> bookmarks;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    refreshBookmarks();
  }

  @override
  void dispose() {
    BookmarkDatabase.instance.close();

    super.dispose();
  }

  Future refreshBookmarks() async {
    setState(() => isLoading = true);

    this.bookmarks = await BookmarkDatabase.instance.readAllBookmarks();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppLightColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bookmark",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  child: new Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new Icon(Icons.search),
                        new Container(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: new TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by Name',
                                //onSearchTextChanged,
                              ),
                              onChanged: (String text) async {
                                var res = await BookmarkDatabase.instance
                                    .searchName(text);
                                bookmarks = res;
                                setState(() {
                                  bookmarks = res;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                bookmarks.isEmpty
                    ? Center(
                        child: Text(
                          'No Bookmarks',
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < bookmarks.length; i++)
                            BookSListTile(
                              bookName: bookmarks[i].title,
                              img: bookmarks[i].img,
                              url: bookmarks[i].href,
                              fromBookmarkS: true,
                            ),
                        ],
                      ),
              ],
            ),
    );
  }
}
