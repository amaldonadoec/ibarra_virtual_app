// To parse this JSON data, do
//
//     final siteResponse = siteResponseFromJson(jsonString);

import 'dart:convert';

List<SiteResponse> siteResponseFromJson(String str) => List<SiteResponse>.from(json.decode(str).map((x) => SiteResponse.fromJson(x)));

String siteResponseToJson(List<SiteResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SiteResponse {
  int siteId;
  String name;
  double lat;
  double lng;
  String description;
  List<Audio> images;
  Audio audio;

  SiteResponse({
    this.siteId,
    this.name,
    this.lat,
    this.lng,
    this.description,
    this.images,
    this.audio,
  });

  factory SiteResponse.fromJson(Map<String, dynamic> json) => SiteResponse(
    siteId: json["siteId"],
    name: json["name"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    description: json["description"],
    images: List<Audio>.from(json["images"].map((x) => Audio.fromJson(x))),
    audio: json["audio"] == null ? null : Audio.fromJson(json["audio"]),
  );

  Map<String, dynamic> toJson() => {
    "siteId": siteId,
    "name": name,
    "lat": lat,
    "lng": lng,
    "description": description,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "audio": audio == null ? null : audio.toJson(),
  };
}

class Audio {
  String fileName;
  String url;

  Audio({
    this.fileName,
    this.url,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    fileName: json["fileName"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "fileName": fileName,
    "url": url,
  };
}
