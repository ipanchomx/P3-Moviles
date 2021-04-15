import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:hive/hive.dart';
import 'package:connectivity/connectivity.dart';

part 'api_news_event.dart';
part 'api_news_state.dart';

class ApiNewsBloc extends Bloc<ApiNewsEvent, ApiNewsState> {
  ApiNewsBloc() : super(ApiNewsInitial());

  Box _newsBox = Hive.box("News");

  @override
  Stream<ApiNewsState> mapEventToState(
    ApiNewsEvent event,
  ) async* {
    if (event is RequestApiNewsEvent) {
      try {
        yield LoadingState();
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          List<New> newsList =
              await NewsRepository().getAvailableNoticias(event.query);

          List<New> offlineNewsList =
              newsList.map((New e) => e.copyWith(urlToImage: "")).toList();

          await _newsBox.put('articles', offlineNewsList);
          yield LoadedNewsState(noticiasList: newsList);
        } else {
          List<New> newsList = List<New>.from(
            _newsBox.get("articles", defaultValue: []),
          );
          print(newsList);

          yield LoadedSavedNewsState(noticiasList: newsList);
        }
      } catch (e) {
        print(e);
        yield ErrorMessageState(
            errorMsg: "No se pudo obtener lista de noticias");
      }
    } else if (event is SaveNewToDbEvent) {}
  }
}
