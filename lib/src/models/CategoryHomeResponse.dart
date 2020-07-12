import 'dart:convert';

List<CategoryHomeResponse> categoryFromJson(String str) =>
    List<CategoryHomeResponse>.from(
        json.decode(str).map((x) => CategoryHomeResponse.fromJson(x)));

String categoryToJson(List<CategoryHomeResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryHomeResponse {
  int categoryId;
  String name;
  String description;

  ImageCategory image;

  CategoryHomeResponse({
    this.categoryId,
    this.name,
    this.description,
    this.image,
  });

  factory CategoryHomeResponse.fromJson(Map<String, dynamic> json) =>
      CategoryHomeResponse(
        categoryId: json["categoryId"],
        name: json["name"],
        description: json["description"],
        image: json["image"] == null ? null : ImageCategory.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "name": name,
        "description": description,
        "image": image == null ? null : image.toJson(),
      };
}

class ImageCategory {
  String fileName;
  String url;

  ImageCategory({
    this.fileName,
    this.url,
  });

  factory ImageCategory.fromJson(Map<String, dynamic> json) => ImageCategory(
        fileName: json["fileName"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "url": url,
      };
}
