import 'dart:async';

import 'flutter_twitter_web_js.dart';

class TwitterLogin {
  TwitterLogin({
    this.consumerKey,
    this.consumerSecret,
  });

  final String consumerKey;
  final String consumerSecret;

  Future<TwitterLoginResult> authorize([String oauthToken]) async {
    final Map<dynamic, dynamic> result = await TwitterLoginWeb().getAuthToken(oauthToken);

    return new TwitterLoginResult._(result.cast<String, dynamic>());
  }

  Future<void> logOut() async => {};

  // static void registerWith(Registrar registrar) {
  //   TwitterLogin.instance = TwitterLogin();
  // }
}

class TwitterLoginResult {
  /// The status after a Twitter login flow has completed.
  ///
  /// This affects whether the [session] or [error] are available or not.
  /// If the user cancelled the login flow, both [session] and [errorMessage]
  /// are null.
  final TwitterLoginStatus status;

  /// Only available when the [status] equals [TwitterLoginStatus.loggedIn],
  /// otherwise null.
  final TwitterSession session;

  /// Only available when the [status] equals [TwitterLoginStatus.error]
  /// otherwise null.
  final String errorMessage;

  TwitterLoginResult._(Map<String, dynamic> map)
      : status = _parseStatus(map['status']),
        session = map['session'] != null
            ? new TwitterSession.fromMap(
                map['session'].cast<String, dynamic>(),
              )
            : null,
        errorMessage = map['errorMessage'];

  static TwitterLoginStatus _parseStatus(String status) {
    switch (status) {
      case 'loggedIn':
        return TwitterLoginStatus.loggedIn;
      case 'canceled':
        return TwitterLoginStatus.cancelledByUser;
      case 'error':
        return TwitterLoginStatus.error;
    }
    throw new StateError('Invalid status: $status');
  }
}

/// The status after a Twitter login flow has completed.
enum TwitterLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow, usually by backing out of the dialog.
  ///
  /// This might be unrealiable; see the [_parseStatus] method in TwitterLoginResult.
  cancelledByUser,

  /// The login flow completed, but for some reason resulted in an error. The
  /// user couldn't log in.
  error,
}

/// The information about a Twitter user session.
///
/// Includes the token and secret, along with the user's id and name. Both
/// the [token] and [secret] are needed for making authenticated Twitter API
/// calls.
class TwitterSession {
  final String secret;
  final String token;

  /// The user's unique identifier, usually a long series of numbers.
  final String userId;

  /// The user's Twitter handle.
  ///
  /// For example, if you can visit your Twitter profile by typing the URL
  /// http://twitter.com/hello, your Twitter handle (or username) is "hello".
  final String username;

  /// Constructs a new access token instance from a [Map].
  ///
  /// This is used mostly internally by this library.
  TwitterSession.fromMap(Map<String, dynamic> map)
      : secret = map['secret'],
        token = map['token'],
        userId = map['userId'],
        username = map['username'];

  /// Transforms this access token to a [Map].
  ///
  /// This could be useful for encoding this access token as JSON and then
  /// sending it to a server.
  Map<String, dynamic> toMap() {
    return {
      'secret': secret,
      'token': token,
      'userId': userId,
      'username': username,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwitterSession &&
          runtimeType == other.runtimeType &&
          secret == other.secret &&
          token == other.token &&
          userId == other.userId &&
          username == other.username;

  @override
  int get hashCode => secret.hashCode ^ token.hashCode ^ userId.hashCode ^ username.hashCode;
}
