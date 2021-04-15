import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_ext_api/item_noticia.dart';

import 'bloc/my_news_bloc.dart';

class MisNoticias extends StatefulWidget {
  MisNoticias({Key key}) : super(key: key);

  @override
  _MisNoticiasState createState() => _MisNoticiasState();
}

class _MisNoticiasState extends State<MisNoticias> {
  @override
  void initState() {
    BlocProvider.of<MyNewsBloc>(context).add(RequestAllNewsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyNewsBloc, MyNewsState>(
      listener: (context, state) {
        if (state is ErrorMessageState) {
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
        if (state is LoadedNewsState) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<MyNewsBloc>(context).add(RequestAllNewsEvent());
              return;
            },
            child: ListView.builder(
              itemCount: state.noticiasList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNoticia(
                  noticia: state.noticiasList[index],
                  fromApi: false,
                  saveNew: () {},
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
