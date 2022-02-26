import 'package:mkp_hris/model/model.dart';

abstract class BaseKaryawanRepository {
  Future<void> insertKaryawan();
  Future<void> updateKaryawan(int karyawanId, KaryawanModel karyawan);
  Future<void> deleteKaryawan(int karyawanId);
  Future<void> getAllKaryawan();
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
}
