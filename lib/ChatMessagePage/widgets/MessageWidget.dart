import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_chat/main.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:lets_chat/Database/models/MessageItem.dart';

class MessageWidget extends StatefulWidget {
  final MessageItem msg;
  MessageWidget(this.msg);
  
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Align(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(width: context.screenWidth*0.15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: Text((widget.msg.message), style: TextStyle(letterSpacing: 0.25, fontFamily: GoogleFonts.latoTextTheme().toString(), fontSize: 14.0), softWrap: true, ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: LetsChat.isDark?Colors.black38:Colors.black12,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}