
import 'package:bhbd_project/Constants/app_data.dart';
class MyHeaders {
  static Map<String, String> header() {
    return {
      'Content-type': 'application/json',
      'X-Shopify-Storefront-Access-Token': AppData.shopifyAccessToken,
      // 'Accept': 'application/json',
      //'Authorization': UserData.authConfirm?.key==null?"":"Bearer ${UserData.authConfirm!.key!}"
    };
  }
}
