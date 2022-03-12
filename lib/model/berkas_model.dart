import 'dart:convert';

import 'package:equatable/equatable.dart';

class BerkasModel extends Equatable {
  final String ktp;
  final String ijazah;
  final String cv;

  const BerkasModel({
    required this.ktp,
    required this.ijazah,
    required this.cv,
  });

  BerkasModel copyWith({
    String? ktp,
    String? ijazah,
    String? cv,
  }) {
    return BerkasModel(
      ktp: ktp ?? this.ktp,
      ijazah: ijazah ?? this.ijazah,
      cv: cv ?? this.cv,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ktp': ktp,
      'ijazah': ijazah,
      'cv': cv,
    };
  }

  factory BerkasModel.fromMap(Map<String, dynamic> map) {
    return BerkasModel(
      ktp: map['ktp'] ?? '',
      ijazah: map['ijazah'] ?? '',
      cv: map['cv'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BerkasModel.fromJson(String source) =>
      BerkasModel.fromMap(json.decode(source));

  @override
  String toString() => 'BerkasModel(ktp: $ktp, ijazah: $ijazah, cv: $cv)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BerkasModel &&
        other.ktp == ktp &&
        other.ijazah == ijazah &&
        other.cv == cv;
  }

  @override
  int get hashCode => ktp.hashCode ^ ijazah.hashCode ^ cv.hashCode;

  @override
  List<Object?> get props => [ktp, ijazah, cv];
}
