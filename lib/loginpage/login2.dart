//import 'package:firebase_core/firebase_core.dart';
//SIGN UP
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:p/loginpage/login1.dart';
import 'package:p/loginpage/login3.dart';
import 'package:p/ownernav/home1.dart';
import 'package:p/tenant/ten1.dart';

class login2 extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login2> {
  bool _isPasswordVisible = false;
  String _email = "", _name = "", _password = "", _userType = "";
  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final List<String> _userTypes = ['Owner', 'Habitue'];

  @override
  void initState() {
    super.initState();
    _userType = _userTypes[0]; // Default to Owner
  }

  void _signup() async {
    if (_passwordcontroller.text != "" &&
        _namecontroller.text != "" &&
        _emailcontroller.text != "")
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _name,
          'email': _email,
          'userType': _userType,
        });
        // Show error message if any field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registered Successfully.'),
            backgroundColor: Colors.red,
          ),
        );

        if (_userType == 'Owner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => home1()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ten1()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'password provided is weak.please enter a password of atleast of 6 characters.'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email already exists'),
              backgroundColor: Colors.red,
            ),
          );
        }
        // Handle signup failure
      }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white, // Changed color to white
                        size: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'HomeConnect',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: <Widget>[
                      Text(
                        'Create a new account', // Changed text to "Create a new account"
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Please enter your email address and your password', // New text
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter name ';
                          }
                          return null;
                        },
                        controller: _namecontroller,
                        decoration: InputDecoration(
                          labelText: 'Full Name', // Added label for full name
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Change this to your desired color
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter email ';
                          }
                          return null;
                        },
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                          labelText: 'Email', // Changed label to "Email"
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 249, 249, 249)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Change this to your desired color
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter  password ';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle visibility
                              });
                            },
                            icon: Icon(
                              // Change the icon based on visibility
                              !_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color:
                              Colors.white, // Text color inside the TextField
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        style: TextStyle(
                            color: Color.fromARGB(255, 239, 232, 232)),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: DropdownButton<String>(
                              value: _userType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _userType = newValue!;
                                });
                              },
                              items: _userTypes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login3()));
                        },
                        child: Text(
                          'Already have a account?',
                          style: TextStyle(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          _email = _emailcontroller.text;
                          _name = _namecontroller.text;
                          _password = _passwordcontroller.text;
                        });
                      }
                      _signup();
                    },
                    child: Text('Sign Up'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size.fromHeight(40.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
