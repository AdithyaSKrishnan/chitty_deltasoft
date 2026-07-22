import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../widgets/sidebar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool darkMode = true;

  bool emailNotifications = true;
  bool smsNotifications = false;
  bool pushNotifications = true;

  bool overdueAlerts = true;
  bool customerAlerts = true;

  final TextEditingController fullName =
      TextEditingController(text: 'Admin');

  final TextEditingController email =
      TextEditingController();

  final TextEditingController phone =
      TextEditingController();

  final TextEditingController username =
      TextEditingController(text: 'admin');

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      body: Row(

        children: [

          if (!mobile)
            const Sidebar(),

          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    const Text(
                      'Settings',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Manage your account preferences',

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// PROFILE SETTINGS
                    settingsContainer(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          sectionTitle(
                            Icons.lock_outline,
                            Colors.blue,
                            'Profile Settings',
                            'Update your personal information',
                          ),

                          const SizedBox(height: 30),

                          mobile
                              ? Column(
                                  children: [

                                    buildField(
                                      'Full Name',
                                      fullName,
                                    ),

                                    const SizedBox(height: 18),

                                    buildField(
                                      'Email Address',
                                      email,
                                    ),

                                    const SizedBox(height: 18),

                                    buildField(
                                      'Phone Number',
                                      phone,
                                    ),

                                    const SizedBox(height: 18),

                                    buildField(
                                      'Username',
                                      username,
                                    ),
                                  ],
                                )

                              : Column(
                                  children: [

                                    Row(
                                      children: [

                                        Expanded(
                                          child: buildField(
                                            'Full Name',
                                            fullName,
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Expanded(
                                          child: buildField(
                                            'Email Address',
                                            email,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    Row(
                                      children: [

                                        Expanded(
                                          child: buildField(
                                            'Phone Number',
                                            phone,
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Expanded(
                                          child: buildField(
                                            'Username',
                                            username,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 28),

                          const Divider(
                            color: Colors.white10,
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton.icon(

                            onPressed: () {},

                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF60A5FA),

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                              ),
                            ),

                            icon: const Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                            ),

                            label: const Text(
                              'Save Changes',

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// APPEARANCE
                    settingsContainer(
                      child: Column(
                        children: [

                          sectionTitle(
                            Icons.dark_mode,
                            Colors.green,
                            'Appearance',
                            'Customize the interface theme',
                          ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                            children: [

                              Row(
                                children: [

                                  iconBox(
                                    Icons.nightlight_round,
                                  ),

                                  const SizedBox(width: 16),

                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        'Dark Mode',

                                        style: TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      Text(
                                        'Currently enabled',

                                        style: TextStyle(
                                          color: Colors
                                              .white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Switch(
                                value: ThemeService.isDark,
                                activeColor: Colors.blue,
                                onChanged: (value) async {
                                  await ThemeService.setDarkMode(value);
                                  setState(() {
                                    darkMode = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// NOTIFICATIONS
                    settingsContainer(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          sectionTitle(
                            Icons.notifications_none,
                            Colors.blue,
                            'Notifications',
                            'Configure how you receive alerts',
                          ),

                          const SizedBox(height: 30),

                          notificationRow(
                            icon: Icons.email_outlined,
                            title:
                                'Email Notifications',
                            subtitle:
                                'Receive updates via email',
                            value: emailNotifications,
                            onChanged: (v) {
                              setState(() {
                                emailNotifications =
                                    v!;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          notificationRow(
                            icon: Icons.phone_android,
                            title: 'SMS Alerts',
                            subtitle:
                                'Get important alerts via SMS',
                            value: smsNotifications,
                            onChanged: (v) {
                              setState(() {
                                smsNotifications =
                                    v!;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          notificationRow(
                            icon:
                                Icons.notifications_active,
                            title:
                                'Push Notifications',
                            subtitle:
                                'Browser push notifications',
                            value: pushNotifications,
                            onChanged: (v) {
                              setState(() {
                                pushNotifications =
                                    v!;
                              });
                            },
                          ),

                          const SizedBox(height: 30),

                          const Divider(
                            color: Colors.white10,
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Alert Types',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 22),

                          CheckboxListTile(

                            value: overdueAlerts,

                            activeColor:
                                Colors.purple,

                            title: const Text(
                              'Overdue payment reminders',

                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),

                            onChanged: (v) {
                              setState(() {
                                overdueAlerts = v!;
                              });
                            },
                          ),

                          CheckboxListTile(

                            value: customerAlerts,

                            activeColor:
                                Colors.purple,

                            title: const Text(
                              'New customer onboarded',

                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),

                            onChanged: (v) {
                              setState(() {
                                customerAlerts = v!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// DANGER ZONE
                    Container(

                      width: double.infinity,

                      padding: const EdgeInsets.all(26),

                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF1E293B),

                        borderRadius:
                            BorderRadius.circular(24),

                        border: Border.all(
                          color: Colors.red
                              .withOpacity(0.5),
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Danger Zone',

                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'These actions are irreversible. Please proceed with caution.',

                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 28),

                          Wrap(
                            spacing: 18,
                            runSpacing: 18,

                            children: [

                              ElevatedButton(

                                onPressed: () {},

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.redAccent,

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 18,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            16),
                                  ),
                                ),

                                child: const Text(
                                  'Delete Account',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              ElevatedButton(

                                onPressed: () {},

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(
                                          0xFF475569),

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 18,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            16),
                                  ),
                                ),

                                child: const Text(
                                  'Export Data',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsContainer({
    required Widget child,
  }) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: child,
    );
  }

  Widget sectionTitle(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {

    return Row(
      children: [

        Container(

          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: color.withOpacity(0.15),

            borderRadius:
                BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(width: 16),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,

              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller,
  ) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          label,

          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 12),

        TextField(

          controller: controller,

          style:
              const TextStyle(color: Colors.white),

          decoration: InputDecoration(

            filled: true,

            fillColor:
                const Color(0xFF1E293B),

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: BorderSide(
                color:
                    Colors.white.withOpacity(0.1),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: BorderSide(
                color:
                    Colors.white.withOpacity(0.1),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide:
                  const BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget iconBox(IconData icon) {

    return Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFF334155),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Icon(
        icon,
        color: Colors.white70,
      ),
    );
  }

  Widget notificationRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Expanded(
          child: Row(
            children: [

              iconBox(icon),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Checkbox(
          value: value,
          activeColor: Colors.purple,
          onChanged: onChanged,
        ),
      ],
    );
  }
}