import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_project/shared/styles/colors.dart';
import 'package:my_project/shared/styles/icon_broken.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backGround = Colors.blue,
  required String text,
  required VoidCallback function,
}) =>
    Container(
      height: 40.0,
      color: defaultColor,
      width: width,
      child: MaterialButton(
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: function,
      ),
    );

Widget defaultTextButton({
  required Function onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        } else {
          return;
        }
      },
      child: Text(
        '${text.toUpperCase()}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit(value);
        } else {
          return;
        }
      },
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          return;
        }
      },
      onChanged: (value) {
        if (onChange != null) {
          onChange(value);
        } else {
          return;
        }
      },
      validator: (value) {
        return validate(value);
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  if (suffixPressed != null) {
                    suffixPressed();
                  } else {
                    return;
                  }
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

// Widget screenBuilder({required List<Map> tasks}) => ConditionalBuilder(
//       condition: tasks.isNotEmpty,
//       builder: (context) => ListView.separated(
//         itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
//         separatorBuilder: (context, index) => const SizedBox(
//           height: 10.0,
//         ),
//         itemCount: tasks.length,
//       ),
//       fallback: (context) => Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(
//               Icons.menu,
//               size: 30.0,
//               color: Colors.blueGrey,
//             ),
//             Text(
//               'No tasks yet',
//               style: TextStyle(
//                 color: Colors.blueGrey,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

// News App

// Widget buildArticleScreen(list) => ConditionalBuilder(
//       condition: list.isNotEmpty,
//       builder: (context) => ListView.separated(
//         physics: BouncingScrollPhysics(),
//         itemBuilder: (context, index) => buildArticleItem(list[index], context),
//         separatorBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10.0),
//           child: Container(
//             width: double.infinity,
//             height: 1.0,
//             color: Colors.orangeAccent,
//           ),
//         ),
//         itemCount: list.length,
//       ),
//       fallback: (context) => const Center(child: CircularProgressIndicator()),
//     );

void navigateTo(context, screen) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ));

void navigateAndFinish(context, screen) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (Route<dynamic> route) => false,
    );

void showToast({
  required String message,
  required state,
}) =>
    Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: stateColor(state),
            textColor: Colors.white,
            fontSize: 16.0)
        .catchError((error) {
      print(error.toString());
    });

enum ToastColor { success, error, warning }

Color stateColor(ToastColor state) {
  Color color;
  switch (state) {
    case ToastColor.success:
      color = Colors.green;
      break;
    case ToastColor.error:
      color = Colors.red;
      break;
    case ToastColor.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        icon: Icon(IconBroken.Arrow___Left_2),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
      ),
      actions: actions,
    );
