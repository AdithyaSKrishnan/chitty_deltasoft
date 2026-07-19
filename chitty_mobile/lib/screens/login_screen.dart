import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'agent_dashboard_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
      usernameController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    final result = await AuthService.login(

      username:
          usernameController.text.trim(),

      password:
          passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result['success']) {

      final role = result['role'];

      // ADMIN LOGIN
      if (role == 'admin' || role == 'subadmin') {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
                const DashboardScreen(),
          ),
        );
      }

      // AGENT LOGIN
      else if (role == 'field_agent') {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
                const AgentDashboardScreen(),
          ),
        );
      }

      // UNKNOWN ROLE
      else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              'Unknown role: $role',
            ),
          ),
        );
      }
    }

    // LOGIN FAILED
    else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            result['message'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF020617),

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: ConstrainedBox(

            constraints:
                const BoxConstraints(
              maxWidth: 450,
            ),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Text(
                  'Chitty Finance',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Role Based Login System',

                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 45),

                /// USERNAME
                TextField(

                  controller:
                      usernameController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Username',

                    hintStyle:
                        const TextStyle(
                      color: Colors.white70,
                    ),

                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.white70,
                    ),

                    filled: true,

                    fillColor:
                        Colors.white10,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// PASSWORD
                TextField(

                  controller:
                      passwordController,

                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Password',

                    hintStyle:
                        const TextStyle(
                      color: Colors.white70,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white70,
                    ),

                    filled: true,

                    fillColor:
                        Colors.white10,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// LOGIN BUTTON
                SizedBox(

                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(

                    onPressed:
                        isLoading ? null : login,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: isLoading

                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )

                        : const Text(

                            'Login',

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}