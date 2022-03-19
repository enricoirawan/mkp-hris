import 'dart:convert';

import 'package:equatable/equatable.dart';

class CutiModel extends Equatable {
  final int id;
  final int karyawanId;
  final String jenisCuti;
  final String alasan;
  final bool approved;
  final String approvedBy;
  final String startDate;
  final String endDate;
  final String createdAt;
  final int durasiCuti;

  const CutiModel({
    required this.id,
    required this.karyawanId,
    required this.jenisCuti,
    required this.alasan,
    required this.approved,
    required this.approvedBy,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.durasiCuti,
  });

  @override
  List<Object> get props {
    return [
      id,
      karyawanId,
      jenisCuti,
      alasan,
      approved,
      approvedBy,
      startDate,
      endDate,
      createdAt,
      durasiCuti,
    ];
  }

  CutiModel copyWith({
    int? id,
    int? karyawanId,
    String? jenisCuti,
    String? alasan,
    bool? approved,
    String? approvedBy,
    String? startDate,
    String? endDate,
    String? createdAt,
    int? durasiCuti,
  }) {
    return CutiModel(
      id: id ?? this.id,
      karyawanId: karyawanId ?? this.karyawanId,
      jenisCuti: jenisCuti ?? this.jenisCuti,
      alasan: alasan ?? this.alasan,
      approved: approved ?? this.approved,
      approvedBy: approvedBy ?? this.approvedBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      durasiCuti: durasiCuti ?? this.durasiCuti,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawanId': karyawanId,
      'jenisCuti': jenisCuti,
      'alasan': alasan,
      'approved': approved,
      'approvedBy': approvedBy,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'durasiCuti': durasiCuti,
    };
  }

  factory CutiModel.fromMap(Map<String, dynamic> map) {
    return CutiModel(
      id: map['id']?.toInt() ?? 0,
      karyawanId: map['karyawan_id']?.toInt() ?? 0,
      jenisCuti: map['jenis_cuti'] ?? '',
      alasan: map['alasan'] ?? '',
      approved: map['approved'] ?? false,
      approvedBy: map['approved_by'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      createdAt: map['created_at'] ?? '',
      durasiCuti: map['durasi_cuti']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CutiModel.fromJson(String source) =>
      CutiModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CutiModel(id: $id, karyawanId: $karyawanId, jenisCuti: $jenisCuti, alasan: $alasan, approved: $approved, approvedBy: $approvedBy, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, durasiCuti: $durasiCuti)';
  }
}
