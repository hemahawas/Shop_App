import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/layout/shop_app/cubit/cubit.dart';
import 'package:my_project/layout/shop_app/cubit/states.dart';
import 'package:my_project/shared/components/components.dart';
import 'package:my_project/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  var nameControl = TextEditingController();
  var emailControl = TextEditingController();
  var phoneControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        nameControl.text = ShopCubit.get(context).userModel!.data!.name;
        emailControl.text = ShopCubit.get(context).userModel!.data!.email;
        phoneControl.text = ShopCubit.get(context).userModel!.data!.phone;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                defaultFormField(
                  controller: nameControl,
                  type: TextInputType.name,
                  validate: () {},
                  label: 'Name',
                  prefix: Icons.person,
                ),
                SizedBox(
                  height: 10.0,
                ),
                defaultFormField(
                  controller: emailControl,
                  type: TextInputType.emailAddress,
                  validate: () {},
                  label: 'Email Address',
                  prefix: Icons.email,
                ),
                SizedBox(
                  height: 10.0,
                ),
                defaultFormField(
                  controller: phoneControl,
                  type: TextInputType.number,
                  validate: () {},
                  label: 'Phone Number',
                  prefix: Icons.phone,
                ),
                SizedBox(
                  height: 20.0,
                ),
                defaultButton(
                  text: 'SIGN OUT',
                  function: () {
                    signOut(context);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                defaultButton(
                  text: 'UPDAte',
                  function: () {
                    ShopCubit.get(context).putUserData(
                      name: nameControl.text,
                      email: emailControl.text,
                      phone: phoneControl.text,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
