// To parse this JSON data, do
//
//     final documentsInfoModel = documentsInfoModelFromJson(jsonString);

import 'dart:convert';

DocumentsInfoModel documentsInfoModelFromJson(String str) =>
    DocumentsInfoModel.fromJson(json.decode(str));

String documentsInfoModelToJson(DocumentsInfoModel data) =>
    json.encode(data.toJson());

class DocumentsInfoModel {
  DocumentsInfoModel({
    required this.success,
    required this.documents,
  });

  bool success;
  List<Document> documents;

  factory DocumentsInfoModel.fromJson(Map<String, dynamic> json) =>
      DocumentsInfoModel(
        success: json["success"],
        documents: List<Document>.from(
            json["documents"].map((x) => Document.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
      };
}

class Document {
  Document({
    required this.id,
    required this.type,
    required this.fileName,
    required this.mimeType,
    required this.path,
    required this.driverId,
    required this.v,
    required this.imageUrl,
  });

  String id;
  String type;
  String fileName;
  String mimeType;
  String path;
  String driverId;
  int v;
  String imageUrl;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["_id"],
        type: json["type"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        path: json["path"],
        driverId: json["driver_id"],
        v: json["__v"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "file_name": fileName,
        "mime_type": mimeType,
        "path": path,
        "driver_id": driverId,
        "__v": v,
        "image_url": imageUrl,
      };
}
