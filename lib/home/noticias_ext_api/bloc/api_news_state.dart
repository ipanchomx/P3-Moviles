part of 'api_news_bloc.dart';

abstract class ApiNewsState extends Equatable {
  const ApiNewsState();

  @override
  List<Object> get props => [];
}

class ApiNewsInitial extends ApiNewsState {}

class LoadingState extends ApiNewsState {}

class LoadedNewsState extends ApiNewsState {
  final List<New> noticiasList;

  LoadedNewsState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class LoadedSavedNewsState extends ApiNewsState {
  final List<New> noticiasList;

  LoadedSavedNewsState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class SavedNewSuccesState extends ApiNewsState {}

class ErrorMessageState extends ApiNewsState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
