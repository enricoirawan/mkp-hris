import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mkp_hris/model/model.dart';
import 'package:mkp_hris/repository/repository.dart';

part 'pengumuman_state.dart';

class PengumumanCubit extends Cubit<PengumumanState> {
  final KaryawanRepository _karyawanRepository;

  PengumumanCubit({required KaryawanRepository karyawanRepository})
      : _karyawanRepository = karyawanRepository,
        super(PengumumanInitial());

  void getAnnouncement() async {
    try {
      List? pengumumanList = await _karyawanRepository.getAnnouncement();

      if (pengumumanList != null) {
        List<PengumumanModel> pengumumanData = [];

        pengumumanList.forEach((pengumumanItem) {
          pengumumanData.add(PengumumanModel.fromMap(pengumumanItem));
        });

        emit(GetPengumumanSuccess(listPengumuman: pengumumanData));
      } else {
        emit(
          const GetPengumumanFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const GetPengumumanFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }

  void createAnnoucement(
    String title,
    String description,
    String createdBy,
    String createdAt, {
    File? file,
    String filePath = "",
  }) async {
    try {
      final isSuccessCreated = await _karyawanRepository.createAnnouncement(
        title,
        description,
        createdBy,
        createdAt,
        file: file,
        filePath: filePath,
      );

      if (isSuccessCreated) {
        emit(
          const InsertPengumumanSuccess(
            message: "Pengumuman berhasil dibuat",
          ),
        );
      } else {
        emit(
          const InsertPengumumanFailed(
            errorMessage: "Terjadi kesalahan, silahkan coba lagi",
          ),
        );
      }
    } catch (e) {
      emit(
        const InsertPengumumanFailed(
          errorMessage: "Terjadi kesalahan, silahkan coba lagi",
        ),
      );
    }
  }
}
