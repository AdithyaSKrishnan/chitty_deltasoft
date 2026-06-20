import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';
import '../widgets/chit_plan_dialog.dart';

class ChitPlansScreen extends StatefulWidget {
  const ChitPlansScreen({super.key});

  @override
  State<ChitPlansScreen> createState() =>
      _ChitPlansScreenState();
}

class _ChitPlansScreenState
    extends State<ChitPlansScreen> {

  final List<Map<String, dynamic>> plans = [

    {
      'name': 'Gold Savings',
      'code': 'GS101',
      'amount': '₹ 1,00,000',
      'months': '20 months',
      'monthly': '₹ 5,000',
      'status': 'Active',
    },

    {
      'name': 'Premium Plus',
      'code': 'PP202',
      'amount': '₹ 2,50,000',
      'months': '25 months',
      'monthly': '₹ 10,000',
      'status': 'Paused',
    },
  ];

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
                              'Chit Plans',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage savings schemes',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () {

                            showDialog(

                              context: context,

                              builder: (_) =>
                                  const ChitPlanDialog(),
                            );
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
                            'Create Plan',

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

                          /// SEARCH
                          TextField(

                            style: const TextStyle(
                              color: Colors.white,
                            ),

                            decoration: InputDecoration(

                              hintText:
                                  'Search plans...',

                              hintStyle:
                                  const TextStyle(
                                color: Colors.white54,
                              ),

                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white54,
                              ),

                              filled: true,
                              fillColor:
                                  const Color(
                                      0xFF0F172A),

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(16),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// TABLE / MOBILE CARDS
                          mobile
                              ? Column(
                                  children:
                                      plans.map((plan) {

                                    return mobileCard(
                                        plan);
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
                                            'PLAN NAME'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'TOTAL AMOUNT'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'INSTALLMENTS'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'MONTHLY PAYMENT'),
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

                                    rows: plans.map((p) {

                                      return DataRow(
                                        cells: [

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
                                                  p['name'],
                                                ),

                                                Text(
                                                  p['code'],

                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        Colors.white54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              p['amount'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              p['months'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              p['monthly'],

                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.green,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            statusChip(
                                              p['status'],
                                            ),
                                          ),

                                          DataCell(
                                            Row(
                                              children: [

                                                IconButton(

                                                  onPressed:
                                                      () {

                                                    showDialog(

                                                      context:
                                                          context,

                                                      builder:
                                                          (_) =>
                                                              const ChitPlanDialog(),
                                                    );
                                                  },

                                                  icon:
                                                      const Icon(
                                                    Icons.edit,
                                                    color:
                                                        Colors.white70,
                                                  ),
                                                ),

                                                IconButton(
                                                  onPressed:
                                                      () {},

                                                  icon:
                                                      const Icon(
                                                    Icons
                                                        .power_settings_new,
                                                    color:
                                                        Colors.white70,
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

  Widget statusChip(String status) {

    Color color = status == 'Active'
        ? Colors.green
        : Colors.orange;

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
        status,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget mobileCard(
    Map<String, dynamic> p,
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

          Text(
            p['name'],

            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            p['code'],

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: 20),

          infoText(
            'Total Amount',
            p['amount'],
          ),

          infoText(
            'Installments',
            p['months'],
          ),

          infoText(
            'Monthly',
            p['monthly'],
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              statusChip(p['status']),

              const Spacer(),

              IconButton(
                onPressed: () {

                  showDialog(

                    context: context,

                    builder: (_) =>
                        const ChitPlanDialog(),
                  );
                },

                icon: const Icon(
                  Icons.edit,
                  color: Colors.white70,
                ),
              ),

              IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.white70,
                ),
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