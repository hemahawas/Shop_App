import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/layout/shop_app/cubit/states.dart';
import 'package:my_project/models/shop_app/categories_model.dart';
import 'package:my_project/models/shop_app/change_favorites_model.dart';
import 'package:my_project/models/shop_app/favorites_model.dart';
import 'package:my_project/models/shop_app/home_model.dart';
import 'package:my_project/models/shop_app/login_model.dart';
import 'package:my_project/models/shop_app/search_model.dart';
import 'package:my_project/modules/shop_app/categories/categories_screen.dart';
import 'package:my_project/modules/shop_app/favorites/favorites_screen.dart';
import 'package:my_project/modules/shop_app/products/products_screen.dart';
import 'package:my_project/modules/shop_app/settings/settings_screen.dart';
import 'package:my_project/shared/components/constants.dart';
import 'package:my_project/shared/network/end_points.dart';
import 'package:my_project/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialStates());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> shopScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNav(index) {
    currentIndex = index;
    emit(ShopChangeBottomNavStates());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(path: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      homeModel!.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(path: GET_CATEGORIES, lang: 'en').then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      path: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      //print(value.data);
      if (!changeFavoritesModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(model: changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    DioHelper.getData(path: FAVORITES, lang: 'en', token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserState());
    DioHelper.getData(path: PROFILE, lang: 'en', token: token).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUserState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserState());
    });
  }

  void putUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      path: UPDATE_PROFILE,
      lang: 'en',
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopLoadingUpdateUserState());
    });
  }

  SearchModel? searchModel;

  void searchData(String text) {
    emit(ShopLoadingSearchState());
    DioHelper.postData(
      path: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);

      emit(ShopSuccessSearchState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorSearchState());
    });
  }
}
