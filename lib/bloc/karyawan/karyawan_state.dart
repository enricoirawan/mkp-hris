part of 'karyawan_cubit.dart';

abstract class KaryawanState extends Equatable {
  const KaryawanState();

  @override
  List<Object> get props => [];
}

class KaryawanInitial extends KaryawanState {}

class KaryawanLoading extends KaryawanState {}

class GetListKaryawanSuccess extends KaryawanState {
  final List<KaryawanModel> listKaryawan;

  const GetListKaryawanSuccess({required this.listKaryawan});

  @override
  List<Object> get props => [listKaryawan];
}

class GetListKaryawanFailed extends KaryawanState {
  final String errorMessage;

  const GetListKaryawanFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

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

class AddKaryawanSuccess extends KaryawanState {
  final String message;

  const AddKaryawanSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddKaryawanFailed extends KaryawanState {
  final String errorMessage;

  const AddKaryawanFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class UpdateKaryawanSuccess extends KaryawanState {
  final String message;

  const UpdateKaryawanSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class UpdateKaryawanFailed extends KaryawanState {
  final String errorMessage;

  const UpdateKaryawanFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class DeleteKaryawanSuccess extends KaryawanState {
  final String message;

  const DeleteKaryawanSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class DeleteKaryawanFailed extends KaryawanState {
  final String errorMessage;

  const DeleteKaryawanFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
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
