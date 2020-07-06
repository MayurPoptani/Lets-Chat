import 'dart:io';

import 'package:lets_chat/Database/models/ChatItem.dart';
import 'package:lets_chat/Database/models/MessageItem.dart';
import 'package:lets_chat/Database/variables.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const DATABASEFILENAME = "myDatabase.db";

bool isNewlyCreated = false;

void _onOpen(Database _db) async {
  db = _db;
  print("Database Opened");
  if(!isNewlyCreated) return;
  try{
    await db.execute('CREATE TABLE '+ChatTable+' ('+ChatItem.ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '+ChatItem.RECIEVER+' TEXT)');
  } on DatabaseException catch (e) {
    print("SqfliteDatabaseException E = "+e.toString());
  }
  try{
    await db.execute('CREATE TABLE '+MessageTable+' ('+MessageItem.ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '+MessageItem.RECIEVER_ID+' INTEGER, '+MessageItem.MESSAGE+' TEXT, '+MessageItem.DATETIME+' DATETIME2(3) DEFAULT CURRENT_TIMESTAMP)');
  } on DatabaseException catch (e) {
    print("SqfliteDatabaseException E = "+e.toString());
  }
  
  ///////////////////// DUMMY DATA INSERT START /////////////////////
  try{
    
    print(await ChatItem.addChatItem(db, "Tony Stark"));
    print(await ChatItem.addChatItem(db, "Steve Rogers"));
    print(await ChatItem.addChatItem(db, "Peter Parker"));
    print(await ChatItem.addChatItem(db, "Natasha Ramanof"));
    print(await ChatItem.addChatItem(db, "Stan Lee"));
    
    print(await MessageItem.addMessageItem(db, 1, "Hello Tony"));
    print(await MessageItem.addMessageItem(db, 1, "How is your Mark 92 suit coming up?"));
    print(await MessageItem.addMessageItem(db, 2, "Hey Steve"));
    print(await MessageItem.addMessageItem(db, 2, "How's you and bucky?"));
    print(await MessageItem.addMessageItem(db, 3, "Hi Peter"));
    print(await MessageItem.addMessageItem(db, 3, "How was your date with MJ?"));
    print(await MessageItem.addMessageItem(db, 4, "Agent Romanof"));
    print(await MessageItem.addMessageItem(db, 4, "Did you finished the Hydra Assignment?"));
    print(await MessageItem.addMessageItem(db, 5, "Dear Stan Lee"));
    print(await MessageItem.addMessageItem(db, 5, "We Miss You"));
    print(await MessageItem.addMessageItem(db, 5, "We Love You 3000!"));
    
    print("PRINTING TABLE DATA");
    print((await db.query(MessageTable)).toString());
  }
  on DatabaseException catch (e) {
    print("DatabaseException. E = "+e.toString());
  }
  ////////////////////// DUMMY DATA INSERT END //////////////////////
  
}

/// Creates database to application default database directory and adds 5 initial chats item and one initial message per chat item.
Future<void> initDatabase() async {
  // Sqflite.setDebugModeOn(true);
  //ignore: deprecated_member_use
  // Sqflite.devSetDebugModeOn(true);
  String dbFolderPath = await getDatabasesPath();
  var path = join(dbFolderPath, DATABASEFILENAME);
  if(!File(path).existsSync()) File(path).createSync(recursive: true);
  // UNCOMMENT ONLY TO RESET DATABASE
  // await deleteDatabase(path);
  db = await openDatabase(path,
    version: 1,
    onCreate: (db, version) {
      print("Database Created With Version: "+version.toString());
      isNewlyCreated = true;
    },
    onOpen: _onOpen,
    singleInstance: true,
  );
  
}