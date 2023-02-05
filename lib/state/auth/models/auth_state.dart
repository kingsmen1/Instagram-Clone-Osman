import 'package:instagram_clone/state/auth/models/auth_result.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  //~constructor methods.
  //unknown means loggedOut
  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
      );

  //~equality
  @override //covariant enforses that incomming model should be of this type if not it throws and Exception.
  bool operator ==(covariant AuthState other) =>
      //"identical"Check whether two references are to the same object.
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(
        result,
        isLoading,
        userId,
      );
}
