import 'package:flutter/material.dart';
import '../services/auth_service.dart';
class EmployeeDialog extends StatefulWidget {

  final Map<String, dynamic>? employee;

  const EmployeeDialog({
    super.key,
    this.employee,
  });

  bool get isEdit =>
      employee != null;

  @override
  State<EmployeeDialog> createState() =>
      _EmployeeDialogState();
}
class _EmployeeDialogState
    extends State<EmployeeDialog> {

  String role = 'Admin';
  final fullNameController =
      TextEditingController();

  final usernameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {

      fullNameController.text =
          widget.employee!['full_name_display'] ?? '';

      emailController.text =
          widget.employee!['email_display'] ?? '';

      phoneController.text =
          widget.employee!['phone_number'] ?? '';

      role =
          widget.employee!['role'] == 'admin'
              ? 'Admin'
              : 'Field Agent';
    }
  }


  Widget field(
  String hint,
  TextEditingController controller,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),

    child: TextField(
      controller: controller,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        filled: true,
        fillColor: const Color(0xFF0F172A),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Container(

        width: 500,

        padding: const EdgeInsets.all(28),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),

        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Text(
  widget.isEdit
      ? 'Edit Employee'
      : 'Add Employee',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context, true);
                    },

                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              field(
  'Full Name',
  fullNameController,
),

if (!widget.isEdit)
  field(
    'Username',
    usernameController,
  ),

field(
  'Email Address',
  emailController,
),

field(
  'Phone Number',
  phoneController,
),
if (!widget.isEdit)
  field(
    'Password',
    passwordController,
  ),

              const SizedBox(height: 10),

              const Text(
                'Role',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  Expanded(
                    child: RadioListTile(

                      value: 'Admin',
                      groupValue: role,

                      activeColor: Colors.blue,

                      title: const Text(
                        'Admin',

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      onChanged: (value) {

                        setState(() {

                          role = value!;
                        });
                      },
                    ),
                  ),

                  Expanded(
                    child: RadioListTile(

                      value: 'Field Agent',
                      groupValue: role,

                      activeColor: Colors.purple,

                      title: const Text(
                        'Field Agent',

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      onChanged: (value) {

                        setState(() {

                          role = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              field(
  'Password',
  passwordController,
),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 18),

                  ElevatedButton(

                    onPressed: () async {

  bool success;

  if (widget.isEdit) {

    success =
        await AuthService.updateEmployee(

      employeeId:
          widget.employee!['id'],

      fullName:
          fullNameController.text,

      email:
          emailController.text,

      phoneNumber:
          phoneController.text,

      role: role == 'Admin'
          ? 'admin'
          : 'field_agent',
    );

  } else {

    success =
        await AuthService.createEmployee(

      fullName:
          fullNameController.text,

      username:
          usernameController.text,

      email:
          emailController.text,

      password:
          passwordController.text,

      phoneNumber:
          phoneController.text,

      role: role == 'Admin'
          ? 'admin'
          : 'field_agent',
    );
  }

  if (success) {

    Navigator.pop(context, true);

  } else {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('Operation Failed'),
      ),
    );
  }
},

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: const Text(
                      'Add Employee',
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