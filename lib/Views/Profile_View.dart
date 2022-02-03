import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:payments/Auth_Screens/LoginScreen.dart';
import 'package:payments/Helpers/constants.dart';
import '../Helpers/UserModel.dart';
import 'package:payments/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _banknameController = TextEditingController();
  final TextEditingController _ifsccodeController = TextEditingController();
  final TextEditingController _acnoController = TextEditingController();
  bool isUpdate = false;
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    Size size = MediaQuery.of(context).size;
    DateTime dateTime = DateTime.parse(date!);
    var dt = DateFormat('EEEE | MMM dd , yyyy').format(dateTime);
    DateTime dateTime1 = DateTime.parse("${date!+"T"+time!}");
    var dt1 = DateFormat('hh:MM a').format(dateTime1);
    return isUpdate?
    Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: bgClr,
        elevation: 0.0,
        title: Text("Update Profile",style: TxtStls.titlestl1),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: size.height*0.2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(60))
        ),
        flexibleSpace: Container(
          height: size.height*0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
              gradient: LinearGradient(
                  colors: [Colors.indigo,Colors.black.withOpacity(0.9)]
              )

          ),
        ),
      ),
      body: isLoad?Center(child: SpinKitFadingCircle(size: 60,color: Colors.green),):Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.05),
          child:SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bank Name",
                      style: TxtStls.headlistl),
                  Card(
                    elevation:1,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      decoration: deco,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:15, right: 15, top: 2),
                        child: TextFormField(
                          controller: _banknameController,
                          style: TxtStls.txtStl,
                          decoration: InputDecoration(
                            hintText: "Enter Bank name",
                            hintStyle: TxtStls.txtStl,
                            border: InputBorder.none,
                          ),
                          validator: (fullname) {
                            if (fullname!.isEmpty) {
                              return "Bank Name can not be empty";
                            } else if (fullname.length < 3) {
                              return "Enter valid Bank Name";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),),
                  Text("Account Number",
                      style: TxtStls.headlistl),
                  Card(
                    elevation:1,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      decoration: deco,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:15, right: 15, top: 2),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _acnoController,
                          style: TxtStls.txtStl,
                          decoration: InputDecoration(
                            hintText: "Enter Account Number",
                            hintStyle: TxtStls.txtStl,
                            border: InputBorder.none,
                          ),
                          validator: (fullname) {
                            if (fullname!.isEmpty) {
                              return "Account Number can not be empty";
                            } else if (fullname.length < 3) {
                              return "Enter a valid Account Number";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),),
                  Text("IFSC CODE",
                      style: TxtStls.headlistl),
                  Card(
                    elevation:1,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      decoration: deco,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:15, right: 15, top: 2),
                        child: TextFormField(
                          controller: _ifsccodeController,
                          style: TxtStls.txtStl,
                          decoration: InputDecoration(
                            hintText: "Enter IFSC CODE",
                            hintStyle: TxtStls.txtStl,
                            border: InputBorder.none,
                          ),
                          validator: (fullname) {
                            if (fullname!.isEmpty) {
                              return "IFSC CODE can not be empty";
                            } else if (fullname.length < 3) {
                              return "Enter a valid IFSC CODE";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),),
                  SizedBox(height: size.height*0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        child: Text('Cancel', style: TxtStls.txtStl2),
                        onPressed: () {

                          setState(() {
                            isUpdate=false;
                          });
                        },
                      ),
                      MaterialButton(
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),

                        child: Text('Update', style: TxtStls.txtStl2),
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            setState(() { update();});
                          };
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    ):
    Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: bgClr,
        elevation: 0.0,
        title: Text("My Profile",style: TxtStls.titlestl1),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: size.height*0.2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(60))
        ),
        flexibleSpace: Container(
          height: size.height*0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
              gradient: LinearGradient(

                  colors: [Colors.pinkAccent,Colors.purple.withOpacity(0.9)]

              )

          ),
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isUpdate = true;
            });

          }, icon: Icon(Icons.settings))
        ],
      ),
      body:ody(dt,dt1),


    );
  }


  Widget ody(dt,dt1){
    Size size = MediaQuery.of(context).size;
    if(username == null){
      return SpinKitFadingCircle(color: Colors.green,size: 60);
    }
    return Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.05),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txtCard(Icons.person,username),
            txtCard(Icons.call,phone),
            txtCard(Icons.account_box_outlined,bankname),
            txtCard(Icons.account_balance_rounded,acno),
            txtCard(Icons.code,ifsccode),
            txtCard(Icons.calendar_today,dt+" At:"+dt1),
            InkWell(
              child:  Card(
                elevation:1,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Container(
                  decoration: deco,
                  width: size.width,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:size.width*0.05, vertical:size.height*0.025),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Logout",
                              style: TxtStls.titlestl),Icon(Icons.exit_to_app_outlined)
                        ],
                      )

                  ),
                ),),
              onTap: (){
                _showMyDialog(context);
              },
            ),
          ],
        )
    );
  }

  Widget txtCard(i,e){
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation:1,
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        decoration: deco,
        width: size.width,
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:size.width*0.05, vertical:size.height*0.025),
            child:Row(
              children: [
                Icon(i),
                SizedBox(width: size.width*0.02),
                e==null?Text("...",style: TxtStls.titlestl1):Text(e,style: TxtStls.txtStl),
              ],
            )

        ),
      ),);
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          Text('Are you sure to Logout ?', style: TxtStls.titlestl),
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

              child: Text('Logout', style: TxtStls.txtStl2),
              onPressed: () {
                Logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future Logout()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    GotrueResponse response = await supabase.auth.signOut();
    if(response.error == null){
      preferences.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginScreen()),(route)=>false);
    }
    else{
      print(response.error?.message);
    }
  }
  Future update()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    setState(() {
      isLoad  = true;
    });
    PostgrestResponse postgrestResponse = await supabase.from("Users").update(
        {
          "a/cno":_acnoController.text,
          "ifsccode":_ifsccodeController.text,
          "bankname":_banknameController.text,
        }).match({"uuid":uuid}).execute();

    if(postgrestResponse.error == null){
      setState(() {
        isLoad = false;
        isUpdate = false;
        _acnoController.clear();
        _ifsccodeController.clear();
        _banknameController.clear();
        final snackBar = SnackBar(backgroundColor:Colors.green,content: Text("Account Details updated Successfully",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
    else{
      setState(() {
        isLoad = false;
      });
      final snackBar = SnackBar(backgroundColor:Colors.green,content: Text("Failed to update Details updated! Try Again",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

