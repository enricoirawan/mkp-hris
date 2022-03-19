import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mkp_hris/model/cuti_model.dart';
import 'package:mkp_hris/repository/repository.dart';

part 'cuti_state.dart';

class CutiCubit extends Cubit<CutiState> {
  final KaryawanRepository _karyawanRepository;

  CutiCubit({required KaryawanRepository karyawanRepository})
      : _karyawanRepository = karyawanRepository,
        super(CutiInitial());

  void requestCuti(
    String jenisCuti,
    int karyawanId,
    String alasan,
    String startDate,
    String endDate,
    int durasiCuti,
    String createdAt,
  ) async {
    try {
      bool isRequestCutiSuccess = await _karyawanRepository.requestCuti(
        jenisCuti,
        karyawanId,
        alasan,
        startDate,
        endDate,
        durasiCuti,
        createdAt,
      );

      if (isRequestCutiSuccess) {
        emit(
          const RequestCutiSuccess(
            message:
                "Pengajuan cuti berhasil dan akan diteruskan ke pihak HR untuk di proses",
          ),
        );
      } else {
        emit(
          const RequestCutiFailed(
            errorMessage: "Pengajuan cuti gagal, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const RequestCutiFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void getRequestCutiOnProsesByKaryawanId(int karyawanId) async {
    try {
      emit(CutiLoading());

      List<CutiModel>? listCuti = await _karyawanRepository
          .getRequestCutiOnProsesByKaryawanId(karyawanId);

      if (listCuti != null) {
        emit(GetListCutiSuccess(listCuti: listCuti));
      } else {
        emit(
          const GetListCutiFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const GetListCutiFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }
}
