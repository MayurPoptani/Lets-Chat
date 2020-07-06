import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_chat/ChatMessagePage/widgets/MessageWidget.dart';
import 'package:lets_chat/Database/models/ChatItem.dart';
import 'package:lets_chat/Database/models/MessageItem.dart';
import 'package:lets_chat/Database/variables.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/global/themes.dart';
import 'package:lets_chat/main.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessagePage extends StatefulWidget {
  final ChatItem chatItem;
  const ChatMessagePage(this.chatItem, {Key key}) : super(key: key);
  @override
  _ChatMessagePageState createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  
  ScrollController _scrollController;
  TextEditingController inputController;
  bool isLoadingMore = false;
  List<MessageItem> msgs = [];
  // MessageBase msgBase;
  
  @override
  void initState() {
    // msgBase = MessageBase(widget.chatItem);
    _scrollController = ScrollController();
    inputController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateList(msgs.length);
    });
    
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          print("_scrollController updateList()");
          updateList(msgs.length);
        }
      }
    });
  }
  
  Future<void> updateList(int afterNumber, {bool fetchLatestMsg = false, int limit = 10}) async {
    var value = await db.query(MessageTable, 
      orderBy: MessageItem.ID+" DESC",
      limit: fetchLatestMsg?1:limit, offset: fetchLatestMsg?0:afterNumber,
      where: MessageItem.RECIEVER_ID+"=?", whereArgs: [widget.chatItem.id],
    );
    if(fetchLatestMsg) msgs.addAll(value.reversed.toList().map((e) => MessageItem.fromMap(e)).toList());
    else msgs.insertAll(0, value.reversed.toList().map((e) => MessageItem.fromMap(e)).toList());
    if(mounted) setState(() => isLoadingMore = false);
  }
  
  Future<void> loadMore() async {
    setState(() => isLoadingMore = true);
    updateList(msgs.length);
  }
  
  @override
  Widget build(BuildContext context) {
    print("Msgs Length = "+msgs.length.toString());
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: appBar(),
        body: Container( 
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              // Text("Conversation with", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              // Text(widget.chatItem.reciever, style: TextStyle(fontSize: 14)),
              // "Conversation with".text.extraBold.size(16).make().objectBottomLeft(),
              // widget.chatItem.reciever.text.bold.size(14).make().objectBottomLeft(),
              HeightBox(8),
              if(msgs==null || msgs.length==0) Expanded(child: Center(child: Text("No Messages Yet",),),)
              else Expanded(
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (_, i) => MessageWidget(msgs[msgs.length-i-1]),
                  cacheExtent: 500.0,
                ),
              ),
              HeightBox(8),
              messageInputWidget(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget messageInputWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(8),
        borderRadius: BorderRadius.circular(34),
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12, spreadRadius: 0),]
      ),
      child: TextFormField(
        controller: inputController,
        minLines: 1,
        maxLines: 8,
        textInputAction: TextInputAction.newline,
        cursorColor: LetsChat.isDark?Colors.white:Colors.black,
        style: TextStyle(letterSpacing: 0.25, fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 14.0),
        decoration: InputDecoration(
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.black, width: 0, style: BorderStyle.none)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(34), borderSide: BorderSide(color: Colors.black, width: 0, style: BorderStyle.none)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          hintText: "Say something...",
          fillColor: LetsChat.isDark?Colors.black:Colors.white,
          filled: true,
          focusColor: Colors.white,
          suffixIcon: IconButton(icon: Icon(Icons.arrow_forward, color: LetsChat.isDark?Colors.white:Colors.black,), onPressed: () async {
            if(inputController.text.trim().isNotEmpty) {
              print("TEXT = "+inputController.text.trim());
              MessageItem.addMessageItem(db, widget.chatItem.id, inputController.text.trim()).then((value) {
                if(value!=null && value>0 && mounted) {
                  updateList(msgs.length, fetchLatestMsg: true);
                }
              });
              setState(() => inputController.text="");
            } else {
              FocusManager.instance.primaryFocus.unfocus();
              setState(() => inputController.text="");
            }
          }),
        ),
      ),
    );
  }
  
  Widget appBar() {
    return AppBar(
      elevation: 8,
      title: Row(
        children: [
          leading(),
          WidthBox(8),
          Text(widget.chatItem.reciever, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,)),
        ],
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      actions: [
        ThemeSwitcher(
          clipper: ThemeSwitcherCircleClipper(),
          builder: (_) {
            return IconButton(icon: Icon(Icons.lightbulb_outline), onPressed: () {
              LetsChat.isDark = !LetsChat.isDark;
              ThemeSwitcher.of(_).changeTheme(theme: !LetsChat.isDark?lightTheme:darkTheme);
            });
          },
        ),
      ],
    );
  }
  
  Widget leading() {
    return FlatButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      visualDensity: VisualDensity.compact,
      onPressed: () => Navigator.of(context).pop(),
      child: Row(
        children: [
          Icon(Icons.arrow_back),
          Container(
            height: 32,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26, ),]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Hero(
                  tag: widget.chatItem.id,
                  child: Image.asset("assets/avatars/"+(widget.chatItem.id%6).toString()+".png",),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}