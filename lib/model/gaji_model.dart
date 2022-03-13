import 'dart:convert';

import 'package:equatable/equatable.dart';

class GajiModel extends Equatable {
  final int id;
  final int karyawanId;
  final double gajiBersih;
  final double bpjsTenaker;
  final double bonus;
  final String catatan;
  final String createdAt;

  const GajiModel({
    this.id = 0,
    required this.karyawanId,
    required this.gajiBersih,
    required this.bpjsTenaker,
    required this.bonus,
    required this.catatan,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [
      id,
      karyawanId,
      gajiBersih,
      bpjsTenaker,
      bonus,
      catatan,
      createdAt,
    ];
  }

  GajiModel copyWith({
    int? id,
    int? karyawanId,
    double? gajiBersih,
    double? bpjsTenaker,
    double? bonus,
    String? catatan,
    String? createdAt,
  }) {
    return GajiModel(
      id: id ?? this.id,
      karyawanId: karyawanId ?? this.karyawanId,
      gajiBersih: gajiBersih ?? this.gajiBersih,
      bpjsTenaker: bpjsTenaker ?? this.bpjsTenaker,
      bonus: bonus ?? this.bonus,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawanId': karyawanId,
      'gajiBersih': gajiBersih,
      'bpjsTenaker': bpjsTenaker,
      'bonus': bonus,
      'catatan': catatan,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory GajiModel.fromJson(String source) =>
      GajiModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GajiModel(id: $id, karyawanId: $karyawanId, gajiBersih: $gajiBersih, bpjsTenaker: $bpjsTenaker, bonus: $bonus, catatan: $catatan, createdAt: $createdAt)';
  }

  factory GajiModel.fromMap(Map<String, dynamic> map) {
    return GajiModel(
      id: map['id']?.toInt() ?? 0,
      karyawanId: map['karyawan_id']?.toInt() ?? 0,
      gajiBersih: map['gaji_bersih']?.toDouble() ?? 0.0,
      bpjsTenaker: map['bpjs_tenaker']?.toDouble() ?? 0.0,
      bonus: map['bonus']?.toDouble() ?? 0.0,
      catatan: map['catatan'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}
