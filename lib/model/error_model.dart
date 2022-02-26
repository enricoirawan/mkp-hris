import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final String errorMessage;

  const ErrorModel({
    this.errorMessage = "",
  });

  @override
  List<Object?> get props => [errorMessage];
}
