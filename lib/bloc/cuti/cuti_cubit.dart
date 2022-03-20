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

  void getRequestCuti() async {
    try {
      emit(CutiLoading());

      List<CutiModel>? listCuti = await _karyawanRepository.getRequestCuti();

      if (listCuti != null) {
        emit(GetListCutiSuccess(listCuti: listCuti));
      } else {
        emit(
          const GetListCutiFailed(
            errorMessage:
                "Gagal mengambil data permintaan cuti, silahkan coba lagi",
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

  void rejectRequestCuti(int id, String rejectedBy) async {
    try {
      emit(CutiLoading());

      bool isRejectRequestCutiSuccess =
          await _karyawanRepository.rejectRequestCuti(id, rejectedBy);

      if (isRejectRequestCutiSuccess) {
        emit(
          const RejectRequestCutiSuccess(
            message: "Penolakan permintaan cuti telah berhasil",
          ),
        );
      } else {
        emit(
          const RejectRequestCutiFailed(
            errorMessage: "Penolakan permintaan cuti gagal, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const RejectRequestCutiFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void approveRequestCuti(int id, int karyawanId, String approvedBy) async {
    try {
      emit(CutiLoading());

      bool isApproveRequestCutiSuccess = await _karyawanRepository
          .approveRequestCuti(id, karyawanId, approvedBy);

      if (isApproveRequestCutiSuccess) {
        emit(
          const ApproveRequestCutiSuccess(
            message: "Approval permintaan cuti telah berhasil",
          ),
        );
      } else {
        emit(
          const ApproveRequestCutiFailed(
            errorMessage: "Approval permintaan cuti gagal, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const ApproveRequestCutiFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void getHistoryCutiByKaryawanId(int karyawanId) async {
    try {
      emit(CutiLoading());

      List<CutiModel>? listCuti =
          await _karyawanRepository.getHistoryCutiByKaryawanId(karyawanId);

      if (listCuti != null) {
        emit(GetListCutiSuccess(listCuti: listCuti));
      } else {
        emit(
          const GetListCutiFailed(
            errorMessage:
                "Gagal mengambil data riwayat cuti, silahkan coba lagi",
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
