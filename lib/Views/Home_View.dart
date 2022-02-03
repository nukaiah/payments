import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:payments/Helpers/UserModel.dart';
import 'package:payments/Helpers/constants.dart';
import 'package:payments/main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _razorpay = Razorpay();
  var options;
  var textLength = 0;
  final TextEditingController _payamountController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _amtController = TextEditingController();
  var textLength1 = 0;
  bool isLoad = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
    fetchCurrealace();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  opeChe() {
    var options = {
      'key': 'rzp_live_hsys1peRF0djXT',
      'amount': num.parse(_payamountController.text) * 100 +
          (num.parse(_payamountController.text) / 100) * 200,
      'name': 'SnaggerIndia',
      'description': 'Pay Secure',
      'prefill': {'contact': "", 'email': ""},
    };
    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("sri..................");
    print(response.orderId);
    print("sri..................");
    addData();
    fetchCurrealace();
    success(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _payamountController.clear();
      textLength = 0;
    });
    fail(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final snackBar = SnackBar(content: Text(response.walletName.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _payamountController.clear();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoad
        ? Scaffold(
            body: Stack(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  elevation: 0.0,
                  title: Column(
                    children: [
                      Text(
                        "Hey !",
                        style: TxtStls.titlestl1,
                      ),
                      username == null
                          ? Text("...", style: TxtStls.titlestl1)
                          : Text(username.toString(), style: TxtStls.titlestl1),
                    ],
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  toolbarHeight: size.height * 0.3,
                  flexibleSpace: Container(
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(60)),
                        gradient: LinearGradient(colors: [
                          Colors.blue,
                          Colors.purple.withOpacity(0.9)
                        ])),
                  ),
                  actions: [
                    role == "Admin"
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isLoad = !isLoad;
                              });
                            },
                            icon: Icon(Icons.payment_outlined, color: bgClr))
                        : SizedBox()
                  ],
                ),
                Positioned(
                  top: size.height * 0.235,
                  left: size.width / 4,
                  right: size.width / 4,
                  child: Card(
                    elevation: 1,
                    child: SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Current Balance :",
                            style: TxtStls.txtStl,
                          ),
                          cbal == null
                              ? Text(
                                  "₹ 0",
                                  style: TxtStls.txtStl,
                                )
                              : Text(
                                  "₹ ${cbal}",
                                  style: TxtStls.txtStl,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.4,
                  left: size.width * 0.07,
                  right: size.width * 0,
                  child: Text("Enter amount to pay :", style: TxtStls.titlestl),
                ),
                Positioned(
                  top: size.height * 0.43,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                        padding: EdgeInsets.only(
                            left: size.width * 0.1,
                            right: size.width * 0.1,
                            top: size.height * 0.002),
                        alignment: Alignment.center,
                        width: size.width * 0.9,
                        height: size.height * 0.075,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: _payamountController,
                          style: TxtStls.txtStl,
                          decoration: InputDecoration(
                            hintText: "Enter amount",
                            hintStyle: TxtStls.txtStl,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              textLength = value.length;
                            });
                          },
                        )),
                  ),
                ),
                textLength <= 0
                    ? SizedBox()
                    : Positioned(
                        top: size.height * 0.55,
                        left: size.width * 0.35,
                        right: size.width * 0.35,
                        child: MaterialButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "Tap To Pay",
                            style: TxtStls.txtStl2,
                          ),
                          onPressed: () {
                            //opeChe();
                            _showMyDialog1(context);
                          },
                        ),
                      )
              ],
            ),
            floatingActionButton: cbal == null || cbal <= 0
                ? SizedBox()
                : FloatingActionButton(
                    elevation: 0,
                    tooltip: "Request Withdraw",
                    backgroundColor: Colors.pink,
                    onPressed: () {
                      _showMyDialog(context);
                    },
                    child: Icon(Icons.request_page),
                  ))
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Colors.grey.withOpacity(0.1),
              elevation: 0.0,
              title: Text(
                "Payment",
                style: TxtStls.titlestl1,
              ),
              systemOverlayStyle: SystemUiOverlayStyle.light,
              toolbarHeight: size.height * 0.25,
              flexibleSpace: Container(
                height: size.height * 0.3,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(60)),
                    gradient: LinearGradient(colors: [
                      Colors.pinkAccent,
                      Colors.black.withOpacity(0.9)
                    ])),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isLoad = !isLoad;
                      });
                    },
                    icon: Icon(Icons.cancel, color: bgClr))
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    field(_uidController, "Enter Phone Number", (value) {}),
                    field(_amtController, "Enter Amount", (value) {}),
                    MaterialButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Text('Pay', style: TxtStls.txtStl2),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            addData1();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future fetchUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    PostgrestResponse postgrestResponse = await supabase
        .from("Users")
        .select()
        .eq("uuid", uuid)
        .single()
        .execute();
    if (postgrestResponse.error == null) {
      phone = postgrestResponse.data['phone'];
      username = postgrestResponse.data['name'];
      date = postgrestResponse.data['date'];
      time = postgrestResponse.data['time'];
      acno = postgrestResponse.data['a/cno'];
      bankname = postgrestResponse.data['bankname'];
      ifsccode = postgrestResponse.data['ifsccode'];
      role = postgrestResponse.data['role'];
      pl = postgrestResponse.data["earnings"];
    }
  }

  Future addData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    PostgrestResponse postgrestResponse = await supabase
        .from("Transactions")
        .insert({
          "date": DateTime.now().toString().split(" ")[0],
          "time": DateTime.now().toString().split(" ")[1],
          "uuid": uuid,
          "trans": "+${_payamountController.text}",
          "type": "Credit"
        })
        .execute()
        .whenComplete(() {
          setState(() {
            _payamountController.clear();
            textLength = 0;
          });
        });
  }

  Future addData1() async {
    PostgrestResponse postgrestResponse1 = await supabase
        .from("Users")
        .select()
        .eq("phone", _uidController.text)
        .single()
        .execute();
    if (postgrestResponse1.error == null) {
      print(postgrestResponse1.data["uuid"]);
      Future.delayed(Duration(milliseconds: 10)).then((value)async {
        PostgrestResponse postgrestResponse =
        await supabase.from("Transactions").insert({
      "date": DateTime.now().toString().split(" ")[0],
      "time": DateTime.now().toString().split(" ")[1],
      "uuid": postgrestResponse1.data["uuid"],
      "trans": "-${_amtController.text}",
      "type": "Debit"
    }).execute();
    if (postgrestResponse.error == null) {
      _uidController.clear();
      _amtController.clear();
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text("Paid Successfully", style: TxtStls.txtStl2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Failed! Try Again", style: TxtStls.txtStl2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
      });
    } else {
      print(postgrestResponse1.error);
    }
  }

  Future fetchCurrealace() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    PostgrestResponse postgrestResponse =
        await supabase.from("Transactions").select().eq("uuid", uuid).execute();
    var d = postgrestResponse.data;
    setState(() {
      var abal = d.map((m) => (m["trans"])).reduce((a, b) => a + b);
      cbal = abal + pl;
      print(cbal);
    });
  }

  Widget txtCard(ctrl) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
          padding: EdgeInsets.only(
              left: size.width * 0.1,
              right: size.width * 0.1,
              top: size.height * 0.002),
          alignment: Alignment.center,
          width: size.width * 0.9,
          height: size.height * 0.075,
          child: TextFormField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: ctrl,
            style: TxtStls.txtStl,
            decoration: InputDecoration(
              hintText: "Enter amount",
              hintStyle: TxtStls.txtStl,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                textLength = value.length;
              });
            },
          )),
    );
  }

  Future<void> raiseRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uuid = sharedPreferences.getString("uuid");
    PostgrestResponse response = await supabase.from("WRequests").insert({
      "date": DateTime.now().toString().split(" ")[0],
      "time": DateTime.now().toString().split(" ")[1],
      "uuid": uuid,
      "amount": cbal,
      "phone": phone,
      "name": username,
      "a/cno": acno,
      "ifsccode": ifsccode,
      "bankname": bankname,
    }).execute();
    if (response.error == null) {
      print(response.data);
      requestSuccess(context);
    }
  }

  Future<void> success(context) async {
    return showDialog<void>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/success.json", reverse: true),
              Text('Payment Done Successfully', style: TxtStls.titlestl),
            ],
          ),
        );
      },
    );
  }

  Future<void> fail(context) async {
    return showDialog<void>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/failed.json", reverse: true),
              Text('Last Transaction Failed!', style: TxtStls.titlestl),
            ],
          ),
        );
      },
    );
  }

  Future<void> requestSuccess(context) async {
    return showDialog<void>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/raiserequest.json",
                  reverse: true, height: 100),
              Text('Submitted Successfully', style: TxtStls.titlestl),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog1(context) async {
    return showDialog<void>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        num a = num.parse(_payamountController.text);
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 40),
          title: Text('Pay', style: TxtStls.titlestl),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount", style: TxtStls.titlestl),
                Text("₹ " + a.toString(), style: TxtStls.titlestl)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("add", style: TxtStls.titlestl),
                Text("₹ ${(a / 100) * 2}", style: TxtStls.titlestl)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SubTotal", style: TxtStls.titlestl),
                Text("₹ ${a + (a / 100) * 2}", style: TxtStls.titlestl),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text('Cancel', style: TxtStls.txtStl2),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text('Pay', style: TxtStls.txtStl2),
                  onPressed: () {
                    opeChe();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Do you want withdrawl Rs.$cbal ?', style: TxtStls.titlestl),
          actions: <Widget>[
            MaterialButton(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Text('Cancel', style: TxtStls.txtStl2),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Text('Yes', style: TxtStls.txtStl2),
              onPressed: () {
                setState(() {
                  raiseRequest();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget field(controller, hint, callack) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        decoration: deco,
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 2),
          child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: controller,
              style: TxtStls.txtStl,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TxtStls.txtStl,
                border: InputBorder.none,
              ),
              validator: callack),
        ),
      ),
    );
  }
}
