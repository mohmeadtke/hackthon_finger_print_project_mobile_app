import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hackthon_app/Features/fingerPreant/data/modile/user_moidel.dart';
import 'package:hackthon_app/core/failure/failure.dart';
import 'package:http/http.dart' as http;

class CheckTheTokenDataSource {
  static const String baseUrl = 'http://10.21.54.187';

  Future<Either<Failure, UserMoidel>> getMe(String token) async {
    try {
      final url = Uri.parse('$baseUrl/auth/me');

      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);

        final data = json.decode(response.body);
        return Right(UserMoidel.fromJson(data));
      } else {
        return Left(
          Failure(message: "Failed to get user info: ${response.statusCode}"),
        );
      }
    } catch (e) {
      return Left(Failure(message: "Error getting user info: $e"));
    }
  }
}
