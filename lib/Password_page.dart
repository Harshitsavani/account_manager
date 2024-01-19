import 'package:account_manager/Dashboard.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:shared_preferences/shared_preferences.dart';

class password_page extends StatefulWidget {
  static SharedPreferences? preferences;
  static TextEditingController t1 = TextEditingController();

  @override
  State<password_page> createState() => _password_pageState();
}

class _password_pageState extends State<password_page> {
  PinInputController controller = PinInputController(length: 4);

  get_prefs() async {
    password_page.preferences = await SharedPreferences.getInstance();
    password_page.t1.text =
        password_page.preferences?.getString("password") ?? '';
    print(password_page.t1.text =
        password_page.preferences?.getString("password") ?? '');
    if (password_page.t1.text == "") {
      get_dialog();
    }
  }

  get_dialog() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          body: Container(
            height: 300,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  "Set Pattern",
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child: PatternLock(
                    notSelectedColor: Colors.black,
                    // color of selected points.
                    selectedColor: Colors.red,
                    // radius of points.
                    pointRadius: 8,
                    // whether show user's input and highlight selected points.
                    showInput: true,
                    // count of points horizontally and vertically.
                    dimension: 3,
                    // padding of points area relative to distance between points.
                    relativePadding: 0.7,
                    // needed distance from input to point to select point.
                    selectThreshold: 25,
                    // whether fill points.
                    fillPoints: true,
                    // callback that called when user's input complete. Called if user selected one or more points.
                    onInputComplete: (List<int> input) {
                      if (input.length >= 4) {
                        password_page.preferences!
                            .setString("password", input.join());
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          )).show();
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.info,
      //   btnOkText: "Set",
      //   dismissOnTouchOutside: false,
      //   body: Column(
      //     children: [
      //       Text(
      //         "Set Pin",
      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //       ),
      //       PinCodeTextField(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         keyboardType: TextInputType.number,
      //         appContext: context,
      //         length: 4,
      //         controller: password_page.t1,
      //         animationType: AnimationType.slide,
      //       ),
      //       InkWell(
      //         onTap: () {
      //           if (password_page.t1.text.length != 4) {
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               SnackBar(
      //                 content: Text("Please Fill All The Field"),
      //                 duration: Duration(seconds: 1),
      //                 behavior: SnackBarBehavior.floating,
      //               ),
      //             );
      //           } else {
      //             password_page.preferences!
      //                 .setString("password", password_page.t1.text);
      //             Navigator.pop(context);
      //             showCurrencyPicker(
      //               context: context,
      //               theme: CurrencyPickerThemeData(
      //                 flagSize: 25,
      //                 titleTextStyle: TextStyle(fontSize: 17),
      //                 subtitleTextStyle: TextStyle(
      //                     fontSize: 15, color: Theme.of(context).hintColor),
      //                 //Optional. Styles the search field.
      //                 inputDecoration: InputDecoration(
      //                   labelText: 'Select currency...',
      //                   hintText: 'Start typing to search',
      //                   prefixIcon: const Icon(Icons.search),
      //                   border: OutlineInputBorder(
      //                     borderSide: BorderSide(
      //                       color: const Color(0xFF8C98A8).withOpacity(1),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               onSelect: (currency) {
      //                 password_page.preferences!
      //                     .setString("cur_symbol", currency.symbol);
      //                 print(
      //                     password_page.preferences!.getString("cur_symbol") ??
      //                         '(₹)');
      //               },
      //             );
      //           }
      //         },
      //         child: Container(
      //           alignment: Alignment.center,
      //           margin: EdgeInsets.all(10),
      //           height: 40,
      //           child: Text(
      //             "Set",
      //             style: TextStyle(
      //                 fontWeight: FontWeight.bold, color: Colors.white),
      //           ),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             color: Colors.green.shade500,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   animType: AnimType.scale,
      // ).show();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_prefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey, Colors.white, Colors.grey])),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Account Manager",
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                SizedBox(
                  height: 29,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      children: [
                        Text(
                          "Draw Pattern",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Expanded(
                          child: PatternLock(
                            // color of selected points.
                            selectedColor: Colors.red,
                            // radius of points.
                            pointRadius: 8,
                            // whether show user's input and highlight selected points.
                            showInput: true,
                            // count of points horizontally and vertically.
                            dimension: 3,
                            // padding of points area relative to distance between points.
                            relativePadding: 0.7,
                            // needed distance from input to point to select point.
                            selectThreshold: 25,
                            // whether fill points.
                            fillPoints: true,
                            notSelectedColor: Colors.white,
                            // callback that called when user's input complete. Called if user selected one or more points.
                            onInputComplete: (List<int> input) {
                              if (input.join() ==
                                  password_page.preferences!
                                      .getString("password")) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Dashboard();
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // child: PinPlusKeyBoardPackage(
                    //   keyboardButtonShape: KeyboardButtonShape.circular,
                    //   inputShape: InputShape.circular,
                    //   inputsMaxWidth: double.infinity,
                    //   keyboardMaxWidth: double.infinity,
                    //   inputHasBorder: true,
                    //   inputTextColor: Colors.white,
                    //   inputFillColor: Colors.white,
                    //   inputBorderColor: Colors.black,
                    //   isInputHidden: true,
                    //   inputHiddenColor: Colors.black,
                    //   buttonFillColor: Colors.black,
                    //   btnTextColor: Colors.white,
                    //   pinInputController: controller,
                    //   onSubmit: () {
                    //     if (controller.text == password_page.t1.text) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) {
                    //             return Dashboard();
                    //           },
                    //         ),
                    //       );
                    //     }
                    //   },
                    //   keyboardFontFamily: 'one',
                    //   spacing: 10,
                    // ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
