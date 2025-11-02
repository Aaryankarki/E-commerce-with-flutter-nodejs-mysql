// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentService {
  Future<InitiateResponse> paymentInitiate() async {
    try {
      final response = await http.post(
        Uri.parse("https://dev.khalti.com/api/v2/epayment/initiate/"),
        body: jsonEncode({
          "return_url":
              "https://cloudinary.com/documentation/node_image_and_video_upload",
          "website_url":
              "https://cloudinary.com/documentation/node_image_and_video_upload",
          "amount": "3000000",
          "purchase_order_id": "1",
          "purchase_order_name": "Test User",
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return InitiateResponse.fromJson(json);
      }
      print("error ${response.statusCode}");
      throw "Error: ${response.statusCode}";
    } catch (e) {
      print("errror $e");

      rethrow;
    }
  }
}

class InitiateResponse {
  final String pidx;
  final String paymentUrl;
  InitiateResponse({required this.pidx, required this.paymentUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'pidx': pidx, 'paymentUrl': paymentUrl};
  }

  factory InitiateResponse.fromMap(Map<String, dynamic> map) {
    return InitiateResponse(
      pidx: map['pidx'] as String,
      paymentUrl: map['paymentUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InitiateResponse.fromJson(String source) =>
      InitiateResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
