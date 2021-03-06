import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ChannelCard extends StatefulWidget {
    final String channelId;
    final String name;
    final String description;
    final int memberCount;
    final String photo;

    const ChannelCard ({Key key, @required this.channelId, @required this.name, @required this.description, @required this. memberCount, @required this.photo }) : super(key:key);

    @override
    _ChannelCardState createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {

  final storage = FlutterSecureStorage();
  final SERVER_URL = "https://amigo-269801.appspot.com";

  void addUserToChannel(String channelId) async {
    var key = await storage.read(key: "jwt");

    var res = await http.post(
      "$SERVER_URL/api/channels/join",
      headers: {"x-access-token": key},
      body: {
        "channel_id": channelId
      }
    );

    if (res.statusCode == 200) {
      print('User was added to channel');
      return jsonDecode(res.body);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Card(
            color: Colors.white10,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Image.network(
                    "https://cdn2.iconfinder.com/data/icons/activity-5/50/1F3C0-basketball-512.png",
                    height: 75,
                    width: 75,
                  ),
                ),
                Container(
                    height: 100,
                    width: 180,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          Text(widget.memberCount.toString(),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11)),
                        ])),
                OutlineButton(
                    onPressed: () => addUserToChannel(widget.channelId),
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text("Join"),
                    borderSide: BorderSide(
                      color: Colors.red,
                      style: BorderStyle.solid,
                      width: 2,
                    ))
              ],
            )));
    }
  }