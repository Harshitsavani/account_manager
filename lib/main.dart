import 'package:account_manager/Password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,DeviceOrientation.portraitDown
  ]);
  runApp(
      MaterialApp(
    debugShowCheckedModeBanner: false,
    home: password_page(),
  ));
}

class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  TextEditingController t1 = TextEditingController();
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SearchBarAnimation(
          isSearchBoxOnRightSide: true,
          onChanged: (value) {},
          textEditingController: t1,
          isOriginalAnimation: true,
          secondaryButtonWidget: Icon(Icons.close),
          buttonWidget: Icon(Icons.search),
          trailingWidget: Icon(
            Icons.search,
            color: Colors.blue,
          ),
        ),
      ),
      // body:
    );
  }
}
