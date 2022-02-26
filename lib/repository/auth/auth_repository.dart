import 'dart:typed_data';

import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/repository/auth/base_auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/lib.dart';

class AuthRepository extends BaseAuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  @override
  Future<KaryawanModel> signinUser(
    String email,
    String password,
  ) async {
    try {
      final user =
          await _supabaseClient.auth.signIn(email: email, password: password);

      if (user.error != null) {
        if (user.error!.message == "Invalid login credentials") {
          return KaryawanModel.initial().copyWith(
            errorMessage:
                "Kredensial login tidak ditemukan atau belum terdaftar",
          );
        }
      }

      //check email karyawan yang login di tabel karaywan
      final PostgrestResponse<dynamic> response = await _supabaseClient
          .from("Karyawan")
          .select()
          .eq("email", user.user!.email)
          .execute();

      final List<dynamic> responseList = response.data as List;

      if (responseList.isNotEmpty) {
        //set user token to local storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userToken", user.data!.persistSessionString);

        return KaryawanModel.fromMap(responseList.first);
      } else {
        // * return nya bisa diganti null (opsional)
        return KaryawanModel.initial().copyWith(
          errorMessage: "Email tidak ditemukan, silahkan coba lagi",
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> signupUser(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signUp(email, password);

      if (response.error == null) {
        await _supabaseClient
            .from("Karyawan")
            .update({'is_alredy_have_password': true})
            .eq("email", email)
            .execute();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> signout() async {
    try {
      //remove user token to local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("userToken");
      prefs.remove("karyawanId");

      //execute supabase signout
      final response = await _supabaseClient.auth.signOut();
      if (response.error == null) {
        return true;
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<KaryawanModel> recoverSession() async {
    try {
      //remove user token to local storage
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey("userToken")) {
        final userToken = prefs.getString("userToken");
        final user = await _supabaseClient.auth.recoverSession(userToken!);

        if (user.error == null) {
          prefs.setString("userToken", user.data!.persistSessionString);

          //check email karyawan yang login di tabel karaywan
          final PostgrestResponse<dynamic> response = await _supabaseClient
              .from("Karyawan")
              .select()
              .eq("email", user.user!.email)
              .execute();

          final List<dynamic> responseList = response.data as List;

          if (responseList.isNotEmpty) {
            //set user token to local storage
            final prefs = await SharedPreferences.getInstance();
            prefs.setString("userToken", user.data!.persistSessionString);

            return KaryawanModel.fromMap(responseList.first);
          }
        }
      }

      // * return nya bisa diganti null (opsional)
      return KaryawanModel.initial().copyWith(errorMessage: "Sesi habis");
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> sendEmailForResetPassword(String email) async {
    try {
      final response = await _supabaseClient.auth.api.resetPasswordForEmail(
        email,
      );

      if (response.error == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> uploadImageProfile(
      Uint8List bytes, String filePath, int karyawanId) async {
    try {
      final uploadResponse = await _supabaseClient.storage
          .from("karyawan-photo")
          .uploadBinary(filePath, bytes);

      if (uploadResponse.error == null) {
        final imageUrlResponse = _supabaseClient.storage
            .from('karyawan-photo')
            .getPublicUrl(filePath);

        if (imageUrlResponse.error == null) {
          //update foto_url di tabel Karaywan
          final updateResponse = await _supabaseClient
              .from("Karyawan")
              .update({"foto_url": uploadResponse.data})
              .eq("id", karyawanId)
              .execute();

          if (updateResponse.error == null) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      throw e.toString();
    }
  }
}
