import 'package:auth_buttons/auth_buttons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/app_routing.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {

    bool isLoading = false;

    final emailCont = TextEditingController();
    final passlCont = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    void NavigateRegister() {
      GoRouter.of(context).pushReplacement(AppRouter.KRegister);
    }

    void NavigateToHome() {
      GoRouter.of(context).pushReplacement(AppRouter.KHome);
    }

    Future signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null)
        {
          return;
        }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
       await FirebaseAuth.instance.signInWithCredential(credential);
      NavigateToHome();
    }

    Future<void> signIn(GlobalKey<FormState> _formKey, TextEditingController emailCont, TextEditingController passlCont, void NavigateToHome(), BuildContext context) async {

      if (_formKey.currentState!.validate()) {
        try {
            isLoading = true;
            setState(() {

            });
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailCont.text,
            password: passlCont.text,
          );

            isLoading = false;
            setState(() {

            });
          if( FirebaseAuth.instance.currentUser!.emailVerified)
          {
            NavigateToHome();
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: 'Verified ur Email',
            ).show();
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
          }
        } on FirebaseAuthException catch (e) {
          String errorMessage =
              'An error occurred. Please try again later.';
          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided for that user.';
          } else {
            errorMessage = e.message ?? errorMessage;
          }

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: errorMessage,
          ).show();
        } catch (e) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc:
            'An unexpected error occurred. Please try again later.',
          ).show();
        }
      }

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        title: Text('Login'),
        centerTitle: true,
        elevation: 0,
      ),


      body:SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Icon(Icons.library_books_rounded, size: 100),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: emailCont,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: passlCont,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_rounded),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ),


              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap:  () async
                    {

                      if(emailCont.text == ''){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Reser password',
                          desc: 'Please enter ur email',
                        ).show();
                        return;
                      }


                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailCont.text).then((value){
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Reser password',
                            desc: 'Reset Email has been sent , check ur email',
                          ).show();
                        });
                      }catch(e){
                      print(e);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Reser password',
                        desc: 'Please check ur data',
                      ).show();
                      }
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),




              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  await signIn(_formKey, emailCont, passlCont, NavigateToHome, context);
                },
                child: Text('Login'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(Size(300, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                ),
              ),



              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or Login With',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GoogleAuthButton(
                    onPressed: () {


                      signInWithGoogle();

                    },
                    style: AuthButtonStyle(
                      buttonType: AuthButtonType.icon,
                    ),
                  ),
                  FacebookAuthButton(
                    onPressed: () {},
                    style: AuthButtonStyle(
                      buttonType: AuthButtonType.icon,
                    ),
                  ),
                  AppleAuthButton(
                    onPressed: () {},
                    style: AuthButtonStyle(
                      buttonType: AuthButtonType.icon,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      NavigateRegister();
                    },
                    child: Text('Register'),
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
