import 'package:audiobookbay/constant.dart';
import 'package:audiobookbay/data/database/bookmarks_db.dart';
import 'package:audiobookbay/data/models/bookmark_model.dart';
import 'package:audiobookbay/screens/torrent_screen.dart';
import 'package:flutter/material.dart';

class BookSListTile extends StatefulWidget {
  final bookName;
  final img;
  final url;
  final cat;
  final content;
  bool fromBookmarkS;
  BookSListTile(
      {Key? key,
      this.fromBookmarkS = false,
      this.bookName,
      this.img,
      this.url,
      this.cat,
      this.content})
      : super(key: key);

  @override
  State<BookSListTile> createState() => _BookSListTileState();
}

class _BookSListTileState extends State<BookSListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        TorrentScreen.routeName,
        arguments: ScreenArguments(
          widget.url,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Stack(alignment: Alignment.bottomLeft, children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kAppDarkColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.only(
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 130),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.bookName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 70,
                      child: Text(
                        (widget.fromBookmarkS)
                            ? "\n\n\nClick to Open"
                            : "${widget.cat} \n\n${widget.content}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.only(left: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(widget.img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FutureBuilder(
                future: ifPresent(href: widget.url),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    bool isBookmark = snapshot.data;
                    return IconButton(
                      onPressed: () async {
                        if (isBookmark) {
                          await deleteBookmark(url: widget.url);
                        } else
                          await addBookmark(
                            title: widget.bookName,
                            href: widget.url,
                            img: widget.img,
                            cat: widget.cat,
                          );
                        setState(() {
                          isBookmark = !isBookmark;
                        });
                      },
                      icon: Icon(
                        (isBookmark)
                            ? Icons.bookmark
                            : Icons.bookmark_add_outlined,
                        color: Colors.red,
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ]),
      ),
    );
  }

  getCategoryList(String cat) {
    String category = '';
    int flag = 0;
    List<String> categoryList = [];
    for (int i = 0; i < cat.length - 1; i++) {
      if (cat[i] == ' ' && cat[i + 1] == ' ') {
        categoryList.add(category);
        print(category);
        category = '';
        i++;
      } else if (cat[i] == 'L' && cat[i + 1] == 'a') {
        flag = 1;
        break;
      } else {
        category = category + cat[i];
      }
    }
    if (flag != 1) categoryList.add(category + cat[cat.length - 1]);
    return categoryList;
  }

  Future addBookmark({
    required String title,
    required String href,
    required String img,
    required String cat,
  }) async {
    final bookmark = Bookmark(title: title, href: href, img: img);
    final categoryList = getCategoryList(cat);
    await BookmarkDatabase.instance.create(bookmark, categoryList);
  }

  Future<bool> ifPresent({
    required String href,
  }) async {
    bool result = await BookmarkDatabase.instance.checkIfPresent(href);
    return result;
  }

  Future deleteBookmark({
    required String url,
  }) async {
    await BookmarkDatabase.instance.delete(url);
  }
}
