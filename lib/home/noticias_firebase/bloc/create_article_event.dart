part of 'create_article_bloc.dart';

abstract class CreateArticleEvent extends Equatable {
  const CreateArticleEvent();

  @override
  List<Object> get props => [];
}

class SaveNewElementEvent extends CreateArticleEvent {
  final New noticia;

  SaveNewElementEvent({@required this.noticia});
  @override
  List<Object> get props => [noticia];
}

class PickImageEvent extends CreateArticleEvent {
  @override
  List<Object> get props => [];
}
