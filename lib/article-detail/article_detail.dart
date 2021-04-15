import 'package:flutter/material.dart';
import 'package:google_login/models/new.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetail extends StatelessWidget {
  final New article;
  const ArticleDetail({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de noticia."),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 5, right: 15, left: 15),
              child: Text(
                article.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: Text(
                "${article.publishedAt}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            (article.urlToImage == null || article.urlToImage == "")
                ? Image.asset(
                    'assets/placeholder-image.png',
                    fit: BoxFit.fitWidth,
                  )
                : Image.network(
                    article.urlToImage,
                    fit: BoxFit.fitWidth,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Text(
                "${article.author ?? "Autor no disponible"}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "${article.description ?? "Descripcion no disponible"}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text(
                "${article.content ?? ""}",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  if (article.url != null) {
                    launch(article.url,
                        enableJavaScript: true,
                        forceWebView: true,
                        enableDomStorage: true);
                  } else {
                    launch("https://google.com",
                        enableJavaScript: true,
                        forceWebView: true,
                        enableDomStorage: true);
                  }
                },
                child: Text(
                  "Ver nota completa.",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
