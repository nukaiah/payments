import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:payments/Helpers/constants.dart';
import 'package:payments/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionlistScreen extends StatefulWidget {
  @override
  _TransactionlistScreenState createState() => _TransactionlistScreenState();
}

class _TransactionlistScreenState extends State<TransactionlistScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
        appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: bgClr,
        elevation: 0.0,
        title: Text("My Transactions",style: TxtStls.titlestl1),
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
        body: Container(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color:bgClr,
                padding: EdgeInsets.only(left: size.width*0.05),
                width: size.width,
                height: size.height*0.05,
                child: Row(
                  children: [
                    Icon(Icons.list,color: txtClr),
                    Text("Recent Transactions",style: TxtStls.txtStl,)
                  ],
                ),
              ),
              Expanded(
                  child:FutureBuilder(
                    future:fetchtrans(),
                    builder: (context, AsyncSnapshot snapshot){

                      if(!snapshot.hasData){
                        return Center(
                          child: SpinKitFadingCircle(size: 50,color: Colors.green,),
                        );
                      }
                      return ListView.builder(
                        itemCount:snapshot.data.length,
                        itemBuilder: (context,index){
                          String t = snapshot.data[index]["date"];
                          String t1 = snapshot.data[index]["time"];
                          String type = snapshot.data[index]["type"];
                          var at = DateTime.parse(t);
                          var at1 = DateTime.parse(t+"T"+t1);
                          var dt = DateFormat("EEE | MMM dd , yyyy").format(at).toString();
                          var dt1 = DateFormat("hh:MM a").format(at1).toString();
                          return Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.005),
                              width: size.width,
                                 child:ListTile(
                                   tileColor: bgClr,
                                   leading: Container(
                                       width: size.width*0.15,
                                       height: size.height*0.09,
                                       decoration: BoxDecoration(
                                         color:type=="Credit"?Colors.green:Colors.red,
                                         borderRadius: BorderRadius.all(Radius.circular(15)),
                                       ),
                                       child: Transform.rotate(
                                         angle: type=="Credit"?-90/4:112.5,
                                         child: Icon(Icons.arrow_right_alt_rounded,color:bgClr,size: 40,),
                                       )
                                     ),

                                   title: Text(type=="Credit"?"Deposit":"WithDrawl",style: TxtStls.titlestl),
                                   trailing: Wrap(
                                     children: [
                                       Text(type=="Credit"?"+":"",style: TxtStls.txtStl),
                                   Text("${snapshot.data[index]["trans"].toString()}",style: TxtStls.txtStl)
                                     ],
                                   ),
                                   subtitle: Text(dt+", "+dt1.toString(),style: TxtStls.txtStl,),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                  ),
                          );
                        },
                      );
                    },
                  ),
              )
            ],
          ),
        )
    );
  }

  fetchtrans()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var uuid = preferences.getString("uuid");
    PostgrestResponse postgrestResponse = await supabase.from("Transactions").select().eq("uuid", uuid).order("id",ascending: false).execute();
    List datalist = postgrestResponse.data as List;
    return datalist;
  }

  final _list = ["All","Deposits","WithDrawls"];
  var activeid = "All";

  Widget trastype(e){
    return Padding(padding: EdgeInsets.all(5.0),child: MaterialButton(
      color: activeid == e?btnColor:Colors.grey,
      elevation:10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Text(e,style: activeid==e?TxtStls.txtStl2:TxtStls.txtStl),
      onPressed: (){
        activeid = e;
        setState(() {});
      },
    ),);
  }
}
