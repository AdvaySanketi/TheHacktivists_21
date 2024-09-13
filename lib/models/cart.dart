import 'package:shared_preferences/shared_preferences.dart';

bool cartAvailable = false;

List<dynamic> localResults = [];
double localTotalPrice = 0.0;
List<List<dynamic>> localOptions = [];
List<List<dynamic>> localVariants = [];
List<List<String>> localDropdownValues = [];
List<int> localQuantity = [1];
List<int> localMaxQuantity = [1];

class CartService {
  static Future<int> getCartNum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cartNum') ?? 0;
  }

  static Future<void> setCartNum(int cartNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cartNum', cartNum);
  }
}
