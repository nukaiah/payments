import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:payments/Auth_Screens/BackGround.dart';
import 'package:payments/Auth_Screens/LoginScreen.dart';
import 'package:payments/Helpers/constants.dart';
import 'package:payments/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _banknameController = TextEditingController();
  final TextEditingController _acnoController = TextEditingController();
  final TextEditingController _ifsccodeController = TextEditingController();

  var _Kpassword = 123456890;

  bool _isLoading = false;

  var maxLength = 10;
  var textLength = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: BackGround(
            title:"SignUp",
            child:Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: _isLoading?Center(child: SpinKitFadingCircle(color: Colors.green,size: 60.0,)):Form(
                key:_formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Full Name",
                        style: TxtStls.headlistl),
                    field(_usernameController, "Enter your name", (fullname) {
                      if (fullname!.isEmpty) {
                        return "Name can not be empty";
                      } else if (fullname.length < 3) {
                        return "Name should be atleast 3 letters";
                      } else {
                        return null;
                      }
                    },),

                    Text("Phone Number",
                        style: TxtStls.headlistl),

                    Card(
                      elevation: 2,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Container(
                        decoration: deco,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 2),
                          child: TextFormField(

                            keyboardType: TextInputType.number,
                            maxLength: maxLength,
                            controller: _phonenumberController,
                            style: TxtStls.txtStl,
                            decoration: InputDecoration(
                              suffixText:
                              '${textLength.toString()}/${maxLength.toString()}',
                              counterText: "",
                              hintText: "Phone Number",
                              hintStyle: TxtStls.txtStl,
                              border: InputBorder.none,
                            ),
                            validator: (phoneNumber) {
                              String patttern =
                                  r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = RegExp(patttern);
                              if (phoneNumber!.isEmpty) {
                                return "Phone Number can not be empty";
                              } else if (phoneNumber.length <
                                  10 ||
                                  phoneNumber.length > 10) {
                                return "Enter valid Phone Number";
                              } else if (!regExp
                                  .hasMatch(phoneNumber)) {
                                return "Only numbers are allowed";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                textLength = value.length;
                              });
                            },
                          ),
                        ),
                      ),),
                    Text("Bank Name",
                        style: TxtStls.headlistl),
                    field(_banknameController, "Enter Bank name", (fullname) {
                      if (fullname!.isEmpty) {
                        return "Bank Name can not be empty";
                      } else if (fullname.length < 3) {
                        return "Enter a valid Bank Name";
                      } else {
                        return null;
                      }
                    },),

                    Text("Account Number",
                        style: TxtStls.headlistl),
                    Card(
                      elevation: 2,
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
                              } else if (fullname.length < 6) {
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
                    field(_ifsccodeController,"Enter IFSC CODE",(fullname) {
                      if (fullname!.isEmpty) {
                        return "IFSC code can not be empty";
                      } else if (fullname.length < 3) {
                        return "Enter valid IFSC code";
                      } else {
                        return null;
                      }
                    },),

                    SizedBox(height:size.height*0.01),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:
                            btnColor,

                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    10.0))),
                        child: Text(
                          "Create Account",
                          style: TxtStls.txtStl2,
                        ),
                      ),
                      onTap: () {
                        phoneRegister(_phonenumberController.text.toString(),_Kpassword.toString(),_usernameController.text.toString(),_acnoController.text.toString(),_ifsccodeController.text.toString(),_banknameController.text.toString());
                      },
                    ),
                    SizedBox(height:size.height*0.01),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                            text: "Already have an account? ",
                            style: TxtStls.txtStl,
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Log in",
                                  style: TxtStls.rtxtStl,
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  LoginScreen()));
                                    })
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      )
    );
  }
  Future<void> phoneRegister(_phone,_password,_name,acno,ifsccode,bankname)async{
    if(_formKey.currentState!.validate()){
      setState(()=>_isLoading=true);
      GotrueSessionResponse gotrueSessionResponse  = await supabase.auth.signUpWithPhone(_phone, _password);
      if(gotrueSessionResponse.user?.id != null){
        PostgrestResponse response = await supabase.from("Users").insert({
          "date":DateTime.now().toString().split(" ")[0],
          "time":DateTime.now().toString().split(" ")[1],
          "uuid":gotrueSessionResponse.user?.id,
          "phone":gotrueSessionResponse.user?.phone,
          "name":_name,
          "a/cno":acno,
          "ifsccode":ifsccode,
          "bankname":bankname,
          "role":"User",
          "earnings":0,
        }).execute();
        if(response.error == null){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
          setState(()=>_isLoading=false);
          _banknameController.clear();
          _ifsccodeController.clear();
          _acnoController.clear();
          _usernameController.clear();
          _phonenumberController.clear();
          final snackBar = SnackBar(backgroundColor:Colors.green,content: Text("Registered Successfully",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      else{
        setState(() {
          _isLoading=false;
        });
        final snackBar = SnackBar(backgroundColor:Colors.red,content: Text("${gotrueSessionResponse.error?.message}",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget field(controller,hint,callack){
    return Card(
      elevation: 2,
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        decoration: deco,
        child: Padding(
          padding: EdgeInsets.only(
              left:15, right: 15, top: 2),
          child: TextFormField(

            controller: controller,
            style: TxtStls.txtStl,
            decoration: InputDecoration(

              hintText: hint,
              hintStyle: TxtStls.txtStl,
              border: InputBorder.none,
            ),
            validator: callack
          ),
        ),
      ),);
  }
}


