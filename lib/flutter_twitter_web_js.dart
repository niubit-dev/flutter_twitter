@JS()
library twitter_login;

import 'package:js/js.dart';


@JS()
class TwitterLoginWeb {
  external factory TwitterLoginWeb();
  external getAuthToken(String oauthToken);
}
