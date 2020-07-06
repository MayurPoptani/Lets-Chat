import 'package:lets_chat/Database/variables.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

class ChatItem extends Equatable {
  static const ID = "id";
  static const RECIEVER = "reciever";
  final int id;
  final String reciever;
  
  ChatItem({this.id, this.reciever});
  
  static ChatItem fromMap(Map<String,dynamic> data) => ChatItem(id: data[ID], reciever: data[RECIEVER]);
  
  static Future<int> addChatItem(Database db, String recieverName) async {
    int index = -1;
    try {
      print("DATABASE "+(db.isOpen?"OPEN":"CLOSED"));
      // index = await db.rawInsert("INSERT INTO "+ChatTable+" where(null, ?)", [recieverName]);
      index = await db.insert(ChatTable, {ChatItem.RECIEVER : recieverName});
    } on DatabaseException catch (e) {
      print("DatabaseException E = "+e.toString());
      index =  null;
    }
    return index;
  }

  @override List<Object> get props => [this.id, this.reciever];
  
}