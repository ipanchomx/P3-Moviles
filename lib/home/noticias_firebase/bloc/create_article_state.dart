part of 'create_article_bloc.dart';

abstract class CreateArticleState extends Equatable {
  const CreateArticleState();

  @override
  List<Object> get props => [];
}

class LoadingState extends CreateArticleState {}

class CreateArticleInitial extends CreateArticleState {}

class PickedImageState extends CreateArticleInitial {
  final File image;

  PickedImageState({@required this.image});
  @override
  List<Object> get props => [image];
}

class SavedNewState extends CreateArticleInitial {
  List<Object> get props => [];
}

class ErrorMessageState extends CreateArticleInitial {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
