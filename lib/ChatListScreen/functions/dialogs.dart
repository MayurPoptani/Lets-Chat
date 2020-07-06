import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_chat/main.dart';

Future<String> addNewChatItemDialog(BuildContext context) async {
  var controller = TextEditingController();
  return await showDialog<String>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    barrierColor: !LetsChat.isDark?null:Colors.white.withOpacity(0.05),
    builder: (_) {
      return AlertDialog(
        backgroundColor: LetsChat.isDark?Colors.black:Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("New Chat Item", style: TextStyle(letterSpacing: 0.25,),),
        content: Container(
          color: LetsChat.isDark?Colors.black:Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller,
                cursorColor: LetsChat.isDark?Colors.white:Colors.black,
                style: TextStyle(letterSpacing: 0.25, fontSize: 14.0),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  filled: true,
                  hintText: "Eg: Hawkey Eye...",
                  fillColor: LetsChat.isDark?Colors.white24:Colors.black.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.black, width: 0, style: BorderStyle.none)),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: LetsChat.isDark?Colors.white24:Colors.black12,
                child: Text("Add", style: TextStyle(color: LetsChat.isDark?Colors.white:Colors.black87),),
                onPressed: () {
                  if(controller.text.trim().isNotEmpty) {
                    Navigator.of(context, rootNavigator: true).pop<String>(controller.text.trim());
                  }
                }
              ),
            ],
          ),
        ),
      );
    }
  );
}