
import '../data/model/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String APP_NAME = 'Base';
  static const String APP_VERSION = "1.0.0";

  static const String BASE_URL = 'http://android-tracking.oceantech.com.vn';
  static const String CONFIG_URI = '/mita/public/config-app';
  static const String LOGIN_URI = '/mita/oauth/token';
  static const String SIGN_UP = '/mita/public/sign';
  static const String LOG_OUT = '/mita/oauth/logout';
  static const String GET_USER = '/mita/users/get-user-current';
  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String USER_COUNTRY_CODE = 'user_country_code';
  static const String NOTIFICATION = 'notification';
  static const String NOTIFICATION_COUNT = 'notification_count';

  static const String MODULE_ID = 'moduleId';
  static const String LOCALIZATION_KEY = 'X-localization';


  // Shared Key


  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.vietnam,
        languageName: 'Việt Nam',
        countryCode: 'VN',
        languageCode: 'vi'),
    LanguageModel(
        imageUrl: Images.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
  ];
}
