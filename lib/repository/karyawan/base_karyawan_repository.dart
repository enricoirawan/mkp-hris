import 'dart:io';

import 'package:mkp_hris/model/cuti_model.dart';
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
  Future<bool> addGaji(GajiModel gaji);
  Future<List<GajiModel>?> getGajiByKaryawanId(int karyawanId);
  Future<bool> requestCuti(
    String jenisCuti,
    int karyawanId,
    String alasan,
    String startDate,
    String endDate,
    int durasiCuti,
    String createdAt,
  );
  Future<List<CutiModel>?> getRequestCutiOnProsesByKaryawanId(int karyawanId);
}
