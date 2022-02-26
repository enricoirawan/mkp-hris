import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mkp_hris/model/error_model.dart';
import 'package:mkp_hris/model/karyawan_model.dart';
import 'package:mkp_hris/repository/repository.dart';

part 'karyawan_state.dart';

class KaryawanCubit extends Cubit<KaryawanState> {
  final KaryawanRepository _karyawanRepository;
  final AuthRepository _authRepository;

  KaryawanCubit(
      {required KaryawanRepository karyawanRepository,
      required AuthRepository authRepository})
      : _karyawanRepository = karyawanRepository,
        _authRepository = authRepository,
        super(KaryawanInitial());

  void getKaryawanById(int idKaryawan) async {
    try {
      emit(KaryawanLoading());

      final KaryawanModel? response =
          await _karyawanRepository.getKaryawanByIdKaryawan(idKaryawan);

      if (response != null) {
        emit(GetKaryawanByIdSuccess(karyawan: response));
      } else {
        emit(
          const GetKaryawanByIdFailed(
            error: ErrorModel(
              errorMessage: "Terjadi kesalahan, silahkan coba lagi",
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        const GetKaryawanByIdFailed(
          error: ErrorModel(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        ),
      );
    }
  }

  void uploadImageProfile(
    Uint8List bytes,
    String filePath,
    int idKaryawan,
  ) async {
    try {
      emit(KaryawanLoading());

      //upload image
      final bool uploadImageResponse =
          await _authRepository.uploadImageProfile(bytes, filePath, idKaryawan);

      if (uploadImageResponse) {
        //update data foto_url pada tabel karyawan
        final updateUserDataResponse =
            await _karyawanRepository.getKaryawanByIdKaryawan(idKaryawan);

        if (updateUserDataResponse != null) {
          //emit state uplaod foto berhasil
          emit(
            const UploadImageProfileSuccess(
              message: "Upload foto berhasil",
            ),
          );
        } else {
          print("Update gagal");
          emit(
            const UploadImageProfileFailed(
              errorModel: ErrorModel(
                errorMessage: "Upload foto gagal, silahkan coba lagi",
              ),
            ),
          );
        }
      } else {
        print("Upload gagal");
        emit(
          const UploadImageProfileFailed(
            errorModel: ErrorModel(
              errorMessage: "Upload foto gagal, silahkan coba lagi",
            ),
          ),
        );
      }
    } catch (e) {
      print("Masuk catch ${e.toString()}");
      emit(
        const UploadImageProfileFailed(
          errorModel: ErrorModel(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        ),
      );
    }
  }
}
