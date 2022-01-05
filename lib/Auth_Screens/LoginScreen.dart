import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:payments/Auth_Screens/BackGround.dart';
import 'package:payments/Auth_Screens/Register_Screen.dart';
import 'package:payments/Helpers/constants.dart';
import 'package:payments/Views/Bottomnavigator.dart';
import 'package:payments/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert' as JSON;


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonenumberController = TextEditingController();
  var _Kpassword = 123456890;
  bool _isLoading =false;
  var custom;
  var otp;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var maxLength = 10;
  var textLength = 0;
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
          child: BackGround(
              title:"LogIn",
              child:_isLoading?
              Center(child: SpinKitFadingCircle(color: Colors.green,size: 60,),):
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: _visible?Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Text("Enter OTP :",style: TxtStls.headlistl),
                    SizedBox(height:size.height*0.01),
                    OtpPinField(
                      otpPinFieldInputType: OtpPinFieldInputType.none,
                      otpPinInputCustom: "\$",
                      onSubmit: (pin) {
                        setState(() {
                          otp = pin;
                        });
                      },
                      otpPinFieldStyle: OtpPinFieldStyle(
                        defaultFieldBorderColor: fieldClr,
                        activeFieldBorderColor: Colors.green,
                        defaultFieldBackgroundColor: fieldClr,
                        activeFieldBackgroundColor: fieldClr,
                      ),
                      maxLength: 6,
                      highlightBorder: true,
                      fieldWidth: size.width*0.11,
                      fieldHeight: size.height*0.05,
                      keyboardType: TextInputType.phone,
                      autoFocus: false,
                      otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration,

                    ),
                    SizedBox(height:size.height*0.02),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:
                            btnColor,
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    10.0))),
                        child: Text(
                          "Verify",
                          style: TxtStls.txtStl2,
                        ),
                      ),
                      onTap: () {
                        verify(custom, otp,_phonenumberController.text.toString(),_Kpassword.toString());
                      },
                    ),
                  ],
                ):
                Form(
                  key:_formKey,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Text("Phone Number",
                          style: TxtStls.headlistl),
                      Card(
                        elevation:2,
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
                      SizedBox(height:size.height*0.02),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:
                              btnColor,
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      10.0))),
                          child: Text(
                            "Request OTP",
                            style: TxtStls.txtStl2,
                          ),
                        ),
                        onTap: () {
                          phoneLogin(_phonenumberController.text.toString(),_Kpassword.toString());
                        },
                      ),
                      SizedBox(height:size.height*0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: TxtStls.txtStl,
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register",
                                    style: TxtStls.rtxtStl,
                                    recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    RegisterScreen()));
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

  Future<void> phoneLogin(_phone, _password)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading =true;
      });
      GotrueSessionResponse gotrueSessionResponse = await supabase.auth.signIn(phone:_phone,password: _password);
      if(gotrueSessionResponse.user?.phone != null){
        supabase.auth.signOut();
        sendOtp(_phone);
        setState(() {
          _isLoading=false;
          _visible = true;
        });
      }
      else{
        setState(() {
          _isLoading = false;
        });
        final snackBar = SnackBar(backgroundColor:Colors.red,content: Text("${gotrueSessionResponse.error?.message}",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }

  sendOtp(_phone) async {
    Uri url =
        Uri.parse("https://2factor.in/API/V1/b9a8728c-3b6b-11ea-9fa5-0200cd936042/SMS/$_phone/AUTOGEN");
    Response response = await get(url);
    Map<String, String> headers = response.headers;
    var parsedJson = JSON.jsonDecode(response.body.toString());
    var name = parsedJson['Status'];
    var alias = parsedJson['Details'];
    setState(() {
      custom =alias;
    });
    if(name == "Success"){
      final snackBar = SnackBar(backgroundColor:Colors.green,content: Text("Otp sends to $_phone successfully",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  verify(cus,pin,_phone,_password)async{
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Uri verifyurl = Uri.parse("https://2factor.in/API/V1/b9a8728c-3b6b-11ea-9fa5-0200cd936042/SMS/VERIFY/$cus/$pin");
    Response response = await get(verifyurl);
    Map<String, String> headers = response.headers;
    var parsedJson = JSON.jsonDecode(response.body.toString());
    var name = parsedJson['Status'];
    if(name == "Success"){
      GotrueSessionResponse response = await supabase.auth.signIn(phone:_phone ,password:_password);
      if(response.data != null){
        setState((){
          var p = response.data?.user?.phone.toString();
          var i = response.data?.user?.id.toString();
          preferences.setString("phone", p!);
          preferences.setString("uuid", i!);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomnavigatorScreen()));
          final snackBar = SnackBar(backgroundColor:Colors.green,content: Text("Login Successfully",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _isLoading = false;
        });
      }
    }
    if(name == "Error"){
      setState(() {
        _isLoading = false;
      });
      final snackBar = SnackBar(backgroundColor:Colors.red,content: Text("Login Failed",style: TxtStls.txtStl2),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
