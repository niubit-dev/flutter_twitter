@JS('window')
library twitter_login;

import 'package:js/js.dart';

@JS()
class TwitterLoginWeb {
  external factory TwitterLoginWeb();

  external getAuthToken(String oauthToken);
}

@JS()
@anonymous
class TwitterLoginResultWeb {
  external String get status;

  external String get errorMessage;

  external TwitterSessionWeb get session;

  external factory TwitterLoginResultWeb({
    String status,
    String errorMessage,
    TwitterSessionWeb session,
  });
}

@JS()
@anonymous
class TwitterSessionWeb {
  external String get secret;

  external String get token;

  external factory TwitterSessionWeb({String secret, String token});
}
