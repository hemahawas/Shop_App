//https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca

import 'package:my_project/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:my_project/shared/components/components.dart';
import 'package:my_project/shared/network/local/cache/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    navigateAndFinish(context, ShopLoginScreen());
  });
}

void printFulltext(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String? token =
    '0pWttizzOEy024V2tjYBftNE4oVfwhvKPDpXuWcvyarSjWsLMHaALcfmz2dcFUoQfqFrdY';

String uId = '';
