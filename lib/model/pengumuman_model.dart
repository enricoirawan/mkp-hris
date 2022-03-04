import 'dart:convert';

import 'package:equatable/equatable.dart';

class PengumumanModel extends Equatable {
  final int id;
  final String title;
  final String createdAt;
  final String createdBy;
  final String detail;
  final String attachmentUrl;

  const PengumumanModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.createdBy,
    required this.detail,
    required this.attachmentUrl,
  });

  PengumumanModel copyWith({
    int? id,
    String? title,
    String? createdAt,
    String? createdBy,
    String? detail,
    String? attachmentUrl,
  }) {
    return PengumumanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      detail: detail ?? this.detail,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt,
      'created_by': createdBy,
      'detail': detail,
      'attachment_url': attachmentUrl,
    };
  }

  factory PengumumanModel.fromMap(Map<String, dynamic> map) {
    return PengumumanModel(
      id: map['id']?.toInt() ?? 0,
      createdAt: map['created_at'] ?? '',
      createdBy: map['created_by'] ?? '',
      detail: map['detail'] ?? '',
      attachmentUrl: map['attachment_url'] ?? '',
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PengumumanModel.fromJson(String source) =>
      PengumumanModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PengumumanModel(id: $id, createdAt: $createdAt, createdBy: $createdBy, detail: $detail, attachmentUrl: $attachmentUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PengumumanModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.detail == detail &&
        other.attachmentUrl == attachmentUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        detail.hashCode ^
        attachmentUrl.hashCode;
  }

  @override
  List<Object?> get props =>
      [createdAt, createdBy, detail, id, attachmentUrl, title];
}
