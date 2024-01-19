import 'package:account_manager/Entry_page.dart';
import 'package:account_manager/Password_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DataClass.dart';

class Dashboard extends StatefulWidget {
  static Database? database;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController controller = TextEditingController();
  TextEditingController update_acc = TextEditingController();
  TextEditingController cur_pas = TextEditingController();
  TextEditingController new_pas = TextEditingController();
  List account = [];
  List record = [];
  var all_credit = [];
  var all_debit = [];
  Object Credit_Total = 0;
  Object Debit_Total = 0;
  List credit_amt = [];
  List debit_amt = [];
  List diff = [];

  get_db() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'account_manager.db');

    Dashboard.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE account (id INTEGER PRIMARY KEY, acc_name TEXT)');
      await db.execute(
          'CREATE TABLE records (id INTEGER PRIMARY KEY,p_id INTEGER,date TEXT,particular TEXT,credit INTEGER,debit INTEGER)');
    });
    String select = "select * from account";
    account = await Dashboard.database!.rawQuery(select);
    credit_amt = List.filled(account.length, "0");
    debit_amt = List.filled(account.length, "0");
    diff = List.filled(account.length, "0");
    for (int i = 0; i < account.length; i++) {
      String select = "select * from records where p_id=${account[i]['id']}";
      record = await Dashboard.database!.rawQuery(select);
      if (record.length != 0) {
        String credit =
            "select sum(credit) from records where p_id=${account[i]['id']}";
        String debit =
            "select sum(debit) from records where p_id=${account[i]['id']}";
        var sum_Credit = await Dashboard.database!.rawQuery(credit);
        var sum_Debit = await Dashboard.database!.rawQuery(debit);
        record = await Dashboard.database!.rawQuery(select);
        credit_amt[i] = sum_Credit[0]['sum(credit)'];
        debit_amt[i] = sum_Debit[0]['sum(debit)'];
        diff[i] = credit_amt[i] - debit_amt[i];
      }
    }

    all_credit =
        await Dashboard.database!.rawQuery("select sum(credit) from records");
    all_debit =
        await Dashboard.database!.rawQuery("select sum(debit) from records");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_db();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade800,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: FutureBuilder(
                      future: get_db(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Account Manager",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 225,
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.purple.shade300),
                                width: 225,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Credit(+)",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            (all_credit[0]['sum(credit)'] !=
                                                    null)
                                                ? "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} ${all_credit[0]['sum(credit)']}"
                                                : " ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} 0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Debit(-)",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            (all_debit[0]['sum(debit)'] != null)
                                                ? "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} ${all_debit[0]['sum(debit)']}"
                                                : " ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} 0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Balance",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            (all_credit[0]['sum(credit)'] !=
                                                        null &&
                                                    all_debit[0]
                                                            ['sum(debit)'] !=
                                                        null)
                                                ? "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} ${all_credit[0]['sum(credit)'] - all_debit[0]['sum(debit)']}"
                                                : " ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} 0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: Data.name.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (Data.name[index] == 'Home') {
                        Navigator.pop(context);
                      } else if (Data.name[index] == "Change pattern") {
                        AwesomeDialog(
                            context: context,
                            body: Container(
                              height: 300,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text(
                                    "Change Pattern",
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
                                          password_page.preferences!.setString(
                                              "password", input.join());
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )).show();
                        // cur_pas.text = "";
                        // new_pas.text = "";
                        // Navigator.pop(context);
                        // showDialog(
                        //   barrierDismissible: false,
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       title: Text("Change password"),
                        //       content: Container(
                        //         height: 200,
                        //         child: Column(
                        //           children: [
                        //             TextField(
                        //               maxLength: 4,
                        //               obscureText: true,
                        //               maxLengthEnforcement: MaxLengthEnforcement
                        //                   .truncateAfterCompositionEnds,
                        //               decoration: InputDecoration(
                        //                   hintText: "current password"),
                        //               controller: cur_pas,
                        //               keyboardType: TextInputType.number,
                        //             ),
                        //             TextField(
                        //                 obscureText: true,
                        //                 maxLength: 4,
                        //                 controller: new_pas,
                        //                 decoration: InputDecoration(
                        //                     hintText: "new password"),
                        //                 keyboardType: TextInputType.number),
                        //             Row(
                        //               children: [
                        //                 Expanded(
                        //                   child: InkWell(
                        //                     onTap: () {
                        //                       Navigator.pop(context);
                        //                     },
                        //                     child: Container(
                        //                       margin: EdgeInsets.all(10),
                        //                       height: 35,
                        //                       alignment: Alignment.center,
                        //                       child: Text(
                        //                         "Cancel",
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 17,
                        //                             color: Colors.purple),
                        //                       ),
                        //                       decoration: BoxDecoration(
                        //                         border: Border.all(
                        //                             color:
                        //                                 Colors.purple.shade800),
                        //                         borderRadius:
                        //                             BorderRadius.circular(10),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Expanded(
                        //                   child: InkWell(
                        //                     onTap: () {
                        //                       password_page
                        //                           .t1.text = password_page
                        //                               .preferences!
                        //                               .getString("password") ??
                        //                           "";
                        //                       if (cur_pas.text ==
                        //                           password_page.t1.text) {
                        //                         if (new_pas.text.length == 4) {
                        //                           password_page.preferences!
                        //                               .setString("password",
                        //                                   new_pas.text);
                        //                           setState(() {});
                        //                           Navigator.pop(context);
                        //                         }
                        //                       }
                        //                     },
                        //                     child: Container(
                        //                       margin: EdgeInsets.all(10),
                        //                       height: 35,
                        //                       alignment: Alignment.center,
                        //                       child: Text(
                        //                         "Set",
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 17,
                        //                             color: Colors.white),
                        //                       ),
                        //                       decoration: BoxDecoration(
                        //                         color: Colors.purple.shade800,
                        //                         borderRadius:
                        //                             BorderRadius.circular(10),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      } else if (Data.name[index] == "Change currency") {
                        showCurrencyPicker(
                          context: context,
                          theme: CurrencyPickerThemeData(
                            flagSize: 25,
                            titleTextStyle: TextStyle(fontSize: 17),
                            subtitleTextStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).hintColor),
                            inputDecoration: InputDecoration(
                              labelText: 'Select currency...',
                              hintText: 'Start typing to search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFF8C98A8).withOpacity(1),
                                ),
                              ),
                            ),
                          ),
                          onSelect: (currency) {
                            password_page.preferences!
                                .setString("cur_symbol", currency.symbol);
                            Navigator.pop(context);
                            setState(() {});
                          },
                        );
                      }
                    },
                    leading: Data.icon[index],
                    title: Text(Data.name[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  textStyle: TextStyle(fontSize: 15, color: Colors.black),
                  child: Text("Save as PDF"),
                ),
                PopupMenuItem(
                  textStyle: TextStyle(fontSize: 15, color: Colors.black),
                  child: Text("Save as Excel"),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.purple.shade800,
        title: Text("Dashboard"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        mini: true,
        tooltip: "Add Account",
        child: Icon(Icons.add),
        onPressed: () {
          controller.text = "";
          AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.noHeader,
            customHeader: Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.purple.shade800,
            ),
            body: Column(
              children: [
                Text(
                  "Add new account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(hintText: "Account name"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 35,
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.purple),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple.shade800),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (controller.text != "") {
                            String insert =
                                "insert into account values(null,'${controller.text}')";
                            Dashboard.database!.rawInsert(insert);
                            Navigator.pop(context);
                            setState(() {});
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 35,
                          alignment: Alignment.center,
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).show();
        },
      ),
      body: SafeArea(
          child: Container(
        color: Colors.white24,
        child: FutureBuilder(
          future: get_db(),
          builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: account.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Entry_Page(account[index]);
                          },
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 125,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 2)
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  account[index]['acc_name'],
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        update_acc.text =
                                            account[index]['acc_name'];
                                        AwesomeDialog(
                                          dismissOnTouchOutside: false,
                                          context: context,
                                          dialogType: DialogType.noHeader,
                                          customHeader: Icon(
                                            Icons.account_circle,
                                            size: 100,
                                            color: Colors.purple.shade800,
                                          ),
                                          body: Column(
                                            children: [
                                              Text(
                                                "Updete account",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: update_acc,
                                                decoration: InputDecoration(
                                                    hintText: "Account name"),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17,
                                                              color: Colors
                                                                  .purple),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .purple
                                                                  .shade800),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (update_acc.text !=
                                                            "") {
                                                          String update =
                                                              "update account set acc_name='${update_acc.text}' where id=${account[index]['id']}";
                                                          Dashboard.database!
                                                              .rawQuery(update);
                                                          // get_db();
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .purple.shade800,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ).show();
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        String delete =
                                            "delete from account where id=${account[index]['id']}";
                                        String ent_delete =
                                            "delete from records where p_id=${account[index]['id']}";
                                        Dashboard.database!.rawDelete(delete);
                                        Dashboard.database!
                                            .rawDelete(ent_delete);

                                        setState(() {});
                                      },
                                      icon: Icon(Icons.delete),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(thickness: 3),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Credit"),
                                      Text(
                                          "${credit_amt[index]} ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'}"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Debit"),
                                      Text(
                                          "${debit_amt[index]} ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'}"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Balance",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "${diff[index]} ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )),
    );
  }
}
