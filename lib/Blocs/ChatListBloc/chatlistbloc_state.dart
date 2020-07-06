part of 'chatlistbloc_bloc.dart';

abstract class ChatListBlocState extends Equatable {
  const ChatListBlocState();
}

class ChatListBlocInitial extends ChatListBlocState {
  @override
  List<Object> get props => [];
}
