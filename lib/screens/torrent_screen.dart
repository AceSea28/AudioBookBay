import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant.dart';
import '../widgets/custom_elevated_button.dart';
import '../Api/api.dart';

AudioBookBayApi bookDetail = AudioBookBayApi();

class ScreenArguments {
  final String bookUrl;

  ScreenArguments(this.bookUrl);
}

class TorrentScreen extends StatefulWidget {
  static const routeName = 'torrent';

  @override
  State<TorrentScreen> createState() => _TorrentScreenState();
}

class _TorrentScreenState extends State<TorrentScreen> {
  _launchURL(String s) async {
    final url = s;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ScreenArguments; //to get arguments for named routes
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppLightColor,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Book",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: bookDetail.scrapBookDetails(args.bookUrl),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 6
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString(),
                    textAlign: TextAlign.center, textScaleFactor: 1.3),
              );
            }

            final book = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kAppDarkColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, bottom: 10, right: 10),
                        child: Column(
                          children: [
                            Image.network(
                              book['img'],
                              fit: BoxFit.fitHeight,
                              height: 200,
                            ),
                            SizedBox(height: 15),
                            Text(
                              book['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF364A63),
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomElevatedButton(
                              name: 'Torrent Download',
                              iconName: 'down1',
                              color: const Color(0xFF1F7F7B),
                              onTap: () {
                                _launchURL(book['torrent']);
                              },
                            ),
                            CustomElevatedButton(
                              name: 'Magnet Download',
                              iconName: 'ubutton',
                              color: const Color(0xFFDF432B),
                              onTap: () {
                                _launchURL(book['magnet']);
                              },
                            ),
                            CustomElevatedButton(
                              name: 'View Online',
                              iconName: 'eye',
                              color: kAppDarkColor,
                              onTap: () {
                                _launchURL(book['anon']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: Text(
                      '  Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF364A63),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kAppDarkColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Html(data: book['description']),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Similiar Torrents.',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF364A63),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  for (var i = 0; i < book['similar'].length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          TorrentScreen.routeName,
                          arguments:
                              ScreenArguments(book['similar'][i]["href"]),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kAppDarkColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/audio.svg',
                              height: 30,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                book['similar'][i]["title"],
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
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
