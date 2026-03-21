import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // En emulador Android
  static const String baseUrl = 'http://localhost:3000/api_v1';

  //static const String baseUrl = 'http://10.0.2.2:3000/api_v1';
  // En dispositivo físico cambia por tu IP local: http://192.168.x.x:3000/api_v1

  static Future<Map<String, dynamic>> registrarUsuario({
    required String user,
    required String password,
    required String status,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/apiUser');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': user,
          'password': password,
          'status': status,
          'role': role,
        }),
      );

      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> loginUsuario({
    required String user,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/apiUserLogin');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'api_user': user, 'api_password': password}),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> actualizarStatus({
    required int userId,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl/apiUser/$userId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> crearUserStatus({
    required String nombre,
    required String descripcion,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/userStatus');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'User_status_name': nombre,
          'User_status_description': descripcion,
        }),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  // ── NUEVO ──────────────────────────────────────────────────────────────────

  /// POST /apiUserLogin
  /// Inicia sesión y retorna el token JWT.
  /// Usa los mismos campos que el backend: api_user, api_password.
  static Future<Map<String, dynamic>> loginApiUser({
    required String user,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/apiUserLogin');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_user': user,
          'api_password': password,
        }),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  /// POST /userStatus  (protegida con verifyToken)
  /// Crea un nuevo user status enviando name y description.
  static Future<Map<String, dynamic>> addUserStatus({
    required String name,
    required String description,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/userStatus');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
        }),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  // ── FIN NUEVO ──────────────────────────────────────────────────────────────
}

/*import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // En emulador Android
  static const String baseUrl = 'http://localhost:3000/api_v1';

  //static const String baseUrl = 'http://10.0.2.2:3000/api_v1';
  // En dispositivo físico cambia por tu IP local: http://192.168.x.x:3000/api_v1

  static Future<Map<String, dynamic>> registrarUsuario({
    required String user,
    required String password,
    required String status,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/apiUser');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': user,
          'password': password,
          'status': status,
          'role': role,
        }),
      );

      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> loginUsuario({
    required String user,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/apiUserLogin');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'api_user': user, 'api_password': password}),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> actualizarStatus({
    required int userId,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl/apiUser/$userId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }

  static Future<Map<String, dynamic>> crearUserStatus({
    required String nombre,
    required String descripcion,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/userStatus');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'User_status_name': nombre,
          'User_status_description': descripcion,
           }),
      );
      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Error de conexión: $e'},
      };
    }
  }
}*/
