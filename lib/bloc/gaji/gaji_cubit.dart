import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mkp_hris/model/model.dart';

import '../../repository/repository.dart';

part 'gaji_state.dart';

class GajiCubit extends Cubit<GajiState> {
  final KaryawanRepository _karyawanRepository;

  GajiCubit({required KaryawanRepository karyawanRepository})
      : _karyawanRepository = karyawanRepository,
        super(GajiInitial());

  void addGaji(GajiModel gaji) async {
    try {
      bool isAddGajiSuccess = await _karyawanRepository.addGaji(gaji);

      if (isAddGajiSuccess) {
        emit(const AddGajiSuccess(message: "Data berhasil disimpan"));
      } else {
        emit(
          const AddGajiFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const AddGajiFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void getGajiByKaryawanId(int karyawanId) async {
    try {
      emit(GajiLoading());

      final List<GajiModel>? listGaji =
          await _karyawanRepository.getGajiByKaryawanId(karyawanId);

      if (listGaji != null) {
        emit(GetGajiSuccess(listGaji: listGaji));
      } else {
        emit(
          const GetGajiFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const GetGajiFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }
}
