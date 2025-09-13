// import 'package:hackthon_app/core/failure/failure.dart';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:hackthon_app/Features/fingerPreant/domain/entity/finger_print_entity.dart';
import 'package:hackthon_app/core/storage/local_storage.dart';

import '../../../../core/failure/failure.dart';

class FingerDataSource {
  final LocalStorageImpl _localStorage = LocalStorageImpl();

  Future<Either<Failure, String>> sendFingerprint(
    FingerPrintEntity fingerPrintEntity,
  ) async {
    // Example API endpoint - replace with your actual API
    const String apiUrl =
        'http://10.21.54.187/auth/register-new-user'; // Using httpbin for testing multipart

    // Create multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.fields['name'] = fingerPrintEntity.name;
    request.fields['email'] = fingerPrintEntity.email;

    // Add the image file
    request.files.add(
      await http.MultipartFile.fromPath(
        'files', // field name should be 'files' according to curl
        fingerPrintEntity.fingerPrintImage.path,
        filename: 'fingerprint_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    );

    // Add headers (Content-Type will be set automatically for multipart)
    request.headers.addAll({'accept': 'application/json'});

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Check if the request was successful
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Extract the token from the response
        if (jsonResponse.containsKey('token')) {
          final String token = jsonResponse['token'];

          // Save the token to local storage
          await _localStorage.saveToken(token);

          print('Token saved successfully: $token');
          return Right("Fingerprint uploaded  successfully");
        } else {
          return Left(Failure(message: "ther is some issue"));
        }
      } catch (e) {
        print('Error parsing response: $e');
        return Left(Failure(message: "ther is some issue"));
      }
    } else if (response.statusCode == 400) {
      return Left(Failure(message: "please enter valid Fingerprint image"));
    } else {
      return Left(Failure(message: 'Server error: ${response.statusCode}'));
    }
  }
}
