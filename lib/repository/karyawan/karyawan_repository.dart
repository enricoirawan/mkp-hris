import 'dart:io';

import 'package:mkp_hris/model/cuti_model.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/utils/geolocator_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mkp_hris/repository/karyawan/base_karyawan_repository.dart';

import '../../utils/lib.dart';

class KaryawanRepository extends BaseKaryawanRepository {
  final SupabaseClient _supabaseClient;

  KaryawanRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  @override
  Future<List<KaryawanModel>?> getAllKaryawan() async {
    try {
      final response =
          await _supabaseClient.from("Karyawan").select().execute();

      if (response.error == null) {
        final List responseData = response.data as List;
        List<KaryawanModel> listKaryawan = [];

        for (var element in responseData) {
          listKaryawan.add(KaryawanModel.fromMap(element));
        }

        return listKaryawan;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> addKaryawan(KaryawanModel karyawan) async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .insert(karyawan.toMap())
          .execute();

      if (response.error == null) {
        return true;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> updateKaryawan(int karyawanId, KaryawanModel karyawan) async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .update(karyawan.toMap())
          .eq("id", karyawanId)
          .execute();

      if (response.error == null) {
        return true;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> deleteKaryawan(int karyawanId) async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .delete()
          .eq("id", karyawanId)
          .execute();

      if (response.error == null) {
        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<KaryawanModel?> getKaryawanByIdKaryawan(int idKaryawan) async {
    try {
      final response = await _supabaseClient
          .from('Karyawan')
          .select()
          .eq("id", idKaryawan)
          .execute();

      if (response.error == null) {
        List responseData = response.data as List;

        return KaryawanModel.fromMap(responseData.first);
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Map<String, dynamic>> getKaryawanByEmailForSetPasswordFirstTime(
    String email,
  ) async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .select("email")
          .eq("email", email)
          .eq("is_alredy_have_password", false)
          .execute();

      // print("response data => ${response.data}");
      // print("response error => ${response.error}");

      if (response.error == null) {
        final responseData = response.data as List;

        if (responseData.isNotEmpty) {
          return {
            "isEmailExist": true,
            "errorMessage": "",
          };
        } else {
          return {
            "isEmailExist": false,
            "errorMessage": "Email tidak ditemukan, silahkan hubungi pihak HR",
          };
        }
      } else {
        return {
          "isEmailExist": false,
          "errorMessage": "Terjadi kesalahan, silahkan coba lagi",
        };
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Map<String, dynamic>> getKaryawanByEmailForResetPassword(
      String email) async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .select("email")
          .eq("email", email)
          .eq("is_alredy_have_password", true)
          .execute();

      // print("response data => ${response.data}");
      // print("response error => ${response.error}");

      if (response.error == null) {
        final responseData = response.data as List;

        if (responseData.isNotEmpty) {
          return {
            "isEmailExist": true,
            "errorMessage": "",
          };
        } else {
          return {
            "isEmailExist": false,
            "errorMessage": "Email tidak ditemukan, silahkan hubungi pihak HR",
          };
        }
      } else {
        return {
          "isEmailExist": false,
          "errorMessage": "Terjadi kesalahan, silahkan coba lagi",
        };
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<String?> getPosition() async {
    try {
      Position position = await determinePosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark result = placemarks[0];
      String? street = result.street;
      String? administrativeArea = result.administrativeArea;
      String? subAdministrativeArea = result.subAdministrativeArea;

      return "$street, $subAdministrativeArea, $administrativeArea";
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List?> getTodayAbsensi(String date, int karyawanId) async {
    try {
      final PostgrestResponse response = await _supabaseClient
          .from("Absensi")
          .select()
          .eq("tanggal_absensi", date)
          .eq("id_karyawan", karyawanId)
          .execute();

      if (response.error == null) {
        final responseData = response.data as List;

        return responseData;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<AbsensiModel>?> getHistoryAbsensi(int karyawanId) async {
    try {
      final PostgrestResponse response = await _supabaseClient
          .from("Absensi")
          .select()
          .eq("id_karyawan", karyawanId)
          .execute();

      if (response.error == null) {
        final responseData = response.data as List;
        List<AbsensiModel> listAbsen = [];

        for (var element in responseData) {
          listAbsen.add(AbsensiModel.fromMap(element));
        }

        return listAbsen;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> checkIn(
    int karyawanid,
    String waktuCheckIn,
    String tanggalAbsensi,
  ) async {
    try {
      final String? lokasiCheckIn = await getPosition();

      if (lokasiCheckIn == null) {
        return false;
      }

      final PostgrestResponse response =
          await _supabaseClient.from("Absensi").insert({
        "id_karyawan": karyawanid,
        "waktu_check_in": waktuCheckIn,
        "lokasi_check_in": lokasiCheckIn,
        "tanggal_absensi": tanggalAbsensi,
      }).execute();

      if (response.error == null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isAlredyCheckIn", true);
        await prefs.setString("lastAbsenceDate", tanggalAbsensi);

        return true;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> checkOut(
    int karyawanId,
    String waktuCheckOut,
    String tanggalAbsensi,
  ) async {
    try {
      final String? lokasiCheckOut = await getPosition();

      if (lokasiCheckOut == null) {
        return false;
      }

      final PostgrestResponse response = await _supabaseClient
          .from("Absensi")
          .update({
            "waktu_check_out": waktuCheckOut,
            "lokasi_check_out": lokasiCheckOut,
          })
          .eq("id_karyawan", karyawanId)
          .eq("tanggal_absensi", tanggalAbsensi)
          .execute();

      if (response.error == null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isAlredyCheckIn", false);

        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List?> getAnnouncement() async {
    try {
      PostgrestResponse response =
          await _supabaseClient.from("Pengumuman").select().execute();

      if (response.error == null) {
        return response.data as List;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> createAnnouncement(
    String title,
    String description,
    String createdBy,
    String createdAt, {
    File? file,
    String filePath = "",
  }) async {
    try {
      String attachmentUrl = "";
      if (file != null) {
        //logic upload file
        final uploadResponse = await _supabaseClient.storage
            .from("pengumuman-file")
            .upload(filePath, file);

        if (uploadResponse.error == null) {
          final imageUrlResponse = _supabaseClient.storage
              .from('pengumuman-file')
              .getPublicUrl(filePath);

          attachmentUrl = imageUrlResponse.data!;
        } else {
          return false;
        }
      }

      //logic insert data to table
      PostgrestResponse response =
          await _supabaseClient.from("Pengumuman").insert({
        "title": title,
        "created_at": createdAt,
        "created_by": createdBy,
        "detail": description,
        "attachment_url": attachmentUrl
      }).execute();

      if (response.error == null) {
        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> addGaji(GajiModel gaji) async {
    try {
      PostgrestResponse response =
          await _supabaseClient.from("Gaji").insert(gaji.toMap()).execute();

      if (response.error == null) {
        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<GajiModel>?> getGajiByKaryawanId(int karyawanId) async {
    try {
      PostgrestResponse response = await _supabaseClient
          .from("Gaji")
          .select()
          .eq("karyawan_id", karyawanId)
          .execute();

      if (response.error == null) {
        List responseData = response.data as List;
        List<GajiModel> listGaji = [];

        for (var element in responseData) {
          listGaji.add(GajiModel.fromMap(element));
        }

        return listGaji;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> requestCuti(
    String jenisCuti,
    int karyawanId,
    String alasan,
    String startDate,
    String endDate,
    int durasiCuti,
    String createdAt,
  ) async {
    try {
      PostgrestResponse response = await _supabaseClient.from("Cuti").insert({
        "jenis_cuti": jenisCuti,
        "karyawan_id": karyawanId,
        "alasan": alasan,
        "start_date": startDate,
        "end_date": endDate,
        "durasi_cuti": durasiCuti,
        "created_at": createdAt,
      }).execute();

      if (response.error == null) {
        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<CutiModel>?> getRequestCutiOnProsesByKaryawanId(
    int karyawanId,
  ) async {
    try {
      PostgrestResponse response = await _supabaseClient
          .from("Cuti")
          .select()
          .eq("karyawan_id", karyawanId)
          .eq("status", "on proses")
          .execute();

      if (response.error == null) {
        List responseData = response.data as List;
        List<CutiModel> listCuti = [];

        for (var element in responseData) {
          listCuti.add(CutiModel.fromMap(element));
        }

        return listCuti;
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<CutiModel>?> getRequestCuti() async {
    try {
      PostgrestResponse response = await _supabaseClient
          .from("Cuti")
          .select('*, Karyawan!inner(nama)')
          .eq("status", "on proses")
          .execute();

      if (response.error == null) {
        List responseData = response.data as List;
        List<CutiModel> listCuti = [];

        for (var element in responseData) {
          listCuti.add(CutiModel.fromMap(element));
        }

        return listCuti;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> rejectRequestCuti(int id, String rejectedBy) async {
    try {
      PostgrestResponse response = await _supabaseClient
          .from("Cuti")
          .update({
            "rejected_by": rejectedBy,
            "status": "rejected",
          })
          .eq("id", id)
          .execute();

      if (response.error == null) {
        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> approveRequestCuti(
      int id, int karyawanId, String approvedBy) async {
    try {
      PostgrestResponse response = await _supabaseClient
          .from("Cuti")
          .update({
            "approved": true,
            "approved_by": approvedBy,
            "status": "approved",
          })
          .eq("id", id)
          .execute();

      PostgrestResponse getDurasiCutiResponse = await _supabaseClient
          .from("Cuti")
          .select("durasi_cuti")
          .eq("id", id)
          .execute();

      PostgrestResponse getJatahCutiResponse = await _supabaseClient
          .from("Karyawan")
          .select("jatah_cuti")
          .eq("id", karyawanId)
          .execute();

      if (response.error == null &&
          getDurasiCutiResponse.error == null &&
          getJatahCutiResponse.error == null) {
        int durasiCuti = getDurasiCutiResponse.data[0]["durasi_cuti"];
        int jatahCuti = getJatahCutiResponse.data[0]["jatah_cuti"];

        int sisaCuti = jatahCuti - durasiCuti;

        PostgrestResponse updateJatahCutiResponse = await _supabaseClient
            .from("Karyawan")
            .update({
              "jatah_cuti": sisaCuti < 0 ? 0 : sisaCuti,
            })
            .eq("id", karyawanId)
            .execute();

        if (updateJatahCutiResponse.error == null) {
          return true;
        }

        return false;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<CutiModel>?> getHistoryCutiByKaryawanId(int karyawanId) async {
    try {
      PostgrestResponse response = await _supabaseClient
          .from("Cuti")
          .select('*, Karyawan!inner(nama)')
          .eq("karyawan_id", karyawanId)
          .execute();

      if (response.error == null) {
        List responseData = response.data as List;
        List<CutiModel> listCuti = [];

        for (var element in responseData) {
          listCuti.add(CutiModel.fromMap(element));
        }

        return listCuti;
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
