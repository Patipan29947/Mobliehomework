//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
//import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/model/respone/customer_login_post_res.dart';
import 'package:flutter_application_1/register.dart';
import 'package:flutter_application_1/showtrip.dart';
//import 'package:flutter_application_1/showtrip.dart';
import 'package:http/http.dart' as http;

import 'model/request/csutomer_login_post_req.dart';



class loginPage extends StatefulWidget {
  loginPage({super.key, required String title});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String text = '';
  int number=0;
  var phoneCtl = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config){
      url = config['apiEndpoint'];
    },);
  }
  
  Object? get data => null;
  
   TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page'),),
      body: SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,   
              children: [
                Image.asset('assets/images/logo.png'),
                SizedBox(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("หมายเลขโทรศัพย์", style: TextStyle( fontSize: 20), ),
                      ),
                      TextField( decoration: InputDecoration( border: OutlineInputBorder()),keyboardType: TextInputType.phone,
                         controller: phoneNoCtl, 
                          ),
                
                      Padding(
                        padding: const EdgeInsets.only(top: 20,left: 8),
                        child: Text("รหัสผ่าน", style: TextStyle( fontSize: 20), ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(controller: passwordCtl,obscureText: true,decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 1))),),
                      ),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(onPressed: register, child: const Text('REGISTER')),
                            FilledButton(onPressed: () {login("admin","1234");} , child: const Text('LOOGIN')),
                        ]
                      
                        ),),
                      ),
                      Text('This is my page'),
                    ],
                ),)
              ],
             ),
        ),
      ),
    );
    
  }

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => registerpage(),));
    
    //log(text);
  }
  //http://10.160.158.218:3000
  void login(String username, String password) {
    log(phoneNoCtl.text);
    log(passwordCtl.text);
    //var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phoneNoCtl.text, password: passwordCtl.text);
    http
        .post(Uri.parse("$API_ENDPOINT/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req))
        .then(
      (value) {
        log(value.body);
        CustomerLoginPostResponse customerLoginPostResponse =
            customerLoginPostResponseFromJson(value.body);
        log(customerLoginPostResponse.customer.fullname);
        log(customerLoginPostResponse.customer.email);
        Navigator.push(context, MaterialPageRoute(builder: (context) => 
          showtrip(cid: customerLoginPostResponse.customer.idx),));
      },
    ).catchError((error) {
      log('Error $error');
    });
    //log('Hall world');
    
  }
  
}