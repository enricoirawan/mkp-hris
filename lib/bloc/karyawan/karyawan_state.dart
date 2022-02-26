part of 'karyawan_cubit.dart';

abstract class KaryawanState extends Equatable {
  const KaryawanState();

  @override
  List<Object> get props => [];
}

class KaryawanInitial extends KaryawanState {}

class KaryawanLoading extends KaryawanState {}

class GetKaryawanByIdSuccess extends KaryawanState {
  final KaryawanModel karyawan;

  const GetKaryawanByIdSuccess({required this.karyawan});

  @override
  List<Object> get props => [karyawan];
}

class GetKaryawanByIdFailed extends KaryawanState {
  final ErrorModel error;

  const GetKaryawanByIdFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class UploadImageProfileSuccess extends KaryawanState {
  final String message;

  const UploadImageProfileSuccess({required this.message});

  @override
  List<Object> get props => [];
}

class UploadImageProfileFailed extends KaryawanState {
  final ErrorModel errorModel;

  const UploadImageProfileFailed({
    required this.errorModel,
  });

  @override
  List<Object> get props => [errorModel];
}
