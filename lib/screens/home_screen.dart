import 'package:flutter/material.dart';
import '../constant.dart';
import './bookmark_screen.dart';
import './search_screen.dart';

import '../widgets/custom_bottom_navigation_bar.dart';

class HomeScren extends StatefulWidget {
  const HomeScren({Key? key}) : super(key: key);

  @override
  State<HomeScren> createState() => _HomeScrenState();
}

class _HomeScrenState extends State<HomeScren> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (newpage) {
            setState(() {
              _selectedIndex = newpage;
            });
          },
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "AudioBook Bay (ABB)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffdf432b),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Audiobook search engine',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: kAppLightColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 15),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              SearchScreen.routeName,
                              arguments:
                                  SearchArguments(_textEditingController.text)),
                          child: Container(
                            width: 80,
                            decoration: const BoxDecoration(
                              color: kAppDarkColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: const Center(
                              child: Text('Search'),
                            ),
                          ),
                        ),
                        hintText: 'Search anything here...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF858585),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  width: 200,
                  child: Text(
                    'Download unabridged audiobook for free or share your audio books, safe, fast and high quality!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF737373),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const BookMarkScreen(),
            const Center(
              child: Text("Settings"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        backgroundColor: kAppLightColor,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.jumpToPage(_selectedIndex);
        },
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home_outlined),
            title: 'Home',
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.bookmark_outline),
            title: 'Bookmark',
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings_outlined),
            title: 'Setting',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
