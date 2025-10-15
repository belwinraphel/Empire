import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';

typedef ResultFuture<T> = Future<Either<Failures, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;