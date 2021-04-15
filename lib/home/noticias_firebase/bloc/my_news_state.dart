part of 'my_news_bloc.dart';

abstract class MyNewsState extends Equatable {
  const MyNewsState();

  @override
  List<Object> get props => [];
}

class MyNewsInitial extends MyNewsState {}

class LoadingState extends MyNewsState {}

class LoadedNewsState extends MyNewsState {
  final List<New> noticiasList;

  LoadedNewsState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class ErrorMessageState extends MyNewsState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
