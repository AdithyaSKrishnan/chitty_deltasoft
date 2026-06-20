import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/employee_dialog.dart';
import '../services/auth_service.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() =>
      _EmployeesScreenState();
}

class _EmployeesScreenState
    extends State<EmployeesScreen> {

  List<dynamic> employees = [];
  @override
void initState() {
  super.initState();
  loadEmployees();
}

Future<void> loadEmployees() async {
  print("Loading employees...");
  final data = await AuthService.getEmployees();
   print("Employees loaded:");
   print(data);
  setState(() {
    employees = data;
  });

  //
  //print(data);
}
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

                    /// TOP BAR
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Employees',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage team members',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () async {

  print("OPENING DIALOG");

  final result = await showDialog(
    context: context,
    builder: (_) => const EmployeeDialog(),
  );

  print("DIALOG RESULT: $result");

  if (result == true) {

    print("CALLING LOAD EMPLOYEES");

    await loadEmployees();
  }
},
                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.blue,

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),

                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),

                          label: const Text(
                            'Add Employee',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// MAIN CONTAINER
                    Container(

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),

                      child: Column(

                        children: [

                          /// SEARCH + FILTERS
                          mobile
                              ? Column(
                                  children: [

                                    searchBox(),

                                    const SizedBox(
                                        height: 15),

                                    Row(
                                      children: [

                                        Expanded(
                                          child:
                                              dropdownBox(
                                            'All Roles',
                                          ),
                                        ),

                                        const SizedBox(
                                            width: 12),

                                        Expanded(
                                          child:
                                              dropdownBox(
                                            'All Status',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                              : Row(
                                  children: [

                                    Expanded(
                                      child: searchBox(),
                                    ),

                                    const SizedBox(
                                        width: 16),

                                    SizedBox(
                                      width: 170,
                                      child:
                                          dropdownBox(
                                        'All Roles',
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 16),

                                    SizedBox(
                                      width: 170,
                                      child:
                                          dropdownBox(
                                        'All Status',
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 25),

                          /// EMPLOYEE LIST
                          mobile
                              ? Column(
                                  children:
                                      employees.map((e) {

                                    return mobileCard(
                                        e);
                                  }).toList(),
                                )

                              : SingleChildScrollView(
                                  scrollDirection:
                                      Axis.horizontal,

                                  child: DataTable(

                                    columnSpacing: 45,

                                    headingTextStyle:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    dataTextStyle:
                                        const TextStyle(
                                      color: Colors.white,
                                    ),

                                    columns: const [

                                      DataColumn(
                                        label: Text(
                                            'EMPLOYEE'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'USERNAME'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('CONTACT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('ROLE'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'CUSTOMERS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('STATUS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('ACTIONS'),
                                      ),
                                    ],

                                    rows:
                                        employees.map((e) {

                                      return DataRow(
                                        cells: [

                                          DataCell(
                                            Row(
                                              children: [

                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.blue,

              child: Text(
  ((e['full_name_display']?.toString().isNotEmpty ?? false)
          ? e['full_name_display']
          : e['username_display'])[0]
      .toUpperCase(),
),
                                                ),

                                                const SizedBox(
                                                    width:
                                                        12),

                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,

                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,

                                                  children: [
Text(
  (e['full_name_display']?.toString().isNotEmpty ?? false)
      ? e['full_name_display']
      : e['username_display'],
),

                                                    Text(
                                                       e['employee_id'],

                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                               e['username_display'],
                                            ),
                                          ),

                                          DataCell(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,

                                              children: [

                                                Text(
                                                   e['email_display'] ?? '',
                                                ),

                                                Text(
                                                  e['phone_number'] ?? '',
                                                ),
                                              ],
                                            ),
                                          ),

                                          DataCell(
                                            chipWidget(
                                              e['role'],
                                              Colors.blue,
                                            ),
                                          ),

                                          DataCell(
  Text(
    e['customer_count'].toString(),
  ),
),

                                          DataCell(
                                            chipWidget(
  e['is_active'] == true
      ? 'Active'
      : 'Inactive',

  e['is_active'] == true
      ? Colors.green
      : Colors.orange,
),
                                          ),

                                          DataCell(
                                            Row(
                                              children: [

                                                IconButton(
  onPressed: () async {

    final result =
        await showDialog(

      context: context,

      builder: (_) =>
          EmployeeDialog(
        employee: e,
      ),
    );

    if (result == true) {
      await loadEmployees();
    }
  },

                                                  icon:
                                                      const Icon(
                                                    Icons.edit,
                                                    color: Colors
                                                        .white70,
                                                  ),
                                                ),

                                                IconButton(

  onPressed: () async {

    final success =
        await AuthService.toggleEmployeeStatus(
      e['id'],
    );

    if (success) {

      await loadEmployees();
    }
  },

  icon: const Icon(
    Icons.power_settings_new,
    color: Colors.white70,
  ),
),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
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

  Widget searchBox() {

    return TextField(

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(

        hintText: 'Search employees...',

        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white54,
        ),

        filled: true,
        fillColor: const Color(0xFF0F172A),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget dropdownBox(String hint) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),

      child: DropdownButtonHideUnderline(

        child: DropdownButton<String>(

          dropdownColor:
              const Color(0xFF0F172A),

          value: hint,

          iconEnabledColor: Colors.white,

          style: const TextStyle(
            color: Colors.white,
          ),

          items: [

            DropdownMenuItem(
              value: hint,
              child: Text(hint),
            ),
          ],

          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget chipWidget(
    String text,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget mobileCard(
    Map<String, dynamic> e,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              CircleAvatar(
                backgroundColor: Colors.blue,

      child: Text(
  ((e['full_name_display']?.toString().isNotEmpty ?? false)
          ? e['full_name_display']
          : e['username_display'])[0]
      .toUpperCase(),
),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
  (e['full_name_display']?.toString().isNotEmpty ?? false)
      ? e['full_name_display']
      : e['username_display'],

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
                    Text(
                      e['employee_id'],

                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          infoText(
  'Username',
  e['username_display'] ?? '',
),

infoText(
  'Email',
  e['email_display'] ?? '',
),

infoText(
  'Phone',
  e['phone_number'] ?? '',
),

infoText(
  'Customers',
  e['customer_count'].toString(),
),

          const SizedBox(height: 12),

          Row(
            children: [

              chipWidget(
                e['role'],
                Colors.blue,
              ),

              const SizedBox(width: 10),

              chipWidget(
  e['is_active'] == true
      ? 'Active'
      : 'Inactive',

  e['is_active'] == true
      ? Colors.green
      : Colors.orange,
),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoText(
    String title,
    String value,
  ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [

          Text(
            '$title : ',

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}