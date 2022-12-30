import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:my_project/layout/shop_app/cubit/cubit.dart';
import 'package:my_project/layout/shop_app/cubit/states.dart';
import 'package:my_project/layout/shop_app/shop_layout.dart';
import 'package:my_project/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:my_project/modules/shop_app/register/cubit/cubit.dart';
import 'package:my_project/modules/shop_app/shop_login/cubit/cubit.dart';
import 'package:my_project/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:my_project/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/shared/bloc_observer.dart';
import 'package:my_project/shared/network/local/cache/cache_helper.dart';
import 'package:my_project/shared/network/remote/dio_helper.dart';
import 'package:my_project/shared/styles/themes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e) {
    print(e.toString());
  }

  DioHelper.init();
  await CacheHelper.init();
  bool isDarkMain = CacheHelper.getData(key: 'isDark') ?? false;

  Widget widget;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;

  uId = CacheHelper.getData(key: 'uId') ?? '';

  token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(
        MyApp(
          isDarkApp: isDarkMain,
          startWidget: widget,
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  late bool isDarkApp;
  late Widget startWidget;
  MyApp({
    required this.isDarkApp,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopLoginCubit(),
        ),
        BlocProvider(
          create: (context) => ShopRegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        //themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
// hello
