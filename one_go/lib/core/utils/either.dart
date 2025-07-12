/// Represents a value of one of two possible types (a disjoint union).
/// An instance of [Either] is an instance of either [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
abstract class Either<L, R> {
  const Either();

  /// Returns `true` if the either is a [Left], `false` otherwise.
  bool get isLeft => this is Left<L, R>;

  /// Returns `true` if the either is a [Right], `false` otherwise.
  bool get isRight => this is Right<L, R>;

  /// Transforms a [Right] value.
  /// If the either is a [Left], returns the [Left] unchanged.
  Either<L, R2> map<R2>(R2 Function(R) f) {
    if (this is Right<L, R>) {
      return Right(f((this as Right<L, R>).value));
    }
    return Left((this as Left<L, R>).value);
  }

  /// Transforms a [Left] value.
  /// If the either is a [Right], returns the [Right] unchanged.
  Either<L2, R> mapLeft<L2>(L2 Function(L) f) {
    if (this is Left<L, R>) {
      return Left(f((this as Left<L, R>).value));
    }
    return Right((this as Right<L, R>).value);
  }

  /// Applies the function [f] to the value if it's a [Right],
  /// otherwise returns the [Left] unchanged.
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) f) {
    if (this is Right<L, R>) {
      return f((this as Right<L, R>).value);
    }
    return Left((this as Left<L, R>).value);
  }

  /// Returns the value if it's a [Right], otherwise returns [orElse].
  R getOrElse(R orElse) {
    if (this is Right<L, R>) {
      return (this as Right<L, R>).value;
    }
    return orElse;
  }

  /// Folds this either into a single value.
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight) {
    if (this is Left<L, R>) {
      return ifLeft((this as Left<L, R>).value);
    }
    return ifRight((this as Right<L, R>).value);
  }
}

/// The left side of the disjoint union, as opposed to the [Right] side.
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Left && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// The right side of the disjoint union, as opposed to the [Left] side.
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Right &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
