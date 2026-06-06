import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.message = '']);
  final String message;
  @override
  List<Object?> get props => [message];
}

class InvalidEquationFailure extends Failure {
  const InvalidEquationFailure([super.message = 'Invalid equation']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}
