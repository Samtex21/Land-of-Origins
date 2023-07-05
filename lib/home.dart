import 'dart:async';
import 'package:beautiful_land_2/LanguageDropdown.dart';
import 'package:beautiful_land_2/Screens/comment_view.dart';
import 'package:beautiful_land_2/model/json_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:beautiful_land_2/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


Future<List<Description>> ReadJsonData() async {
  final jsondata = await rootBundle.loadString('json/place.json');
  final list = json.decode(jsondata) as List<dynamic>;
  return list.map((e) => Description.fromJson(e)).toList();
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
final Color primary = HexColor('#ECF39E');
final Color secondary = HexColor('#90A955');
final Color buttonColor = HexColor('#132A13');
final Color backgroundColor = HexColor('#4F772D');
final Color backgroundColor2 = HexColor('#31572C');


final List<Widget> _widgetRoom = <Widget>[
  Text('Home'),
];


class _HomeState extends State<Home> {
  GlobalKey<_HomeState> _pageKey = GlobalKey<_HomeState>();
  final TextEditingController commentController = TextEditingController();

  Future<void> postComment(String id, String comment) async {
    final url = Uri.parse('https://ethiotours.000webhostapp.com/comments.php');
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'id': id,
      'appId': '2',
      'comment': comment,
      'name': 'Someone',
    });
    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      // Comment posted successfully
      print('Comment posted successfully');
      // Clear the comment text field
      commentController.clear();
      // Fetch and refresh the comments
      // You can call the fetchComments() method here or use any other approach to update the comments list
    } else {
      // Handle any errors
      print('Failed to post comment');
      commentController.clear();
    }
  }


  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  int current = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }
  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    commentController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ethiopia'.tr(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome to the Land of beauity and Wonder'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: <Widget>[
          LanguageDropdown(onLanguageChanged: () {
            _pageKey.currentState?.setState(() {});
          }),
        ],
        backgroundColor: backgroundColor2,

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Natural Wonders".tr(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#132A13')
              ),
            ),
          ),
          Divider(  // Add this Divider widget
            color: HexColor('#31572C'),
            height: 1,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          FutureBuilder(
            future: ReadJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text('${data.error}'));
              } else if (data.hasData) {
                var items = data.data as List<Description>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index) {
                    return (items[index].category.toString() == 'Natural Wonders')
                        ? Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(items[index].name.toString().tr()),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Text(
                              items[index].description.toString(),
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Image.asset('assets/images/${items[index].image.toString()}'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                return Map(
                                  name: items[index].name?.toString(),
                                  longitude: items[index].longitude?.toDouble(),
                                  latitude: items[index].latitude.toDouble(),
                                );
                              }));
                            },
                            child: Text(
                              "Show me location".tr(),
                              style: TextStyle(
                                color: HexColor('#31572C'),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    maxLines: 1,
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: 'write comment'.tr(),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 3,
                                          color: backgroundColor2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String comment = commentController.text;
                                    if (comment.isNotEmpty) {
                                      postComment(items[index].id.toString(), comment);
                                    }
                                  },
                                  child: Text("Post".tr()),
                                  style: ElevatedButton.styleFrom(
                                    primary: backgroundColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 310, 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Comments(id: items[index].id.toString()),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(1.0, 0.0), // Start the new page from the right side
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'comments'.tr(),
                                style: TextStyle(
                                  color: HexColor('#31572C'),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(child: null);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "National Parks".tr(),
              style: TextStyle(
                fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#132A13')
              ),
            ),
          ),
          Divider(  // Add this Divider widget
            color: HexColor('#31572C'),
            height: 1,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          FutureBuilder(
            future: ReadJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text('${data.error}'));
              } else if (data.hasData) {
                var items = data.data as List<Description>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index) {
                    return (items[index].category.toString() == 'Wildlife and National Parks')
                        ? Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(items[index].name.toString().tr()),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Text(
                              items[index].description.toString(),
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Image.asset('assets/images/${items[index].image.toString()}'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                return Map(
                                  name: items[index].name?.toString(),
                                  longitude: items[index].longitude?.toDouble(),
                                  latitude: items[index].latitude.toDouble(),
                                );
                              }));
                            },
                            child: Text(
                              "Show me location".tr(),
                              style: TextStyle(
                                color: HexColor('#31572C'),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    maxLines: 1,
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: 'write comment'.tr(),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 3,
                                          color: backgroundColor2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String comment = commentController.text;
                                    if (comment.isNotEmpty) {
                                      postComment(items[index].id.toString(), comment);
                                    }
                                  },
                                  child: Text("Post".tr()),
                                  style: ElevatedButton.styleFrom(
                                    primary: backgroundColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 310, 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Comments(id: items[index].id.toString()),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(1.0, 0.0), // Start the new page from the right side
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'comments'.tr(),
                                style: TextStyle(
                                  color: HexColor('#31572C'),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(child: null);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Historical Places".tr(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#132A13')
              ),
            ),
          ),
          Divider(  // Add this Divider widget
            color: HexColor('#31572C'),
            height: 1,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          FutureBuilder(
            future: ReadJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text('${data.error}'));
              } else if (data.hasData) {
                var items = data.data as List<Description>;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index) {
                    return (items[index].category.toString() == 'Historical and Cultural Sites')
                        ? Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(items[index].name.toString().tr()),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Text(
                              items[index].description.toString(),
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Image.asset('assets/images/${items[index].image.toString()}'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                return Map(
                                  name: items[index].name?.toString(),
                                  longitude: items[index].longitude?.toDouble(),
                                  latitude: items[index].latitude.toDouble(),
                                );
                              }));
                            },
                            child: Text(
                              "Show me location".tr(),
                              style: TextStyle(
                                color: HexColor('#31572C'),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    maxLines: 1,
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: 'write comment'.tr(),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.all(10),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 3,
                                          color: backgroundColor2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String comment = commentController.text;
                                    if (comment.isNotEmpty) {
                                      postComment(items[index].id.toString(), comment);
                                    }
                                  },
                                  child: Text("Post".tr()),
                                  style: ElevatedButton.styleFrom(
                                    primary: backgroundColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 310, 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Comments(id: items[index].id.toString()),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(1.0, 0.0), // Start the new page from the right side
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'comments'.tr(),
                                style: TextStyle(
                                  color: HexColor('#31572C'),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(child: null);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      )
    );
  }
}
