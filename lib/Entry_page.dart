import 'package:account_manager/Dashboard.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calender_picker/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:account_manager/Password_page.dart';

class Entry_Page extends StatefulWidget {
  Map m;

  Entry_Page(this.m);

  @override
  State<Entry_Page> createState() => _Entry_PageState();
}

class _Entry_PageState extends State<Entry_Page> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController Date = TextEditingController();
  String type = "";
  List record = [];
  var sum_credit = [];
  var sum_debit = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Date.text =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  }

  fun() async {
    String select = "select * from records where p_id=${widget.m['id']}";
    String credit =
        "select sum(credit) from records where p_id=${widget.m['id']}";
    String debit =
        "select sum(debit) from records where p_id=${widget.m['id']}";

    sum_credit = await Dashboard.database!.rawQuery(credit);
    sum_debit = await Dashboard.database!.rawQuery(debit);
    record = await Dashboard.database!.rawQuery(select);

    print(sum_credit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.arrow_back,
                )),
            SizedBox(
              width: 10,
            ),
            Text("${widget.m['acc_name']}"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              t1.text = "";
              t2.text = "";
              AwesomeDialog(
                dismissOnTouchOutside: false,
                context: context,
                dialogType: DialogType.noHeader,
                body: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 35,
                      color: Colors.purple.shade800,
                      child: Text(
                        "Add transaction",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Transaction Date",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      onTap: () {
                        CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                                calendarType: CalendarDatePicker2Type.range),
                            value: [
                              DateTime(2021, 8, 10),
                              DateTime(2021, 8, 13),
                            ]);
                        // showDatePicker(
                        //
                        //     currentDate: DateTime(DateTime.now().day),
                        //     context: context,
                        //     initialDate: DateTime(DateTime.now().year,
                        //         DateTime.now().month, DateTime.now().day),
                        //     firstDate: DateTime(2000),
                        //     lastDate: DateTime(2024));

                      },
                      controller: Date,
                    ),
                    StatefulBuilder(
                      builder: (context, mystate) {
                        return Row(
                          children: [
                            Text(
                              "Transaction type:",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Radio(
                              value: "Credit",
                              groupValue: "$type",
                              onChanged: (value) {
                                mystate(() {
                                  type = value!;
                                });
                              },
                            ),
                            Text(
                              "Credit(+)",
                              style: TextStyle(fontSize: 12),
                            ),
                            Radio(
                              value: "Debit",
                              groupValue: "$type",
                              onChanged: (value) {
                                mystate(() {
                                  type = value!;
                                });
                              },
                            ),
                            Text(
                              "Debit(-)",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: t1,
                      decoration: InputDecoration(hintText: "Amount"),
                    ),
                    TextFormField(
                      controller: t2,
                      decoration: InputDecoration(hintText: "Particular"),
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
                                border:
                                    Border.all(color: Colors.purple.shade800),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (type == 'Credit') {
                                String insert =
                                    "insert into records values(null,'${widget.m['id']}','${Date.text}','${t2.text}',${t1.text},0)";
                                Dashboard.database!.rawInsert(insert);
                              } else if (type == "Debit") {
                                String insert =
                                    "insert into records values(null,'${widget.m['id']}','${Date.text}','${t2.text}',0,${t1.text})";
                                Dashboard.database!.rawInsert(insert);
                              }
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 35,
                              alignment: Alignment.center,
                              child: Text(
                                "Add",
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
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: WillPopScope(
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.grey.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Particular",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      "Credit ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      "Debit ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: fun(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: record.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(0, 0, 0, 0),
                              items: [
                                PopupMenuItem(
                                  onTap: () {
                                    if (record[index]['credit'] != 0) {
                                      type = "credit";
                                    } else {
                                      type = "debit";
                                    }
                                    AwesomeDialog(
                                      dismissOnTouchOutside: false,
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      body: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            color: Colors.purple.shade800,
                                            child: Text(
                                              "Update transaction",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Transaction Date",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            controller: Date,
                                          ),
                                          StatefulBuilder(
                                            builder: (context, mystate) {
                                              return Row(
                                                children: [
                                                  Text(
                                                    "Transaction type:",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                  ),
                                                  Radio(
                                                    value: "Credit",
                                                    groupValue: "$type",
                                                    onChanged: (value) {
                                                      mystate(() {
                                                        type = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Credit(+)",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Radio(
                                                    value: "Debit",
                                                    groupValue: "$type",
                                                    onChanged: (value) {
                                                      mystate(() {
                                                        type = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Debit(-)",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: t1,
                                            decoration: InputDecoration(
                                                hintText: "Amount"),
                                          ),
                                          TextFormField(
                                            controller: t2,
                                            decoration: InputDecoration(
                                                hintText: "Particular"),
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color: Colors.purple),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .purple.shade800),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (type == 'Credit') {
                                                      String insert =
                                                          "insert into records values(null,'${widget.m['id']}','${Date.text}','${t2.text}',${t1.text},0)";
                                                      Dashboard.database!
                                                          .rawInsert(insert);
                                                    } else if (type ==
                                                        "Debit") {
                                                      String insert =
                                                          "insert into records values(null,'${widget.m['id']}','${Date.text}','${t2.text}',0,${t1.text})";
                                                      Dashboard.database!
                                                          .rawInsert(insert);
                                                    }
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Add",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color: Colors.white),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .purple.shade800,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                  child: Text("Edit"),
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    record[index]['date'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    record[index]['particular'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${record[index]['credit']}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${record[index]['debit']}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
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
            ),
            FutureBuilder(
              future: fun(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    height: 75,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 2)
                    ]),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
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
                                        height: 10,
                                      ),
                                      Text("Credit"),
                                      Text((sum_credit[0]['sum(credit)'] !=
                                              null)
                                          ? " ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} ${sum_credit[0]['sum(credit)']}"
                                          : "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} 0")
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Debit"),
                                      Text((sum_debit[0]['sum(debit)'] != null)
                                          ? " ${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} ${sum_debit[0]['sum(debit)']}"
                                          : "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} 0")
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
                                        height: 10,
                                      ),
                                      Text(
                                        "Balance",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        (sum_credit[0]['sum(credit)'] != null &&
                                                sum_debit[0]['sum(debit)'] !=
                                                    null)
                                            ? "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} ${sum_credit[0]['sum(credit)'] - sum_debit[0]['sum(debit)']}"
                                            : "${password_page.preferences!.getString("cur_symbol") ?? '(₹)'} 0",
                                        style: TextStyle(color: Colors.white),
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
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(""),
                  );
                }
              },
            )
          ],
        ),
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Dashboard();
              },
            ),
          );
          return true;
        },
      ),
    );
  }
}
