import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horcrux/main.dart';
import 'package:horcrux/models/cart.dart';
import 'package:horcrux/models/clothing.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  APIHelper();

  static String endpoint = "http://192.168.83.63:5000";
  static const String secretKey = "horcrux";

  static String signToken(String token, String email) {
    final jwt = JWT(
      {'token': token, 'email': email},
    );

    return jwt.sign(SecretKey(secretKey));
  }

  // Interaction Complete
  static Future<Map<String, dynamic>> postInteraction(
      String productId, String type) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/user/interaction/");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": signToken(token, email)
        },
        body: json.encode({
          'uid': "advay2807@gmail.com",
          'pid': productId,
          'interactionType': type
        }));

    // print('Token: $token');
    print(
        'POST $url ${response.statusCode} Response: ${response.body} ${response.headers}');
    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result['success'] = true;
      result['message'] = "Success";
      return result;
    }

    return result;
  }

  // Recommendation Complete
  static Future<Map<String, dynamic>> getRecommendation() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/products/feed");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": signToken(token, email)
    });

    if (response.statusCode == 200) {
      dynamic responseObject = json.decode(response.body);
      result['success'] = true;
      result['response'] =
          List<Map<String, dynamic>>.from(responseObject["data"])
              .map((obj) => ClothingItem(
                    id: obj["pid"],
                    name: obj["name"],
                    price: obj["price"].toString(),
                    seller: obj["vendor"],
                    image: obj["preview"],
                    images: [obj["preview"], obj["preview"], obj["preview"]],
                  ));
    }

    return result;
  }

  // Trending Complete
  static Future<Map<String, dynamic>> getTrending() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/products/trending");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": signToken(token, email)
    });

    if (response.statusCode == 200) {
      dynamic responseObject = json.decode(response.body);
      result['success'] = true;
      result['response'] =
          List<Map<String, dynamic>>.from(responseObject["data"])
              .map((obj) => ClothingItem(
                    id: obj["pid"],
                    name: obj["name"],
                    price: obj["price"].toString(),
                    seller: obj["vendor"],
                    image: obj["preview"],
                    images: [obj["preview"], obj["preview"], obj["preview"]],
                  ));
    }

    return result;
  }

  // Product Complete
  static Future<Map<String, dynamic>> getProduct(String productId) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/products/$productId");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": signToken(token, email)
    });

    if (response.statusCode == 200) {
      dynamic responseObject = json.decode(response.body);
      result['success'] = true;

      result['response'] = responseObject["data"];
    }

    return result;
  }

  // Auth Complete
  static Future<Map<String, dynamic>> getAuth(String name, String email) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/auth/login");

    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": name, "email": email}));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject["data"];
    }

    return result;
  }

  // Search Complete
  static Future<Map<String, dynamic>> getSearch(String searchTerm) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/products/search?q=$searchTerm");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    // print('Token: $token');
    // print(
    //     'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      dynamic responseObject = json.decode(response.body);
      result["success"] = true;
      result['response'] = responseObject["data"];
      List<dynamic> resp = result['response'].toList();
    }

    // print('GET $url result: ${result['response'][0]}');
    return result;
  }

  // Get Cart Complete
  static Future<Map<String, dynamic>> getCart() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/user/cart");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": signToken(token, email)
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] =
          List<Map<String, dynamic>>.from(responseObject["data"])
              .map((obj) => ClothingItem(
                    id: obj["pid"],
                    name: obj["name"],
                    price: obj["price"].toString(),
                    seller: obj["vendor"],
                    quantity: obj["quantity"],
                    image: obj["preview"],
                    images: [obj["preview"], obj["preview"], obj["preview"]],
                  ));
      ;
      List<dynamic> resp = result['response'].toList();
    }

    return result;
  }

  // Add to Cart Complete
  static Future<Map<String, dynamic>> addToCart(
      String product_id, String variant_id, int quantity) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/products/trending");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          "product_id": product_id,
          "variant_id": variant_id,
          "quantity": quantity
        }));

    print(variant_id);
    // print(
    //     'POST $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // int currentCartNum = await CartService.getCartNum();
      // int updatedCartNum = currentCartNum + 1;
      // await CartService.setCartNum(updatedCartNum);
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('POST $url result: $result');
    return result;
  }

  // Update Cart Complete
  static Future<Map<String, dynamic>> updateCart(
      String id, dynamic change) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/cart/");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response;

    if (change.runtimeType == String) {
      response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode({"id": id, "variant_id": change}));
    } else {
      response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode({"id": id, "quantity": change}));
    }

    // print('Token: $token');
    print(
        'PATCH $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('PATCH $url result: $result');
    return result;
  }

  // Delete from Cart Complete
  static Future<Map<String, dynamic>> deleteFromCart(String _id) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/cart/delete/$_id");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    // print('Token: $token');
    // print(
    //     'DELETE $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      // int currentCartNum = await CartService.getCartNum();
      // int updatedCartNum = currentCartNum - 1;
      // if (updatedCartNum >= 0) {
      //   await CartService.setCartNum(updatedCartNum);
      // }
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    // print('DELETE $url result: $result');
    return result;
  }

  // Create Order Complete
  static Future<Map<String, dynamic>> createOrder(
      String billingAddressId) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/products/trending");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({"billingAddressId": billingAddressId}));

    print('Token: $token');
    print(
        'POST $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('POST $url result: $result');
    return result;
  }

  // Get Wishlist Complete
  static Future<Map<String, dynamic>> getWishlist() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/user/wishlist");

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String? token = "token";
    // String? email = await FirebaseAuth.instance.currentUser?.email;
    String? email = "advay2807@gmail.com";
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": signToken(token, email)
    });

    if (response.statusCode == 200) {
      dynamic responseObject = json.decode(response.body);
      result["success"] = true;
      result['response'] =
          List<Map<String, dynamic>>.from(responseObject["data"])
              .map((obj) => ClothingItem(
                    id: obj["pid"],
                    name: obj["name"],
                    price: obj["price"].toString(),
                    seller: obj["vendor"],
                    image: obj["preview"],
                    images: [obj["preview"], obj["preview"], obj["preview"]],
                  ));
      ;
    }

    return result;
  }

  // Delete From Wishlist Complete
  static Future<Map<String, dynamic>> deleteFromWishlist(String id) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/api/wishlist/");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.delete(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          "productId": id,
        }));

    print('Token: $token');
    print(
        'DELETE $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('DELETE $url result: $result');
    return result;
  }
}
