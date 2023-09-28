import 'package:ui_one/features/auth/presentation/validator/auth_validator.dart';
import '../../../../service/auth_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repasitory/auth_repository.dart';

class AuthController {
  final AuthService _authService = AuthService(); // Instancia de AuthService
  final SignUpService _signService = SignUpService();

  AuthController._();
  static final AuthController _instance = AuthController._();
  factory AuthController(AuthRepository repository) {
    authRepository = repository;
    return _instance;
  }

  static late final AuthRepository authRepository;

  Future<Map<String, String>> registration(
    String name,
    String email,
    String password,
  ) async  {
    Map<String, String> result = {};

    if (AuthValidator.isNameValid(name) != null) {
      result["message"] = "Wrong Name";
      result["next"] = "not";
      return result;
    }

    if (AuthValidator.isEmailValid(email) != null) {
      result["message"] = "Wrong Email";
      result["next"] = "not";
      return result;
    }

    if (AuthValidator.isPasswordValid(password) != null) {
      result["message"] = "Wrong Password";
      result["next"] = "not";
      return result;
    }

    final user = User("20", name, email, password);
    try {
    final Map<String, Object> response = await _signService.createUser(user.name, user.password, user.email);
    result["message"] = response["message"] as String;
    result["next"] = (response["success"] as bool) ? "next" : "not";
  } catch (e) {
    result["message"] = "Failed to create user: ${e.toString()}";
    result["next"] = "not";
  }
  return result;
  }

  Future<Map<String, String>> login(
    String email,
    String password,
  ) async {
    // Hazlo async
    Map<String, String> result = {};

    if (AuthValidator.isEmailValid(email) != null) {
      result["message"] = "Wrong Email";
      result["next"] = "not";
      return result;
    }

    if (AuthValidator.isPasswordValid(password) != null) {
      result["message"] = "Wrong Password !!";
      result["next"] = "not";
      return result;
    }

    // Usar AuthService para autenticar al usuario
    String? token = await _authService.login(email, password);
    if (token == null) {
      result["message"] = "Authentication failed";
      result["next"] = "not";
    } else {
      result["message"] = "Login successful";
      result["next"] = "next";
    }
    return result;
  }

  Map<String, Object> deleteAccount(String email) {
    return authRepository.deleteAccount(email);
  }

  Map<String, Map<String, Object?>> viewAllData() {
    return authRepository.viewAllData();
  }
}
