import 'dart:ffi';

import 'package:flutter/material.dart';
import '../widgets/TagButton.dart';
import './Data/tag_object.dart';
import './Data/populartag_object.dart';
import '../../channel/channel_create.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'dart:math';

//String img = "https://media-exp1.licdn.com/dms/image/C560BAQG4QXbbg39AfQ/company-logo_100_100/0?e=2159024400&v=beta&t=QYCFMlTBClczprYLrvWL1W4sbCrWw0TmGfuUTapBmDY";
String randimg = "https://source.unsplash.com/random";
final storage = FlutterSecureStorage();
// final SERVER_URL = "https://amigo-269801.appspot.com";
final SERVER_URL = "http://10.0.0.66:3000";

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
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: TextField(
                  obscureText: false,
                  enableInteractiveSelection: true,
                  onChanged: (context) {
                    setState(
                      () {
                        searchQuery = context;
                        getTags();
                      },
<<<<<<< HEAD
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Try "Pickup Soccer"',
                        prefixIcon: Icon(Icons.search),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 1, 0, 10),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.body1,
                          children: [
                        WidgetSpan(child: Icon(Icons.pin_drop, size: 20)),
                        TextSpan(
                            text: "University of Central Florida",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ])),
                ),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Expanded(
                          child: CustomScrollView(slivers: <Widget>[
                        SliverToBoxAdapter(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
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
                                    if (index > 6)  return null;
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TagButton(
                                          tagID: index.toString(),
                                          name: "BasketballBasket",
                                          photo:
                                              "https://i.picsum.photos/id/${rng.nextInt(300)}/200/200.jpg"),
                                    );
                                  })),
                        ),
                        SliverToBoxAdapter(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: Text("Categories",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)))),
                        SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 0,
                              childAspectRatio: .95,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Container(
                                  // margin: EdgeInsets.symmetric(horizontal: 5),
                                  margin: EdgeInsets.all(1),
                                  child: TagButton(
                                      tagID: allTags[index].tagId,
                                      name: allTags[index].name,
                                      photo:
                                          "https://i.picsum.photos/id/${rng.nextInt(500)}/200/200.jpg"),
                                );
                              },
                              childCount: tagCount,
                            )),
                      ]))
                    ])),
                Container(
                    child: Column(
                  children: <Widget>[],
                ))
              ]),
        );
=======
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
              margin: EdgeInsets.fromLTRB(20, 1, 0, 10),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.body1,
                      children: [
                    WidgetSpan(child: Icon(Icons.pin_drop, size: 20)),
                    TextSpan(
                        text: "University of Central Florida",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ])),
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Expanded(
                      child: CustomScrollView(slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
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
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: TagButton(
                                    screen: widget.screen,
                                    tagID: popularTags[index].tagId,
                                    name: popularTags[index].name,
                                    photo:
                                        "https://i.picsum.photos/id/${rng.nextInt(500)}/200/200.jpg"),
                              );
                            },
                            itemCount: popularCount,
                          )),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
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
                                photo:
                                    "https://i.picsum.photos/id/${rng.nextInt(500)}/200/200.jpg",
                              ),
                            );
                          },
                          childCount: tagCount,
                        )),
                  ]))
                ])),
            Container(
                child: Column(
              children: <Widget>[],
            ))
          ]),
    );
>>>>>>> 95ab844b9de826676345b4d44c012598b9d3aa41
  }
}
