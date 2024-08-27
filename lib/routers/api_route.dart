abstract class ApiRoute {
  static const devURL = '';
  static const prodURL = '';
  static const ngRok = '';

  static const baseURL = devURL;

  static const mainURL = '$baseURL/api/v1';

  bool get isDevEnv {
    if (ApiRoute.baseURL.contains(ApiRoute.devURL)) {
      return false;
    }
    return true;
  }
}
