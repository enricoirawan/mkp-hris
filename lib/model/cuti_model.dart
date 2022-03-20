import 'dart:convert';

import 'package:equatable/equatable.dart';

class CutiModel extends Equatable {
  final int id;
  final int karyawanId;
  final String jenisCuti;
  final String alasan;
  final String status;
  final bool approved;
  final String approvedBy;
  final String rejectedBy;
  final String startDate;
  final String endDate;
  final String createdAt;
  final int durasiCuti;
  final String nama;

  const CutiModel({
    required this.id,
    required this.karyawanId,
    required this.jenisCuti,
    required this.alasan,
    required this.status,
    required this.approved,
    required this.approvedBy,
    required this.rejectedBy,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.durasiCuti,
    required this.nama,
  });

  @override
  List<Object> get props {
    return [
      id,
      karyawanId,
      jenisCuti,
      alasan,
      status,
      approved,
      approvedBy,
      rejectedBy,
      startDate,
      endDate,
      createdAt,
      durasiCuti,
      nama,
    ];
  }

  CutiModel copyWith({
    int? id,
    int? karyawanId,
    String? jenisCuti,
    String? alasan,
    String? status,
    bool? approved,
    String? approvedBy,
    String? rejectedBy,
    String? startDate,
    String? endDate,
    String? createdAt,
    int? durasiCuti,
    String? nama,
  }) {
    return CutiModel(
      id: id ?? this.id,
      karyawanId: karyawanId ?? this.karyawanId,
      jenisCuti: jenisCuti ?? this.jenisCuti,
      alasan: alasan ?? this.alasan,
      status: status ?? this.status,
      approved: approved ?? this.approved,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      durasiCuti: durasiCuti ?? this.durasiCuti,
      nama: nama ?? this.nama,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawanId': karyawanId,
      'jenisCuti': jenisCuti,
      'alasan': alasan,
      'status': status,
      'approved': approved,
      'approvedBy': approvedBy,
      'rejectedBy': rejectedBy,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'durasiCuti': durasiCuti,
      'nama': nama,
    };
  }

  factory CutiModel.fromMap(Map<String, dynamic> map) {
    return CutiModel(
      id: map['id']?.toInt() ?? 0,
      karyawanId: map['karyawan_id']?.toInt() ?? 0,
      jenisCuti: map['jenis_cuti'] ?? '',
      alasan: map['alasan'] ?? '',
      status: map['status'] ?? '',
      approved: map['approved'] ?? false,
      approvedBy: map['approved_by'] ?? '',
      rejectedBy: map['rejected_by'] ?? '',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      createdAt: map['created_at'] ?? '',
      durasiCuti: map['durasi_cuti']?.toInt() ?? 0,
      nama: map['Karyawan']['nama'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CutiModel.fromJson(String source) =>
      CutiModel.fromMap(json.decode(source));
}
