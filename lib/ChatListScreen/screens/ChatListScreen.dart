import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_chat/ChatListScreen/functions/dialogs.dart';
import 'package:lets_chat/ChatListScreen/widgets/ChatListItem.dart';
import 'package:lets_chat/Database/models/ChatItem.dart';
import 'package:lets_chat/Database/variables.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:animations/animations.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key key}) : super(key: key);
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with AutomaticKeepAliveClientMixin {
  List<ChatItem> chats = [];  
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshChatsList();
    });
  }
      
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container( 
        // padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeightBox(16),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Chat List", style: TextStyle(fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 16, fontWeight: FontWeight.w700),),
                    Text("Messages ("+(chats==null?0:chats.length.toString())+")", style: TextStyle(fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 16, fontWeight: FontWeight.w700),),
                  ],
                ),
              )
            ),
            HeightBox(8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: chats.length+1,
                itemBuilder: (_, i) {
                  if(i==chats.length) return Container(height: 50);
                  else return ChatListItem(chats[i]);
                } 
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        onPressed: () async {
          String str = await addNewChatItemDialog(context);
          if(str!=null && str.trim().isNotEmpty) {
            int index = await ChatItem.addChatItem(db, str);
            if(index!=null && index>0) refreshChatsList();
          }
        },
      ), 
    );
  }
  
  void refreshChatsList() async {
    db.query(ChatTable).then((value) {
      chats = (value.map((e) => ChatItem.fromMap(e))).toList();
      setState(() {});
    });
  }
  
  @override bool get wantKeepAlive => true;
}