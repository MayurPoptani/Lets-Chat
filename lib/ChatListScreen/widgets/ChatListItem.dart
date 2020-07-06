import 'dart:async';
import 'package:lets_chat/ChatMessagePage/screens/ChatMessagePage.dart';
import 'package:lets_chat/Database/models/ChatItem.dart';
import 'package:lets_chat/Database/models/MessageItem.dart';
import 'package:lets_chat/Database/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math' as Math;

class ChatListItem extends StatefulWidget {
  final ChatItem chatItem;
  const ChatListItem(this.chatItem, {Key key}) : super(key: key);
  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  
  bool initialLoading = true;
  MessageItem lastMsg;
  Timer _timer;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => refreshLastMsg());
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        // contentPadding: EdgeInsets.only(left: 8),
        leading: Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26, ),]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Container(
              padding: EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Hero(
                tag: widget.chatItem.id,
                child: Image.asset("assets/avatars/"+((widget.chatItem.id)%5).toString()+".png", ),
              ),
            ),
          ),
        ),
        title: Text(widget.chatItem.reciever.toString(), 
                    style: TextStyle(fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 16, fontWeight: FontWeight.bold,),
                    softWrap: true, maxLines: 1, overflow: TextOverflow.clip, ),
        subtitle: Text(initialLoading?"Loading...":(lastMsg==null?"No Messages Yet":lastMsg.message),
                    style: TextStyle(fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 16, fontStyle: FontStyle.italic,),
                    softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,),
        trailing: Text(initialLoading?"":(lastMsg==null?"":DateFormat(DateFormat.ABBR_MONTH_DAY).format(lastMsg.dateTime)),
                    style: TextStyle(fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 13,),
                    softWrap: true, maxLines: 1, overflow: TextOverflow.clip,),
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatMessagePage(widget.chatItem)));
          print("Refreshing Last Msg");
          refreshLastMsg();
        },
      ),
    );
  }
  
  void refreshLastMsg() async {
    try {
      // db.rawQuery("SELECT * FROM "+MessageTable+" WHERE "+MessageItem.RECIEVER_ID+"="+widget.chatItem.id.toString()+" ORDER BY "+MessageItem.DATETIME+" DESC LIMIT 1")
      // db.rawQuery("SELECT * FROM "+MessageTable+" WHERE "+MessageItem.RECIEVER_ID+"="+widget.chatItem.id.toString()+" ORDER BY "+MessageItem.ID+" DESC LIMIT 1")
      db.query(MessageTable, limit: 1, orderBy: MessageItem.ID+" DESC", where: MessageItem.RECIEVER_ID+"=?", whereArgs: [widget.chatItem.id])
      .then((value) {
        if(value==null || value.length==0) {}
        else lastMsg = MessageItem.fromMap(value.last);
        setState(() => initialLoading = false);
      });
    } on DatabaseException catch (e) {
      print("DatabaseException E = "+e.toString());
      setState(() => initialLoading = false);
    } on Exception catch (e) {
      print("UnknownException E = "+e.toString());
      setState(() => initialLoading = false);
    }
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}