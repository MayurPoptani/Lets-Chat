import 'package:lets_chat/Database/variables.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

class MessageItem extends Equatable {
  static const ID = "id";
  static const RECIEVER_ID = "reciever_id";
  static const MESSAGE = "message";
  static const DATETIME = "dateTime";
  final int id;
  final int recieverId;
  final String message;
  final DateTime dateTime;
  
  MessageItem({this.id, this.recieverId, this.message, this.dateTime});
  
  static MessageItem fromMap(Map<String,dynamic> data) => MessageItem(
    id: data[ID], 
    recieverId: data[RECIEVER_ID], 
    message: data[MESSAGE], 
    dateTime: DateTime.parse(data[DATETIME].toString())
  );
  
  static Future<int> addMessageItem(Database db, int _recieverId, String _message) async {
    int index = -1;
    try {
      print("DATABASE "+(db.isOpen?"OPEN":"CLOSED"));
      // index = await db.rawInsert("INSERT INTO "+MessageTable+" where(null, ?, ?)", [_recieverId, _message]);
      index = await db.insert(MessageTable, {MessageItem.RECIEVER_ID : _recieverId, MessageItem.MESSAGE : _message});
    } on DatabaseException catch (e) {
      print("DatabaseException E = "+e.toString());
      index = null;
    }
    return index;
  }

  @override List<Object> get props => [this.id, this.recieverId, this.message, this.dateTime];
  
}