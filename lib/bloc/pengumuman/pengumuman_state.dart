part of 'pengumuman_cubit.dart';

abstract class PengumumanState extends Equatable {
  const PengumumanState();

  @override
  List<Object> get props => [];
}

class PengumumanInitial extends PengumumanState {}

class PengumumanLoading extends PengumumanState {}

class GetPengumumanSuccess extends PengumumanState {
  final List<PengumumanModel> listPengumuman;

  const GetPengumumanSuccess({required this.listPengumuman});

  @override
  List<Object> get props => [listPengumuman];
}

class GetPengumumanFailed extends PengumumanState {
  final String errorMessage;

  const GetPengumumanFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class InsertPengumumanSuccess extends PengumumanState {
  final String message;

  const InsertPengumumanSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class InsertPengumumanFailed extends PengumumanState {
  final String errorMessage;

  const InsertPengumumanFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
