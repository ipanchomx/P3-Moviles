import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_firebase/bloc/my_news_bloc.dart'
    as myNewsBloc;
import 'package:google_login/models/new.dart';

import 'bloc/create_article_bloc.dart';

class CrearNoticia extends StatefulWidget {
  CrearNoticia({Key key}) : super(key: key);

  @override
  _CrearNoticiaState createState() => _CrearNoticiaState();
}

class _CrearNoticiaState extends State<CrearNoticia> {
  File slectedImage;
  CreateArticleBloc _bloc;
  var autorTc = TextEditingController();
  var tituloTc = TextEditingController();
  var descrTc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = CreateArticleBloc();
        return _bloc;
      },
      child: BlocConsumer<CreateArticleBloc, CreateArticleState>(
        listener: (context, state) {
          if (state is PickedImageState) {
            slectedImage = state.image;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Imagen seleccionada"),
                ),
              );
          } else if (state is SavedNewState) {
            BlocProvider.of<myNewsBloc.MyNewsBloc>(context)
                .add(myNewsBloc.RequestAllNewsEvent());
            autorTc.clear();
            tituloTc.clear();
            descrTc.clear();
            slectedImage = null;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Noticia guardada.."),
                ),
              );
          } else if (state is ErrorMessageState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("${state.errorMsg}"),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _createForm();
        },
      ),
    );
  }

  Widget _createForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            slectedImage != null
                ? Image.file(
                    slectedImage,
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    child: Placeholder(),
                  ),
            SizedBox(height: 16),
            TextField(
              controller: autorTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Autor',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tituloTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Titulo',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descrTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripcion',
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              child: Text("Imagen"),
              onPressed: () {
                _bloc.add(PickImageEvent());
              },
            ),
            MaterialButton(
              child: Text("Guardar"),
              onPressed: () {
                _bloc.add(
                  SaveNewElementEvent(
                    noticia: New(
                      author: autorTc.text,
                      title: tituloTc.text,
                      description: descrTc.text,
                      publishedAt: DateTime.now(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
