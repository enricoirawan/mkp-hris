part of 'cuti_cubit.dart';

abstract class CutiState extends Equatable {
  const CutiState();

  @override
  List<Object> get props => [];
}

class CutiInitial extends CutiState {}

class CutiLoading extends CutiState {}

class RequestCutiSuccess extends CutiState {
  final String message;

  const RequestCutiSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class RequestCutiFailed extends CutiState {
  final String errorMessage;

  const RequestCutiFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetListCutiSuccess extends CutiState {
  final List<CutiModel> listCuti;

  const GetListCutiSuccess({required this.listCuti});

  @override
  List<Object> get props => [listCuti];
}

class GetListCutiFailed extends CutiState {
  final String errorMessage;

  const GetListCutiFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RejectRequestCutiSuccess extends CutiState {
  final String message;

  const RejectRequestCutiSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class RejectRequestCutiFailed extends CutiState {
  final String errorMessage;

  const RejectRequestCutiFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ApproveRequestCutiSuccess extends CutiState {
  final String message;

  const ApproveRequestCutiSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ApproveRequestCutiFailed extends CutiState {
  final String errorMessage;

  const ApproveRequestCutiFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
