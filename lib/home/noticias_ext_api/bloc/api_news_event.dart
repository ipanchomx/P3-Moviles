part of 'api_news_bloc.dart';

abstract class ApiNewsEvent extends Equatable {
  const ApiNewsEvent();

  @override
  List<Object> get props => [];
}

class RequestApiNewsEvent extends ApiNewsEvent {
  final String query;

  RequestApiNewsEvent({@required this.query});
  @override
  List<Object> get props => [query];
}

class SaveNewToDbEvent extends ApiNewsEvent {
  final New article;

  SaveNewToDbEvent({@required this.article});
  @override
  List<Object> get props => [article];
}
