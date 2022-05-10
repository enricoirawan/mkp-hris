import 'package:equatable/equatable.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/repository/repository.dart';
import 'package:mkp_hris/utils/lib.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with HydratedMixin {
  final AuthRepository _authRepository;
  final KaryawanRepository _karyawanRepository;

  AuthCubit({
    required AuthRepository authRepository,
    required KaryawanRepository karyawanRepository,
  })  : _authRepository = authRepository,
        _karyawanRepository = karyawanRepository,
        super(AuthInitial()) {
    hydrate();
  }

  void signinUser(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await _authRepository.signinUser(email, password);

      if (user.errorMessage.isNotEmpty) {
        emit(
          AuthFailed(
            errorModel: ErrorModel(
              errorMessage: user.errorMessage,
            ),
          ),
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("karyawanId", user.id);

        emit(AuthSuccess(karyawan: user));
      }
    } catch (e) {
      // print(e.toString());
      emit(
        const AuthFailed(
          errorModel: ErrorModel(
            errorMessage: "Terjadi Kesalahan, silahkan coba kembali",
          ),
        ),
      );
    }
  }

  void signupUser(String email, String password) async {
    try {
      bool response = await _authRepository.signupUser(email, password);

      if (response) {
        emit(SignupSuccess());
      } else {
        emit(
          const SignupFailed(
            errorModel: ErrorModel(
              errorMessage: "Daftar gagal, silahkan coba kembali",
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        const SignupFailed(
          errorModel: ErrorModel(
            errorMessage: "Terjadi kesalahan, silahkan coba kembali",
          ),
        ),
      );
    }
  }

  void signoutUser() async {
    try {
      emit(AuthLoading());
      final bool response = await _authRepository.signout();

      if (response) {
        emit(SignoutSuccess());
      } else {
        emit(
          const SignoutFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const SignoutFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void recoverSession() async {
    try {
      final KaryawanModel response = await _authRepository.recoverSession();

      if (response.errorMessage.isEmpty) {
        emit(AuthSuccess(karyawan: response));
      } else {
        emit(const AuthFailed(errorModel: ErrorModel(errorMessage: "")));
      }
    } catch (e) {
      emit(const AuthFailed(errorModel: ErrorModel(errorMessage: "")));
    }
  }

  void emailValidation(String email) async {
    try {
      Map<String, dynamic> response = await _karyawanRepository
          .getKaryawanByEmailForSetPasswordFirstTime(email);
      // print("email validation response => $response");
      if (response["isEmailExist"]) {
        emit(EmailValidationSuccess(email: email));
      } else {
        String errorMessage = response["errorMessage"];
        emit(
          EmailValidationFailed(
            errorModel: ErrorModel(
              errorMessage: errorMessage,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        const EmailValidationFailed(
          errorModel: ErrorModel(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        ),
      );
    }
  }

  void emailValidationForResetPassword(String email) async {
    try {
      emit(AuthLoading());

      Map<String, dynamic> response =
          await _karyawanRepository.getKaryawanByEmailForResetPassword(email);
      // print("emailValidationForResetPassword response => $response");
      if (response["isEmailExist"]) {
        final bool resetPassword =
            await _authRepository.sendEmailForResetPassword(email);

        if (resetPassword == false) {
          emit(
            const EmailValidationForResetPasswordFailed(
              errorModel: ErrorModel(
                errorMessage: "Terjadi kesalahan, silahkan coba lagi",
              ),
            ),
          );
        } else {
          emit(
            const EmailValidationForResetPasswordSuccess(
              message:
                  "Email reset password sudah dikirim, silahkan cek email anda",
            ),
          );
        }
      } else {
        String errorMessage = response["errorMessage"];
        emit(
          EmailValidationForResetPasswordFailed(
            errorModel: ErrorModel(
              errorMessage: errorMessage,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        const EmailValidationForResetPasswordFailed(
          errorModel: ErrorModel(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        ),
      );
    }
  }

  void updateAuthSuccessState(KaryawanModel karyawan) async {
    emit(AuthSuccess(karyawan: karyawan));
  }

  void resetState() async {
    emit(AuthInitial());
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final KaryawanModel karyawan = KaryawanModel.fromMap(json);
      return AuthSuccess(karyawan: karyawan);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthSuccess) {
      return state.karyawan.toMap();
    } else {
      return null;
    }
  }
}
