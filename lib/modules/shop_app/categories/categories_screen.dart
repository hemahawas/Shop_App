import 'package:flutter/material.dart';
import 'package:my_project/layout/shop_app/cubit/cubit.dart';
import 'package:my_project/models/shop_app/categories_model.dart';
import 'package:my_project/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories Screen',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => buildCategoryItem(
            ShopCubit.get(context).categoriesModel!.data.data[index], context),
        separatorBuilder: (context, index) => SizedBox(
          height: 10.0,
        ),
        itemCount: ShopCubit.get(context).categoriesModel!.data.data.length,
      ),
    );
  }

  Widget buildCategoryItem(DataModel model, context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              child: Image(
                image: NetworkImage(model.image),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              model.name,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 15.0,
                  ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      );
}
