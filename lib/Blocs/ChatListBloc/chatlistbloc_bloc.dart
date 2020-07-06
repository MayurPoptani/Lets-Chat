import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chatlistbloc_event.dart';
part 'chatlistbloc_state.dart';

class ChatListBloc extends Bloc<ChatListBlocEvent, ChatListBlocState> {
  
  ChatListBloc() : super(ChatListBlocInitial());

  @override
  Stream<ChatListBlocState> mapEventToState(
    ChatListBlocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
