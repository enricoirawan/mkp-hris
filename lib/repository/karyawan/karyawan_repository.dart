import 'dart:io';

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
  Future<void> getAllKaryawan() async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .select()
          // .neq("role_id", 1)
          .execute();

      print(response.data);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> insertKaryawan() async {
    try {
      final response =
          await _supabaseClient.from("Karyawan").insert({}).execute();

      print(response.data);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateKaryawan(int karyawanId, KaryawanModel karyawan) async {
    try {
      final response = await _supabaseClient
          .from("Karyawan")
          .update({})
          .eq("", "")
          .execute();

      print(response.data);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteKaryawan(int karyawanId) async {
    final response =
        await _supabaseClient.from("Karyawan").delete().eq("", "").execute();

    print(response.data);
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
}
