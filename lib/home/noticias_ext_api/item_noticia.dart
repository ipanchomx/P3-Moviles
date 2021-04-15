import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_login/article-detail/article_detail.dart';
import 'package:google_login/models/new.dart';
import 'package:share/share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ItemNoticia extends StatelessWidget {
  final New noticia;
  final bool fromApi;
  final Function saveNew;

  ItemNoticia({
    Key key,
    @required this.noticia,
    @required this.fromApi,
    @required this.saveNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child:
                      (noticia.urlToImage == null || noticia.urlToImage == "")
                          ? Image.asset(
                              'assets/placeholder-image.png',
                              fit: BoxFit.fitHeight,
                            )
                          : Image.network(
                              noticia.urlToImage,
                              fit: BoxFit.fitHeight,
                            ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArticleDetail(article: noticia),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${noticia.title}",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${noticia.publishedAt}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "${noticia.description ?? "Descripcion no disponible"}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "${noticia.author ?? "Autor no disponible"}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (fromApi)
                              IconButton(
                                icon: Icon(
                                  Icons.cloud_download,
                                  size: 25,
                                ),
                                onPressed: saveNew,
                              ),
                            IconButton(
                              icon: Icon(
                                Icons.share,
                                size: 25,
                              ),
                              onPressed: () {
                                shareArticle(noticia, context);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void shareArticle(New noticia, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("No se puede compartir, No hay conexión."),
          ),
        );
      return;
    }
    try {
      String urlImage = noticia.urlToImage ??
          "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png";
      final response = await get(Uri.parse(urlImage));
      String extension = urlImage.split(".").last.split('?').first;

      final Directory temp = await getTemporaryDirectory();
      final File imageFile =
          File('${temp.path}/${noticia.title ?? "noticia"}.$extension');
      imageFile.writeAsBytesSync(response.bodyBytes);

      Share.shareFiles(
        ['${temp.path}/${noticia.title ?? "noticia"}.$extension'],
        text:
            '${noticia.title ?? "Noticia"} - ${noticia.description ?? "Sin descripcion"}" \n ${noticia.url ?? ""}',
        subject: 'Checa esta noticia: ',
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Unable to share article."),
          ),
        );
    }
  }
}
