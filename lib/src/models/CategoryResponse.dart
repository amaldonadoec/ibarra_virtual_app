import 'dart:convert';

List<CategoryResponse> categoryFromJson(String str) =>
    List<CategoryResponse>.from(
        json.decode(str).map((x) => CategoryResponse.fromJson(x)));

String categoryToJson(List<CategoryResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryResponse {
  int categoryId;
  String name;
  String description;

  Image image;

  CategoryResponse({
    this.categoryId,
    this.name,
    this.description,
    this.image,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        categoryId: json["categoryId"],
        name: json["name"],
        description: json["description"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "name": name,
        "description": description,
        "image": image == null ? null : image.toJson(),
      };
}

class Image {
  String fileName;
  String url;

  Image({
    this.fileName,
    this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        fileName: json["fileName"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "url": url,
      };
}
