import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/repository/karyawan/karyawan_repository.dart';

part 'absensi_state.dart';

class AbsensiCubit extends Cubit<AbsensiState> {
  final KaryawanRepository _karyawanRepository;

  AbsensiCubit({
    required KaryawanRepository karyawanRepository,
  })  : _karyawanRepository = karyawanRepository,
        super(AbsensiInitial());

  void getTodayAbsensi(String date, int karyawanId) async {
    try {
      emit(AbsensiLoading());

      final List? absensi =
          await _karyawanRepository.getTodayAbsensi(date, karyawanId);

      if (absensi != null) {
        if (absensi.isEmpty) {
          emit(const GetTodayAbsenNull());
        } else {
          AbsensiModel absensiModel = AbsensiModel.fromMap(absensi.first);

          emit(GetTodayAbsenSuccess(absensi: absensiModel));
        }
      } else {
        emit(
          const GetTodayAbsenFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba ulang kembali",
          ),
        );
      }
    } catch (e) {
      emit(
        const GetTodayAbsenFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba ulang kembali",
        ),
      );
    }
  }

  void checkIn(
    int karyawanid,
    String waktuCheckIn,
    String tanggalAbsensi,
  ) async {
    try {
      emit(AbsensiLoading());

      bool checkInSuccess = await _karyawanRepository.checkIn(
        karyawanid,
        waktuCheckIn,
        tanggalAbsensi,
      );

      if (checkInSuccess) {
        emit(
          const CheckInSuccess(
            message: "Check In berhasil, jangan lupa check out nanti ya~",
          ),
        );
      } else {
        emit(
          const CheckInSuccess(
            message: "Terjadi kesalahan, silahkan coba ulang kembali",
          ),
        );
      }
    } catch (e) {
      emit(
        const CheckInSuccess(
          message: "Terjadi kesalahan, silahkan coba ulang kembali",
        ),
      );
    }
  }

  void checkOut(
    int karyawanId,
    String waktuCheckOut,
    String tanggalAbsensi,
  ) async {
    try {
      emit(AbsensiLoading());

      bool isCheckOutSuccess = await _karyawanRepository.checkOut(
        karyawanId,
        waktuCheckOut,
        tanggalAbsensi,
      );

      if (isCheckOutSuccess) {
        emit(
          const CheckOutSuccess(
            message: "Check out berhasil, selamat beristirahat sobat~",
          ),
        );
      } else {
        emit(
          const CheckOutFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba ulang kembali",
          ),
        );
      }
    } catch (e) {
      emit(
        const CheckOutFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba ulang kembali",
        ),
      );
    }
  }
}
