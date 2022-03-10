import 'package:flutter/cupertino.dart';

abstract class Result<T> {
  T? result;
  final String message;

  @mustCallSuper
  Result(this.result, this.message);
}

class IntermediateResult<T> extends Result<T> {
  IntermediateResult(result, message) : super(result, message);
}

class ErrorResult<T> extends Result<T> {
  ErrorResult(result, message) : super(result, message);
}

class FinalResult<T> extends Result<T> {
  FinalResult(result, message) : super(result, message);
}