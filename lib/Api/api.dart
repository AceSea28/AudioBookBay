import 'dart:async';

import 'package:html/parser.dart';
import 'package:http/http.dart';

class AudioBookBayApi {
//scrapBookDetails('/audio-books/free-air-1919-sinclair-lewis/');
//scrapSearchData('harry');
//scrapDataCatWise('/audio-books/type/adults/');

  var _document;

  Future loadFullURL(String page) async {
    var client = Client();
    try {
      var _response = await client.get(Uri.parse(page));
      _document = parse(_response.body);
    } catch (e) {
      print(e.toString());
    }
    return true;
  }

  Future scrapBookDetails(String q) async {
    List simTorrData = [];
    await loadFullURL('http://audiobookbay.nl$q');
    var title = _document.getElementsByClassName('postTitle')[0].text;
    var cat = _document.getElementsByClassName('postInfo')[0].text.trim();
    var desc1 =
        _document.getElementsByClassName('desc')[0].outerHtml.toString();
    var imgHtml =
        parse(_document.getElementsByClassName('postContent')[0].outerHtml);
    var dllinks =
        parse(_document.getElementsByClassName('torrent_info')[0].outerHtml);
    var img = imgHtml.getElementsByTagName('img')[0].attributes['src'];
    var torrent = dllinks.getElementsByTagName('a')[0].attributes['href'];
    var dawn = dllinks.getElementsByTagName('a')[1].attributes['href'];
    var anon = dllinks.getElementsByTagName('a')[2].attributes['href'];
    var alltds = dllinks.getElementsByTagName('td').toList();
    var status1 = false;
    var status2 = false;
    var hash = "";
    List trackers = [];
    for (var i = 0; i < alltds.length; i++) {
      var td = alltds[i];
      if (status1) {
        trackers.add(td.text);
      } else if (status2) {
        hash = td.text;
      }

      if (td.text == "Tracker:") {
        status1 = true;
      } else if (td.text == "Info Hash:") {
        status2 = true;
      } else {
        status1 = false;
        status2 = false;
      }
    }
    var similarHtml = parse(_document.getElementById('rsidebar').outerHtml);
    var a = similarHtml.getElementsByTagName('a').toList();
    for (var i = 0; i < a.length; i++) {
      var href = a[i].attributes['href'];
      var title = a[i].text;
      if (title.trim() != "") {
        simTorrData.add({
          "title": title,
          "href": href,
        });
      }
    }
    var magnet = "magnet:?xt=urn:btih:$hash&tr=" + trackers.join('&tr=');
    var finalOut = {
      "title": title,
      "cat": cat,
      "torrent": "http://audiobookbay.nl/$torrent",
      "dawnload": "http://audiobookbay.nl/$dawn",
      "anon": "http://audiobookbay.nl/$anon",
      "magnet": magnet,
      "img": img,
      "description": desc1,
      "similar": simTorrData
    };
    print(finalOut);
    return finalOut;
  }

  Future scrapDataCatWise(String q) async {
    List finalOut = [];
    finalOut = await scrapSearchTorrent('http://audiobookbay.nl$q');
    return finalOut;
  }

  Future scrapSearchData(String q) async {
    List finalOut = [];
    finalOut = await scrapSearchTorrent('http://audiobookbay.nl/?s=$q');
    return finalOut;
  }

  Future scrapSearchTorrent(String q) async {
    List torrData = [];
    await loadFullURL('$q');
    var tables = _document.getElementsByClassName('post');
    for (int i = 0; i < tables.length; i++) {
      var htmlParse = parse(tables[i].outerHtml);

      torrData.add({
        'title': htmlParse.getElementsByTagName('h2').toList()[0].text,
        'url':
            htmlParse.getElementsByTagName('a').toList()[0].attributes['href'],
        'img':
            htmlParse.getElementsByTagName('img').toList()[0].attributes['src'],
        'cat': htmlParse
            .getElementsByClassName('postInfo')
            .toList()[0]
            .text
            .trim(),
        'postContent': htmlParse
            .getElementsByClassName('postContent')
            .toList()[0]
            .text
            .trim(),
      });
    }
    print(torrData);
    return torrData;
  }
}
