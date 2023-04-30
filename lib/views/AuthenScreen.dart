import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/AuthenProvider.dart';

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

  String? accountErrorText;
  String? passwordErrorText;
  String? cfpasswordErrorText;

  late String email;
  late String password;

  bool accountValid = false;
  bool passwordValid = false;
  bool cfPasswordValid = false;

  bool canSignIn = false;
  bool canSignUp = false;

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
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Back',
                style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.bold, fontSize: 50)),
            const SizedBox(height: 5),
            Text('to Expense Tracker',
                style: GoogleFonts.bebasNeue(fontSize: 25)),
            // state == 1 ? SignInView() : SignUpView(),
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Your account',
                      errorText: accountErrorText,
                    ),
                    onChanged: (val) {
                      accountValid = checkValidAccount(val);
                      if (accountValid && passwordValid) {
                        setState(() {
                          canSignIn = true;
                        });
                        if (cfPasswordValid) {
                          setState(() {
                            canSignUp = true;
                          });
                        }
                      } else {
                        setState(() {
                          canSignIn = false;
                          canSignUp = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                        errorText: passwordErrorText),
                    onChanged: (val) {
                      passwordValid = checkValidPassword(val);
                      if (accountValid && passwordValid) {
                        setState(() {
                          canSignIn = true;
                        });
                        if (cfPasswordValid) {
                          setState(() {
                            canSignUp = true;
                          });
                        }
                      } else {
                        setState(() {
                          canSignIn = false;
                          canSignUp = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            state == 2
                ? Padding(
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
                                errorText: cfpasswordErrorText),
                            onChanged: (val) {
                              cfPasswordValid = checkValidCFPassword(val);
                              if (accountValid &&
                                  passwordValid &&
                                  cfPasswordValid) {
                                setState(() {
                                  canSignUp = true;
                                });
                              } else {
                                setState(() {
                                  canSignUp = false;
                                });
                              }
                            },
                          ),
                        )))
                : const SizedBox(height: 0),
            const SizedBox(height: 90),
            getButton(),
            const SizedBox(height: 15),
            state == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      InkWell(
                        onTap: () {
                          accountController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                          setState(() {
                            state = 2;
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
                          accountController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                          setState(() {
                            state = 1;
                          });
                        },
                        child: const Text(
                          ' Sign in',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
            // InkWell(
            //   onTap: () {
            //     Provider.of<Authen_Provider>(context, listen: false).signIn('a@gmail.com', '111111');
            //   },
            //   child: const Text(
            //     'DEBUG',
            //     style: TextStyle(
            //         color: Colors.blueAccent, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const SizedBox(height: 40),
          ],
        )));
  }

  void signIn_Up() {
    if (state == 1 && canSignIn) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signing In'), duration: Duration(seconds: 1)));
      Provider.of<Authen_Provider>(context, listen: false)
          .signIn(email, password)
          .then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('SignIn Complete')));
      }).catchError((err) {
        print(err);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('SignIn Failed')));
      });
    }
    if (state == 2 && canSignUp) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signing Up')));
      print('Can sign up: $canSignUp');
      try {
        Provider.of<Authen_Provider>(context, listen: false)
            .signUp(email, password)
            .catchError((err) {
          displaySnackBar('Sign up FAILED');
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
        setState(() {
          state == 1; //go back to SignIn view
        });
      } catch (err) {
        print('Cannot authenticate: $err');
      }
    }
  }

  void displaySnackBar(String text) {
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

  bool checkValidAccount(String val) {
    print('ACCOUNT VALUE: $val');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (val.isEmpty) {
      accountErrorText = 'Please enter your account';
      return false;
    } else {
      if (emailRegex.hasMatch(val)) {
        accountErrorText = null;
        email = val;
        return true;
      } else {
        accountErrorText = 'Invalid email';
        return false;
      }
    }
  }

  bool checkValidPassword(String val) {
    print('PASS VALUE: $val');
    if (val.isEmpty) {
      passwordErrorText = 'Please enter a password';
      return false;
    } else if (val.length < 5) {
      passwordErrorText = 'Password is too short';
      return false;
    } else {
      passwordErrorText = null;
      password = val;
      return true;
    }
  }

  bool checkValidCFPassword(String val) {
    print('CF PASSWORD VAL: $val');
    if (val.isEmpty) {
      cfpasswordErrorText = 'Please confirm your password';
      return false;
    } else {
      if (val != passwordController.text) {
        cfpasswordErrorText = 'Unmatched password';
        return false;
      } else {
        cfpasswordErrorText = null;
        return true;
      }
    }
  }

  Widget getButton() {
    return state == 1
        ? GestureDetector(
            onTap: canSignIn ? signIn_Up : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: canSignIn ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
              ),
            ),
          )
        : GestureDetector(
            onTap: canSignUp ? signIn_Up : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: canSignUp ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
              ),
            ),
          );
  }
}
