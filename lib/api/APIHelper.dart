import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sling/main.dart';
import 'package:sling/models/address.dart';
import 'package:sling/models/cart.dart';
import 'package:sling/models/clothing.dart';
import 'package:http/http.dart' as http;

enum InteractionType { LIKE, DISLIKE, ADDTOCART }

class APIHelper {
  APIHelper();

  static String endpoint = "https://test.api.fashion.twospoon.ai";
  static String base_url = "test.api.fashion.twospoon.ai";
  static String version = "v1";

  // Interaction Complete
  static Future<bool> postInteraction(
      String productId, InteractionType type) async {
    String action;
    switch (type) {
      case InteractionType.LIKE:
        action = "liked";
        break;
      case InteractionType.DISLIKE:
        action = "notliked";
        break;
      case InteractionType.ADDTOCART:
        action = "addToCart";
        break;
    }

    Uri url =
        Uri.parse("$endpoint/$version/products/$productId/interaction/liked");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    http.Response response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    // print('Token: $token');
    // print(
    //     'POST $url ${response.statusCode} Response: ${response.body} ${response.headers}');
    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      if (responseObject['status'] == 200) {
        return true;
      }
    }

    return false;
  }

  // Recommendation Complete
  static Future<Map<String, dynamic>> getRecommendation() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/products/recommendations");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    // print('Token: $token');
    print(
        'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      if (responseObject['status'] == 200) {
        result['success'] = true;
        result['response'] =
            List<Map<String, dynamic>>.from(responseObject["data"]).map((obj) =>
                ClothingItem(
                    id: obj["id"],
                    name: obj["title"],
                    price: obj["price"],
                    seller: obj["shop"]["name"],
                    image: obj["preview"],
                    images: [obj["preview"], obj["preview"], obj["preview"]],
                    variant_id: obj['variant_id']));
      }
    }

    print('GET $url result: $result');
    return result;
  }

  // Product Complete
  static Future<Map<String, dynamic>> getProduct(String productId) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/products/$productId");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    // print('Token: $token');
    // print(
    //     'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      if (responseObject['status'] == 200) {
        result['success'] = true;
        result['response'] = responseObject["data"];
      }
    }

    print('GET $url result: ${result['response'][0]['isInWishList']}');
    // for (var variant in result['response'][0]['variants']) {
    //   print('${variant['title']} ${variant['price']}');
    // }
    return result;
  }

  // Auth Complete
  static Future<Map<String, dynamic>> getAuth(
      String name, String email, String uid) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/auth/");

    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": name, "email": email, "uid": uid}));

    // print(
    //     'POST $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject["data"];
    }

    print('GET $url result: $result');
    return result;
  }

  // Onboard Complete
  static Future<Map<String, dynamic>> getOnboard(
      Map<String, dynamic> data) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/auth/onboard");

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
        body: json.encode(data));

    // print('Token: $token');
    // print(
    //     'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject["data"];
    }

    print('GET $url result: $result');
    return result;
  }

  // Reset Works
  static Future<Map<String, dynamic>> resetOnboard(
      String email, String stage) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/users/reset/");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({"email": email, "stage": stage}));

    // print('Token: $token');
    print(
        'PATCH $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('PATCH $url result: $result');
    return result;
  }

  // Search Complete
  static Future<Map<String, dynamic>> getSearch(String searchTerm) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Map<String, dynamic> queryParams = {"term": searchTerm};
    Uri url = Uri.https(base_url, "/$version/products/search", queryParams);

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
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
      Map<String, dynamic> responseObject =
          Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject["data"];
      List<dynamic> resp = result['response'].toList();
      for (Map<String, dynamic> item in resp) {
        if (item['productImage'].length == 0) {
          item['productImage'].add({'source': 'Null'});
        }
      }
    }

    // print('GET $url result: ${result['response'][0]}');
    return result;
  }

  // Get Cart Complete
  static Future<Map<String, dynamic>> getCart() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/cart");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
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
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject["data"];
      List<dynamic> resp = result['response'].toList();
    }

    print('GET $url');
    return result;
  }

  // Add to Cart Complete
  static Future<Map<String, dynamic>> addToCart(
      String product_id, String variant_id, int quantity) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.https(base_url, "/$version/cart/add");

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

    Uri url = Uri.parse("$endpoint/$version/cart/");

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

    Uri url = Uri.parse("$endpoint/$version/cart/delete/$_id");

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

  // Get Addresses Complete
  static Future<Map<String, dynamic>> getAddresses() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/address");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    print('Token: $token');
    print(
        'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseObject =
          new Map<String, dynamic>.from(json.decode(response.body));
      result['success'] = true;
      result['response'] =
          List<Map<String, dynamic>>.from(responseObject["address"]).map(
              (obj) => Address(
                  id: obj["_id"],
                  user_id: obj["user_id"],
                  address: obj["address"],
                  city: obj["city"],
                  state: obj["state"],
                  pincode: obj["pincode"],
                  phone: obj["phone"],
                  createdAt: DateTime.parse(obj["createdAt"]),
                  updatedAt: DateTime.parse(obj["updatedAt"]),
                  v: obj["_v"]));
    }

    print('GET $url result: $result');
    return result;
  }

  // Create Address Complete
  static Future<Map<String, dynamic>> createAddress(Address address) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/address/add");

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
          "address": address.address,
          "pincode": address.pincode,
          "city": address.city,
          "state": address.state,
          "phone": address.phone
        }));

    print('Token: $token');
    print(
        'POST $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 201) {
      Map<String, dynamic> obj =
          new Map<String, dynamic>.from(json.decode(response.body)["address"]);
      result['success'] = true;
      result['response'] = Address(
          id: obj["_id"],
          user_id: obj["user_id"],
          address: obj["address"],
          city: obj["city"],
          state: obj["state"],
          pincode: obj["pincode"],
          phone: obj["phone"],
          createdAt: DateTime.parse(obj["createdAt"]),
          updatedAt: DateTime.parse(obj["updatedAt"]),
          v: obj["_v"]);
    }

    print('GET $url result: $result');
    return result;
  }

  // Where am I supposed to use this?
  static Future<Map<String, dynamic>> updateAddress(Address address) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/address/update/${address.id}");

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
          "address": address.address,
          "pincode": address.pincode,
          "city": address.city,
          "state": address.state,
          "phone": address.phone
        }));

    print('Token: $token');
    print(
        'PATCH $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> obj = new Map<String, dynamic>.from(
          json.decode(response.body)["updatedAddress"]);
      result['success'] = true;
      result['response'] = Address(
          id: obj["_id"],
          user_id: obj["user_id"],
          address: obj["address"],
          city: obj["city"],
          state: obj["state"],
          pincode: obj["pincode"],
          phone: obj["phone"],
          createdAt: DateTime.parse(obj["createdAt"]),
          updatedAt: DateTime.parse(obj["updatedAt"]),
          v: obj["_v"]);
    }

    print('PATCH $url result: $result');
    return result;
  }

  // Where am I supposed to use this?
  static Future<Map<String, dynamic>> deleteAddress(String id) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/address/delete/$id");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
      result["message"] = "Unable to get JWT from FirebaseAuth";
      return result;
    }

    http.Response response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    print('Token: $token');
    print(
        'DELETE $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      Map<String, dynamic> obj =
          new Map<String, dynamic>.from(json.decode(response.body));
      result['success'] = true;
      result['response'] = obj["message"];
    }

    print('PATCH $url result: $result');
    return result;
  }

  // Razorpay Integration Required
  static Future<Map<String, dynamic>> getOrders() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/orders/myOrders");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
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
    print(
        'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      List<dynamic> responseObject =
          new List<dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('GET $url result: $result');
    return result;
  }

  // Create Order Complete
  static Future<Map<String, dynamic>> createOrder(
      String billingAddressId) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.https(base_url, "/$version/orders/create");

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

  // Verify Order Complete
  static Future<Map<String, dynamic>> verifyOrder(String razorpay_payment_id,
      String razorpay_order_id, String razorpay_signature) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.https(base_url, "/$version/orders/verify");

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
          "razorpay_payment_id": razorpay_payment_id,
          "razorpay_order_id": razorpay_order_id,
          "razorpay_signature": razorpay_signature,
        }));

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

  static Future<Map<String, dynamic>> getWishlist() async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.https(base_url, "/$version/wishlist");

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null || token.isEmpty) {
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

    print('Token: $token');
    print(
        'GET $url ${response.statusCode} Response: ${response.body} ${response.headers}');

    if (response.statusCode == 200) {
      List<dynamic> responseObject =
          new List<dynamic>.from(json.decode(response.body));
      result["success"] = true;
      result['response'] = responseObject;
    }

    print('GET $url result: $result');
    return result;
  }

  static Future<Map<String, dynamic>> deleteFromWishlist(String id) async {
    Map<String, dynamic> result = new Map();
    result['success'] = false;

    Uri url = Uri.parse("$endpoint/$version/wishlist/");

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
