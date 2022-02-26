part of 'absensi_cubit.dart';

abstract class AbsensiState extends Equatable {
  const AbsensiState();

  @override
  List<Object> get props => [];
}

class AbsensiInitial extends AbsensiState {}

class AbsensiLoading extends AbsensiState {}

class GetTodayAbsenSuccess extends AbsensiState {
  final AbsensiModel absensi;

  const GetTodayAbsenSuccess({required this.absensi});

  @override
  List<Object> get props => [absensi];
}

class GetTodayAbsenNull extends AbsensiState {
  const GetTodayAbsenNull();

  @override
  List<Object> get props => [];
}

class GetTodayAbsenFailed extends AbsensiState {
  final String errorMessage;

  const GetTodayAbsenFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CheckInSuccess extends AbsensiState {
  final String message;

  const CheckInSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class CheckInFailed extends AbsensiState {
  final String errorMessage;

  const CheckInFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CheckOutSuccess extends AbsensiState {
  final String message;

  const CheckOutSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class CheckOutFailed extends AbsensiState {
  final String errorMessage;

  const CheckOutFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
