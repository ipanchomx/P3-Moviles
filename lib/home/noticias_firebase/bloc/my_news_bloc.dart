import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:image_picker/image_picker.dart';

part 'my_news_event.dart';
part 'my_news_state.dart';

class MyNewsBloc extends Bloc<MyNewsEvent, MyNewsState> {
  final _cFirestore = FirebaseFirestore.instance;

  MyNewsBloc() : super(MyNewsInitial());

  @override
  Stream<MyNewsState> mapEventToState(
    MyNewsEvent event,
  ) async* {
    if (event is RequestAllNewsEvent) {
      yield LoadingState();
      yield LoadedNewsState(noticiasList: await _getNoticias() ?? []);
    }
  }

  // recurpera la lista de docs en firestore
  // map a objet de dart
  // cada elemento agregarlo a una lista.
  Future<List<New>> _getNoticias() async {
    try {
      var noticias = await _cFirestore
          .collection("noticias")
          .orderBy("publishedAt", descending: true)
          .get();

      return noticias.docs
          .map(
            (element) => New(
              author: element["author"],
              title: element["title"],
              urlToImage: element["urlToImage"],
              url: element["url"],
              description: element["description"],
              // source: element["source"],
              publishedAt: DateTime.parse(element["publishedAt"]),
            ),
          )
          .toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
