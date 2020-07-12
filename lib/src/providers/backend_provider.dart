import 'package:http/http.dart' as http;
import 'package:virtual_city_app/src/models/CategoryHomeResponse.dart';
import 'package:virtual_city_app/src/models/SiteResponse.dart';

Future<List<CategoryHomeResponse>> getCategories() async {
  final res =
      await http.get('https://ra-utn-backend.herokuapp.com/api/category');
  return categoryFromJson(res.body);
}

Future<List<SiteResponse>> getSites(int categoryId) async {
  print(   'https://ra-utn-backend.herokuapp.com/api/site?categoryId=' +
      categoryId.toString());
  final res = await http.get(
      'https://ra-utn-backend.herokuapp.com/api/site?categoryId=' +
          categoryId.toString());
  return siteResponseFromJson(res.body);
}
