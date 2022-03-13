part of 'gaji_cubit.dart';

abstract class GajiState extends Equatable {
  const GajiState();

  @override
  List<Object> get props => [];
}

class GajiInitial extends GajiState {}

class GajiLoading extends GajiState {}

class AddGajiSuccess extends GajiState {
  final String message;

  const AddGajiSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddGajiFailed extends GajiState {
  final String errorMessage;

  const AddGajiFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetGajiSuccess extends GajiState {
  final List<GajiModel> listGaji;

  const GetGajiSuccess({required this.listGaji});

  @override
  List<Object> get props => [listGaji];
}

class GetGajiFailed extends GajiState {
  final String errorMessage;

  const GetGajiFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
