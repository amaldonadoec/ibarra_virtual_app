import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:virtual_city_app/src/models/CategoryHomeResponse.dart';
import 'package:virtual_city_app/src/providers/backend_provider.dart';
import 'package:virtual_city_app/src/routes/navigatorArgument.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      "assets/banner.png",
      "assets/banner2.png",
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'Ibarra Virtual',
            textAlign: TextAlign.justify,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            GFCarousel(
              height: 45,
              autoPlay: true,
              items: imageList.map(
                (url) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.black45,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Image(image: AssetImage(url))),
                  );
                },
              ).toList(),
              onPageChanged: (index) {},
            ),
            SizedBox(height: 10.0),

//            Expanded(
            Padding(
              padding:
                  const EdgeInsets.only(top: 0.0, left: 30.0, right: 30.0),
              child: Text(
                "El proyecto nace de la idea de contribuir al turismo realizando publicidad a los sitios emblemáticos de la ciudad de Ibarra, mediante el uso de nuevas tecnologías como es la Realidad Aumentada",
                style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    decorationStyle: TextDecorationStyle.solid),
                textAlign: TextAlign.justify,
              ),
            ),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
//              child: GFTypography(
//                type: GFTypographyType.typo5,
//                child: Expanded(
//                  child: Text(
//                    ".",
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 15.0,
//                      letterSpacing: 0.3,
//                      fontWeight: FontWeight.w300,
//                    ),
//                    textAlign: TextAlign.justify,
//                  ),
//                ),
//                dividerAlignment: Alignment.bottomLeft,
//              ),
//            ),
            Expanded(
                child: FutureBuilder(
              future: getCategories(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
//                print(snapshot.connectionState);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return _Categories(snapshot.data);
                }
              },
            )),
          ],
        )));
  }
}

class _Categories extends StatelessWidget {
  final List<CategoryHomeResponse> categories;

  _Categories(this.categories);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = categories[index];
              return InkWell(
                child: GFCard(
                    height: 175,
                    boxFit: BoxFit.cover,
                    imageOverlay: NetworkImage(category.image.url),
                    title: GFListTile(
                      title: Text(
                        category.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            backgroundColor: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )),
                onTap: () {
                  Navigator.pushNamed(context, 'map',
                      arguments: NavigatorArgument(
                          category.categoryId, category.name));
                },
              );
            }));
  }
}
