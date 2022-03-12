import 'dart:io';

import 'package:mkp_hris/model/model.dart';

abstract class BaseKaryawanRepository {
  Future<bool> addKaryawan(KaryawanModel karyawan);
  Future<bool> updateKaryawan(int karyawanId, KaryawanModel karyawan);
  Future<bool> deleteKaryawan(int karyawanId);
  Future<List<KaryawanModel>?> getAllKaryawan();
  Future<KaryawanModel?> getKaryawanByIdKaryawan(int idKaryawan);
  Future<Map<String, dynamic>> getKaryawanByEmailForSetPasswordFirstTime(
    String email,
  );
  Future<Map<String, dynamic>> getKaryawanByEmailForResetPassword(String email);
  Future<String?> getPosition();
  Future<List?> getTodayAbsensi(String date, int karyawanId);
  Future<bool> checkIn(
    int karyawanid,
    String waktuCheckIn,
    String tanggalAbsensi,
  );
  Future<bool> checkOut(
    int karyawanId,
    String waktuCheckOut,
    String tanggalAbsensi,
  );
  Future<List?> getAnnouncement();
  Future<bool> createAnnouncement(
    String title,
    String description,
    String createdBy,
    String createdAt, {
    File file,
    String filePath,
  });
}
