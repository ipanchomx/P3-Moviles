import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:image_picker/image_picker.dart';

part 'create_article_event.dart';
part 'create_article_state.dart';

class CreateArticleBloc extends Bloc<CreateArticleEvent, CreateArticleState> {
  final _cFirestore = FirebaseFirestore.instance;
  File _selectedPicture;
  CreateArticleBloc() : super(CreateArticleInitial());

  @override
  Stream<CreateArticleState> mapEventToState(
    CreateArticleEvent event,
  ) async* {
    if (event is PickImageEvent) {
      try {
        yield LoadingState();
        _selectedPicture = await _getImage();
        yield PickedImageState(image: _selectedPicture);
      } catch (e) {
        yield ErrorMessageState(errorMsg: "No se pudo obtener la imagen.");
      }
    } else if (event is SaveNewElementEvent) {
      if (_selectedPicture == null) {
        yield ErrorMessageState(errorMsg: "Error. No se seleccionó imagen.");
      }
      String imageUrl = await _uploadFile();
      try {
        if (imageUrl != null) {
          yield LoadingState();
          await _saveNoticias(event.noticia.copyWith(urlToImage: imageUrl));
          yield SavedNewState();
        } else {
          throw Exception("Img url = null");
        }
      } catch (e) {
        yield ErrorMessageState(errorMsg: "No se pudo guardar la noticia");
      }
    }
  }

  Future<String> _uploadFile() async {
    try {
      var stamp = DateTime.now();
      if (_selectedPicture == null) return null;
      // define upload task
      UploadTask task = FirebaseStorage.instance
          .ref("noticias/imagen_$stamp.png")
          .putFile(_selectedPicture);
      // execute task
      await task;
      // recuperar url del documento subido
      return await task.storage
          .ref("noticias/imagen_$stamp.png")
          .getDownloadURL();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("Error al subir la imagen: $e");
      return null;
    } catch (e) {
      // error
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  Future<bool> _saveNoticias(New noticia) async {
    try {
      await _cFirestore.collection("noticias").add(noticia.toJson());
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<File> _getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      throw Exception("Error");
    }
  }
}
