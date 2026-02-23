import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/premium_state.dart';

class PremiumRepository {
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<PremiumState> load() async {
    final prefs = await SharedPreferences.getInstance();
    return PremiumState(isPremium: prefs.getBool('premium') ?? false);
  }

  Future<List<ProductDetails>> fetchProducts() async {
    const ids = {'detox_premium_one_time'};
    final response = await _iap.queryProductDetails(ids);
    return response.productDetails;
  }

  Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premium', value);
  }
}
