import 'package:chat_app/domain/utils/app_constants.dart';
import 'package:chat_app/domain/utils/app_routes.dart';
import 'package:chat_app/ui/login/cubit/login_cubit.dart';
import 'package:chat_app/ui/login/cubit/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isLogin = false;
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 120),

              Image.asset("assets/app_image/logo.png",height: 30,fit: BoxFit.contain,color: Colors.deepOrange),

              SizedBox(height: 10),
              Text('ChatApp',style: TextStyle(
                  color: Colors.deepOrange,fontSize: 25,
              )),

              SizedBox(height: 30),
              Container(
                width: 350,
                height: 80,
                child: TextFormField(
                  validator: (value){
                    RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                    if(value == null || value.isEmpty){
                      return 'Please enter email here..';
                    } else if(!emailRegex.hasMatch(value)) {
                      return 'Please enter valid email';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.yellow.shade50,
                    enabled: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      CupertinoIcons.profile_circled,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              Container(
                width: 350,
                height: 80,
                child: TextFormField(
                  validator: (value){

                    if(value == null || value.isEmpty){
                      return 'Please enter password here..';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: isPasswordVisible ? false : true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.yellow.shade50,
                    enabled: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: InkWell(
                      onTap: (){
                        isPasswordVisible = !isPasswordVisible;
                        setState(() {});
                      },
                      child: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Container(
                width: 350,
                height: 50,
                child: BlocConsumer<LoginCubit,LoginState>(
                    builder: (context, state){
                      return ElevatedButton(
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            isLogin = true;

                            String email = emailController.text.toString().trim();
                            String pass = passwordController.text.toString().trim();

                            BlocProvider.of<LoginCubit>(context).authenticateUser(email: email, pass: pass);

                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// true ? Widget1 : Widget2
                            CircularProgressIndicator(color: Colors.white,),
                            SizedBox(width: 10,),
                            Text(
                              'Logging in...$isLoading',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ) :Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    listener: (context,state){
                      if(state is LoginLoadingState){
                        isLoading = true;
                      }

                      if(state is LoginFailureState){
                        isLoading = false;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg)));
                      }

                      if(state is LoginSuccessState){
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    }),
              ),

              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(height: 1, width: 130, color: Colors.grey),
                  Text(
                    'OR',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
                  ),
                  Container(height: 1, width: 130, color: Colors.grey),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/app_image/gmail.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Log in with Gmail',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),

              SizedBox(height: 60),

              Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),

              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?", // default text
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),

                  TextButton(
                    onPressed: () {
                      isLogin = false;
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
