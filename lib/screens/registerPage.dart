import 'package:flutter/material.dart';
import 'package:romaquest/screens/homepage.dart';
import 'package:romaquest/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:romaquest/theme/app_tokens.dart';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

void signUserUp() async {
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }else{
         passwordMismatchMessage();
        
      }
      
    } on FirebaseAuthException {
      
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('You are not connected to the internet.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void passwordMismatchMessage() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Password Mismatch'),
        content: Text('Please check your password and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background5.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 30), 
                        child: Text(
                          'Create New Account', 
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: () async {
                          signUserUp();
                        },
                        child: Text('Register'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Already have an account ? Log in',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
