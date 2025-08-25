import "package:flutter_secure_storage/flutter_secure_storage.dart";

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "jwt_token";

  //Save Token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  //Get Token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  //Remove Token
  static Future<void> logOut() async {
    await _storage.delete(key: _tokenKey);
  }
}
