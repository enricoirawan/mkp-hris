import 'dart:typed_data';

import '../../model/model.dart';

abstract class BaseAuthRepository {
  Future<KaryawanModel> signinUser(String email, String password);
  Future<bool> signupUser(String email, String password);
  Future<KaryawanModel> recoverSession();
  Future<bool> signout();
  Future<bool> sendEmailForResetPassword(String email);
  Future<bool> uploadImageProfile(
    Uint8List bytes,
    String filePath,
    int karyawanId,
  );
}
