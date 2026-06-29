
import 'package:flutter/material.dart';
import 'package:romaquest/screens/auth_page.dart';
import 'package:romaquest/theme/app_tokens.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background5.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'WELCOME TO ROME...',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Text(
                        'Immerse yourself in the timeless charm of Rome, where ancient history and modern allure seamlessly blend, inviting you on a journey of discovery and adventure.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthPage(),
                            ),
                          );
                        },
                        child: Text('Get Started'),
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
