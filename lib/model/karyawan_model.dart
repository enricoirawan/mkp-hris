import 'dart:convert';

import 'package:equatable/equatable.dart';

class KaryawanModel extends Equatable {
  final int id;
  final String nama;
  final String email;
  final String npwp;
  final int gaji;
  final String fotoUrl;
  final String jabatan;
  final String alamat;
  final String tanggalBergabung;
  final int divisi;
  final int roleId;
  final String noRekening;
  final int sisaCuti;
  final bool active;
  final String errorMessage;

  const KaryawanModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.npwp,
    required this.gaji,
    required this.fotoUrl,
    required this.jabatan,
    required this.alamat,
    required this.tanggalBergabung,
    required this.divisi,
    required this.roleId,
    required this.noRekening,
    required this.sisaCuti,
    required this.active,
    this.errorMessage = "",
  });

  KaryawanModel copyWith({
    int? id,
    String? nama,
    String? email,
    String? npwp,
    int? gaji,
    String? fotoUrl,
    String? jabatan,
    String? alamat,
    String? tanggalBergabung,
    int? divisi,
    int? roleId,
    String? noRekening,
    int? sisaCuti,
    bool? active,
    String? errorMessage,
  }) {
    return KaryawanModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      npwp: npwp ?? this.npwp,
      gaji: gaji ?? this.gaji,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      jabatan: jabatan ?? this.jabatan,
      alamat: alamat ?? this.alamat,
      tanggalBergabung: tanggalBergabung ?? this.tanggalBergabung,
      divisi: divisi ?? this.divisi,
      roleId: roleId ?? this.roleId,
      noRekening: noRekening ?? this.noRekening,
      sisaCuti: sisaCuti ?? this.sisaCuti,
      active: active ?? this.active,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'npwp': npwp,
      'gaji': gaji,
      'foto_url': fotoUrl,
      'jabatan': jabatan,
      'alamat': alamat,
      'tanggal_bergabung': tanggalBergabung,
      'divisi': divisi,
      'role_id': roleId,
      'no_rekening': noRekening,
      'sisa_cuti': sisaCuti,
      'active': active,
      'errorMessage': errorMessage,
    };
  }

  factory KaryawanModel.initial() {
    return const KaryawanModel(
      id: 0,
      nama: "",
      email: "",
      npwp: "",
      gaji: 0,
      fotoUrl: "",
      jabatan: "",
      alamat: "",
      tanggalBergabung: "",
      divisi: 0,
      roleId: 0,
      noRekening: "",
      sisaCuti: 0,
      active: false,
    );
  }

  factory KaryawanModel.fromMap(Map<String, dynamic> map) {
    return KaryawanModel(
      id: map['id']?.toInt() ?? 0,
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      npwp: map['npwp'] ?? '',
      gaji: map['gaji']?.toInt() ?? 0,
      fotoUrl: map['foto_url'] ?? '',
      jabatan: map['jabatan'] ?? '',
      alamat: map['alamat'] ?? '',
      tanggalBergabung: map['tanggal_bergabung'] ?? '',
      divisi: map['divisi']?.toInt() ?? 0,
      roleId: map['role_id']?.toInt() ?? 0,
      noRekening: map['no_rekening'] ?? '',
      sisaCuti: map['sisa_cuti'] ?? '',
      active: map['active'] ?? '',
      errorMessage: map['errorMessage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KaryawanModel.fromJson(String source) =>
      KaryawanModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KaryawanModel(id: $id, nama: $nama, email: $email, npwp: $npwp, gaji: $gaji, fotoUrl: $fotoUrl, jabatan: $jabatan, alamat: $alamat, tanggalBergabung: $tanggalBergabung, divisi: $divisi, roleId: $roleId, noRekening: $noRekening, sisaCuti: $sisaCuti, active: $active)';
  }

  @override
  List<Object> get props {
    return [
      id,
      nama,
      email,
      npwp,
      gaji,
      fotoUrl,
      jabatan,
      alamat,
      tanggalBergabung,
      divisi,
      roleId,
      noRekening,
      sisaCuti,
      active,
      errorMessage
    ];
  }
}
