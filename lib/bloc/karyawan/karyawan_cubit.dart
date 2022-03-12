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

  KaryawanCubit({
    required KaryawanRepository karyawanRepository,
    required AuthRepository authRepository,
  })  : _karyawanRepository = karyawanRepository,
        _authRepository = authRepository,
        super(KaryawanInitial());

  void getAllKaryawan() async {
    try {
      emit(KaryawanLoading());

      List<KaryawanModel>? listKaryawan =
          await _karyawanRepository.getAllKaryawan();

      if (listKaryawan != null) {
        emit(GetListKaryawanSuccess(listKaryawan: listKaryawan));
      } else {
        emit(
          const GetListKaryawanFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const GetListKaryawanFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

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

  void addKaryawan(KaryawanModel karyawan) async {
    try {
      bool isAddKaryawanSuccess =
          await _karyawanRepository.addKaryawan(karyawan);

      if (isAddKaryawanSuccess) {
        emit(
          const AddKaryawanSuccess(
            message: "Data karyawan berhasil disimpan",
          ),
        );
      } else {
        emit(
          const AddKaryawanFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const AddKaryawanFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void updateKaryawan(int karyawanId, KaryawanModel karyawan) async {
    try {
      bool isUpdateKaryawanSuccess =
          await _karyawanRepository.updateKaryawan(karyawanId, karyawan);

      if (isUpdateKaryawanSuccess) {
        emit(
          const UpdateKaryawanSuccess(
            message: "Data karyawan berhasil diubah",
          ),
        );
      } else {
        emit(
          const UpdateKaryawanFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const AddKaryawanFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void deleteKaryawan(int karyawanId) async {
    try {
      bool isDeleteKaryawanSuccess =
          await _karyawanRepository.deleteKaryawan(karyawanId);

      if (isDeleteKaryawanSuccess) {
        emit(
          const DeleteKaryawanSuccess(
            message: "Data karyawan berhasil dihapus",
          ),
        );
      } else {
        emit(
          const DeleteKaryawanFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const AddKaryawanFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
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
          emit(
            const UploadImageProfileFailed(
              errorModel: ErrorModel(
                errorMessage: "Upload foto gagal, silahkan coba lagi",
              ),
            ),
          );
        }
      } else {
        emit(
          const UploadImageProfileFailed(
            errorModel: ErrorModel(
              errorMessage: "Upload foto gagal, silahkan coba lagi",
            ),
          ),
        );
      }
    } catch (e) {
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
