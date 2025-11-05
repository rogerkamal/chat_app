
import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/domain/utils/app_routes.dart';
import 'package:chat_app/ui/signup/cubit/signup_cubit.dart';
import 'package:chat_app/ui/signup/cubit/signup_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignUpPage extends StatefulWidget {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/app_image/logo.png",height: 30,fit: BoxFit.contain,color: Colors.deepOrange,),
                SizedBox(width: 5,),
                Text('ChatApp',style: TextStyle(
                    color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold
                ),)
              ],
            ),

            SizedBox(height: 50),
            SizedBox(
              width: 350,
              height: 80,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  enabled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(
                    Icons.email,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 350,
              height: 80,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  enabled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(
                    Icons.abc,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 350,
              height: 80,
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: mobNoController,
                decoration: InputDecoration(
                  labelText: 'Mobile number',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  enabled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(
                    Icons.phone,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 350,
              height: 80,
              child: TextField(
                keyboardType: TextInputType.name,
                controller: genderController,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  enabled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(
                    Icons.man,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 350,
              height: 80,
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                obscureText: isPasswordVisible ? false : true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  filled: true,
                  fillColor: Colors.grey.shade100,

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

            SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 50,
              child: BlocConsumer<SignupCubit,SignupState>(
                  builder: (context, state){


                    return ElevatedButton(
                      onPressed: () async {
                        // Add your sign up logic here

                        if(nameController.text.toString().isEmpty ||
                            emailController.text.toString().isEmpty ||
                            passwordController.text.toString().isEmpty ||
                            mobNoController.text.toString().isEmpty ||
                            genderController.text.toString().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields"), backgroundColor: Colors.red,));
                          return;
                        }



                        String email = emailController.text.toString().trim();
                        String name = nameController.text.toString().trim();
                        String password = passwordController.text.toString().trim();
                        String gender = genderController.text.toString().trim();
                        String mobNo = mobNoController.text.toString().trim();
                        String profilePic = '';
                        int profileStatus = 1;
                        int status = 1;



                        var newUser = UserModel(name: name,
                            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                            email: email,
                            gender: gender,
                            isOnline: false,
                            mobNo: mobNo,
                            profilePic: profilePic,
                            profileStatus: profileStatus,
                            status: status);

                        BlocProvider.of<SignupCubit>(context).signupUser(newUser, password);


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
                          CircularProgressIndicator(color: Colors.white,),
                          SizedBox(width: 10,),
                          Text(
                            'Signing up...',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ) : Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );

                  },
                  listener: (context, state){

                    if(state is SignupFailedState){
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg)));
                    }

                    if(state is SignupLoadingState){
                      isLoading = true;
                    }

                    if(state is SignupSuccessState){
                      Navigator.pop(context);
                    }


                  })
            ),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container(height: 1, width: double.infinity, color: Colors.grey)),
                Text(
                  '  OR  ',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
                ),
                Expanded(child: Container(height: 1, width: double.infinity, color: Colors.grey)),
              ],
            ),

            SizedBox(height: 40),

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
                  'Sign up with Gmail',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ", // default text
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),

                TextButton(
                  onPressed: () {
                   Navigator.pop(context);
                  },
                  child: Text(
                    'Log in',
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
    );
  }
}
