import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseattempt_1/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _isPasswordVisible = false; // This will toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align all children to the left
          children: [
            // Add the image at the top
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/3.png', // Ensure this path matches your image file
                height: 100, // Adjust the height as needed
              ),
            ),
            SizedBox(height: 1),

            // Align "Join Do.lk" text to the left
            Text(
              "Join Do.lk",
              textAlign: TextAlign.left, // Left-align the text
              style: TextStyle(
                fontSize: 20, // Adjust the font size as needed
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 1),

            // Add the text below the image
            Text(
              "Create an account and discover thousands of relevant services, connect with freelancers, and check out easily on Do.lk’s trusted platform.",
              textAlign: TextAlign.left, // Left-align the text
              style: TextStyle(
                fontSize: 12, // Adjust the font size as needed
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 25),

            // Email input with adjusted height
            Container(
              height: 60, // Set the height of the TextField
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Rounded corners
                  ),
                  labelText: "Enter Email",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ), // Adjust padding inside TextField
                ),
              ),
            ),
            SizedBox(height: 5),

            // Password input with adjusted height and eye icon to toggle visibility
            Container(
              height: 60, // Set the height of the TextField
              child: TextField(
                controller: passController,
                obscureText: !_isPasswordVisible, // Toggle password visibility
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Rounded corners
                  ),
                  labelText: "Enter Password",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ), // Adjust padding inside TextField
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons
                              .visibility_off, // Change icon based on visibility state
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle visibility
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Register button with the updated color and size
            ElevatedButton(
              onPressed: () async {
                String mail = emailController.text.trim();
                String pass = passController.text.trim();

                if (mail.isEmpty || pass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter all the fields")),
                  );
                } else {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: mail,
                      password: pass,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registered Successfully")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${err.toString()}")),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFF17BA01,
                ), // Set button color to #17BA01
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                ),
                minimumSize: Size(
                  double.infinity,
                  50,
                ), // Set width to full and height to 50
              ),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 25),

            // Navigate to Login Page
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  "Already have an account? Login here",

                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
