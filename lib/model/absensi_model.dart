import 'dart:convert';

import 'package:equatable/equatable.dart';

class AbsensiModel extends Equatable {
  final int id;
  final int idKaryawan;
  final String waktuCheckIn;
  final String waktuCheckOut;
  final String lokasiCheckIn;
  final String lokasiCheckOut;
  final String tanggalAbsensi;

  const AbsensiModel({
    required this.id,
    required this.idKaryawan,
    required this.waktuCheckIn,
    required this.waktuCheckOut,
    required this.lokasiCheckIn,
    required this.lokasiCheckOut,
    required this.tanggalAbsensi,
  });

  @override
  List<Object> get props {
    return [
      id,
      idKaryawan,
      waktuCheckIn,
      waktuCheckOut,
      lokasiCheckIn,
      lokasiCheckOut,
      tanggalAbsensi
    ];
  }

  AbsensiModel copyWith({
    int? id,
    int? idKaryawan,
    String? waktuCheckIn,
    String? waktuCheckOut,
    String? lokasiCheckIn,
    String? lokasiCheckOut,
    String? tanggalAbsensi,
  }) {
    return AbsensiModel(
      id: id ?? this.id,
      idKaryawan: idKaryawan ?? this.idKaryawan,
      waktuCheckIn: waktuCheckIn ?? this.waktuCheckIn,
      waktuCheckOut: waktuCheckOut ?? this.waktuCheckOut,
      lokasiCheckIn: lokasiCheckIn ?? this.lokasiCheckIn,
      lokasiCheckOut: lokasiCheckOut ?? this.lokasiCheckOut,
      tanggalAbsensi: tanggalAbsensi ?? this.tanggalAbsensi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_karyawan': idKaryawan,
      'waktu_check_in': waktuCheckIn,
      'waktu_check_out': waktuCheckOut,
      'lokasi_check_in': lokasiCheckIn,
      'lokasi_check_out': lokasiCheckOut,
      'tanggal_absensi': tanggalAbsensi,
    };
  }

  factory AbsensiModel.fromMap(Map<String, dynamic> map) {
    return AbsensiModel(
      id: map['id']?.toInt() ?? 0,
      idKaryawan: map['id_karyawan']?.toInt() ?? 0,
      waktuCheckIn: map['waktu_check_in'] ?? '',
      waktuCheckOut: map['waktu_check_out'] ?? '',
      lokasiCheckIn: map['lokasi_check_in'] ?? '',
      lokasiCheckOut: map['lokasi_check_out'] ?? '',
      tanggalAbsensi: map['tanggal_absensi'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AbsensiModel.fromJson(String source) =>
      AbsensiModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AbsensiModel(idKaryawan: $idKaryawan, waktuCheckIn: $waktuCheckIn, waktuCheckOut: $waktuCheckOut, lokasiCheckIn: $lokasiCheckIn, lokasiCheckOut: $lokasiCheckOut)';
  }
}
