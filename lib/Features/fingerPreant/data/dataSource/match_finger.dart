import 'dart:io';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/failure/failure.dart';

class GetTheToken {
  Future<Either<Failure, String>> call(File fingerprintFile) async {
    const String apiUrl = 'http://10.21.54.187/auth/match-finger-print';

    // Create multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add only the image file (no name/email for matching)
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // field name should be 'file' according to curl
        fingerprintFile.path,
        filename: 'fingerprint_${DateTime.now().millisecondsSinceEpoch}.png',
      ),
    );

    // Add headers
    request.headers.addAll({'accept': 'application/json'});

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Check if the request was successful
    print('Match Fingerprint Status Code: ${response.statusCode}');
    print('Match Fingerprint Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final String? token = jsonResponse['best_matching_token'];

        if (token != null && token.isNotEmpty) {
          return Right(token);
        } else {
          return Left(Failure(message: "no match found"));
        }
      } catch (e) {
        return Left(Failure(message: "Fingerprint matched successfully"));
      }
    } else {
      return Left(Failure(message: 'Server error: try again later'));
    }
  }
}
