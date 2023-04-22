import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phongs_app/data.dart';
import 'package:provider/provider.dart';

class AuthenView extends StatefulWidget {
  const AuthenView({Key? key}) : super(key: key);

  @override
  State<AuthenView> createState() => _AuthenViewState();
}

class _AuthenViewState extends State<AuthenView> {
  int state = 1;
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String passwordErrorText = '';
  String cfpasswordErrorText = '';

  late String email;
  late String password;

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
              child:
                  // state == 1 ? SignInView() : SignUpView()
                  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome Back',
                  style: GoogleFonts.bebasNeue(
                      fontWeight: FontWeight.bold, fontSize: 50)),
              const SizedBox(height: 10),
              Text('to Expense Tracker',
                  style: GoogleFonts.bebasNeue(fontSize: 25)),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: accountController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Your account',
                        // errorText: accountController
                      ),
                      onChanged: (val) {
                        print('ACCOUNT VALUE: $val');
                        email = val;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                          errorText: passwordErrorText.isNotEmpty
                              ? passwordErrorText
                              : null),
                      onChanged: (val) {
                        setState(() {
                          print('PASS VALUE: $val');
                          if (val.isEmpty) {
                            passwordErrorText = 'Please enter a password';
                          } else if (val.length < 5) {
                            passwordErrorText = 'Password is too short';
                          } else {
                            passwordErrorText = '';
                            password = val;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              state == 2
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 34),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Confirm password',
                                    errorText: cfpasswordErrorText.isNotEmpty
                                        ? cfpasswordErrorText
                                        : null),
                                onChanged: (val) {
                                  setState(() {
                                    if (val.isEmpty) {
                                      cfpasswordErrorText =
                                          'Please confirm your password';
                                    } else if (val != passwordController.text) {
                                      cfpasswordErrorText =
                                          'Unmatched password';
                                    } else {
                                      cfpasswordErrorText = '';
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: signIn_Up,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: state == 1
                          ? const Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          : const Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              state == 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (state == 1)
                                state = 2;
                              else
                                state = 1;
                            });
                          },
                          child: const Text(
                            ' Sign up now',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already an user?'),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (state == 1)
                                state = 2;
                              else
                                state = 1;
                            });
                          },
                          child: const Text(
                            ' Sign in here',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
              InkWell(
                onTap: () {
                  setState(() {
                    print('IS AUTH: ${Provider.of<Authen_Provider>(context, listen: false).isAuth}');
                  });
                },
                child: const Text(
                  ' debug',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
        ));
  }

  void signIn_Up() {
    if (state == 2) {
      try {
        Provider.of<Authen_Provider>(context, listen: false)
            .signUp(email, password)
            .catchError((err) {
          if (err.toString().contains('EMAIL_EXISTS')) {
            displaySnackBar('Email existed');
          } else if (err.toString().contains('INVALID_EMAIL')) {
            displaySnackBar('Invalid email address');
          } else if (err.toString().contains('WEAK_PASSWORD')) {
            displaySnackBar('Password is too weak');
          } else if (err.toString().contains('INVALID_PASSWORD')) {
            displaySnackBar('Incorrect password');
          } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
            displaySnackBar('Can not find any users using that email');
          }
        });
      } catch (err) {
        print('Cannot authenticate: $err');
      }
    } else {
      Provider.of<Authen_Provider>(context, listen: false)
          .signIn(email, password);
    }
  }

  void displaySnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        )));
  }
}
