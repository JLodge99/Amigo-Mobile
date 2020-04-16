import 'package:flutter/material.dart';
import '../widgets/TagButton.dart';
import './Data/tag_object.dart';
import './Data/populartag_object.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'dart:math';
import 'package:path/path.dart';

String randimg = "https://source.unsplash.com/random";
final storage = FlutterSecureStorage();
final SERVER_URL = "https://amigo-269801.appspot.com";

class DiscoverTagView extends StatefulWidget {
  final int screen; // 0 - DiscoverTagView  1 - Channel Create

  const DiscoverTagView({Key key, @required this.screen})
      : super(key: key);

  @override
  _DiscoverTagViewState createState() => _DiscoverTagViewState();
}

class _DiscoverTagViewState extends State<DiscoverTagView> {
  String searchQuery = "";
  var popularTags;
  var allTags;
  int tagCount = 0;
  int popularCount = 0;
  var rng = new Random();
  var thing = 'a';

  void getTags() async {
    var key = await storage.read(key: "jwt");
    var res = await http.get(
      "$SERVER_URL/api/tags?school_id=1&query=$searchQuery",
      headers: {"x-access-token": key},
    );
    if (res.statusCode == 200) {
      Map response = json.decode(res.body);
      setState(() {
        if (searchQuery == null) searchQuery = "";

        allTags = Tag.fromJson(response).tags;
        tagCount = allTags.length;
      });
    } else
      print(res.body.toString());
  }

  void getPopularTags() async {
    var key = await storage.read(key: "jwt");
    var res = await http.get(
      "$SERVER_URL/api/tags/popular",
      headers: {"x-access-token": key},
    );

    if (res.statusCode == 200) {
      Map response = json.decode(res.body);
      setState(() {
        if (searchQuery == null) searchQuery = "";

        popularTags = Populartag.fromJson(response).tags;
        popularCount = popularTags.length;
      });
    } else
      print(res.body.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getTags();
    getPopularTags();
  }

  @override
  Widget build(BuildContext context) {
    
    var route = ModalRoute.of(context);
    var routeName = route.settings.name;
    
    if (route != null) {
      print('route name: $routeName');
    }
    // Navigator.pop(context);

    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 50,
                margin: EdgeInsets.only(top: 5),
                child: TextField(
                  obscureText: false,
                  enableInteractiveSelection: true,
                  onChanged: (context) {
                    setState(
                      () {
                        searchQuery = context;
                        getTags();
                      },
                    );
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Try "Coding"',
                    prefixIcon:
                        Icon(Icons.search, color: Colors.grey, size: 20.0),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.school, size: 19, color: Colors.grey[400]),
                ),
                Text('University of Central Florida', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey[600]))
              ],)
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Expanded(
                      child: CustomScrollView(slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text("Popular Now",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)))),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: TagButton(
                                  tagID: allTags[index].tagId,
                                  name: allTags[index].name,
                                  photo: allTags[index].photo
                              )
                            );
                          },
                          itemCount: popularCount,
                        )
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text("Categories",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)))),
                    SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 0,
                          childAspectRatio: .95,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: TagButton(
                                screen: widget.screen,
                                tagID: allTags[index].tagId,
                                name: allTags[index].name,
                                photo: allTags[index].photo,
                              )
                            );
                          },
                          childCount: tagCount,
                        )),
                  ]))
                ])),
          ]),
    );
  }
}
