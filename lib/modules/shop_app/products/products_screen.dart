import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/layout/shop_app/cubit/cubit.dart';
import 'package:my_project/layout/shop_app/cubit/states.dart';
import 'package:my_project/models/shop_app/categories_model.dart';
import 'package:my_project/models/shop_app/home_model.dart';
import 'package:my_project/shared/components/components.dart';
import 'package:my_project/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model!.status) {
            showToast(message: state.model!.message!, state: ToastColor.error);
          }
        }
      },
      builder: (context, State) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productBuilder(ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel, context),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget productBuilder(HomeModel? model, CategoriesModel? catModel, context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            items: model?.data.banners
                .map(
                  (e) => Image(
                    image: NetworkImage(e.image),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              viewportFraction: 1.0,
              initialPage: 0,
              height: 250.0,
              enableInfiniteScroll: true,
              reverse: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Container(
            height: 100.0,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  buildCategoriesItem(catModel!.data.data[index]),
              separatorBuilder: (context, index) => SizedBox(
                width: 10.0,
              ),
              itemCount: catModel!.data.data.length,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Products',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.63,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(model!.data.products.length, (index) {
                return buildGridProduct(model.data.products[index], context);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoriesItem(DataModel? catModel) => Container(
        height: 100.0,
        width: 100.0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(catModel!.image),
            ),
            Container(
              height: 18.0,
              alignment: AlignmentDirectional.bottomCenter,
              width: double.infinity,
              color: Colors.black.withOpacity(
                .7,
              ),
              child: Text(
                catModel.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  buildGridProduct(ProductModel model, context) => Container(
        color: Colors.white,
        child: Column(
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 200.0,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price}',
                        style: TextStyle(
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${model.oldPrice}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        padding: EdgeInsetsDirectional.zero,
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id);
                        },
                        icon: ShopCubit.get(context).favorites[model.id] == true
                            ? Icon(
                                Icons.favorite,
                                size: 30.0,
                                color: defaultColor,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 30.0,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
