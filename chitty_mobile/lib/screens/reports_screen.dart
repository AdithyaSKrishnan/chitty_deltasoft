import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reports & Analytics',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'View detailed business insights',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton.icon(

                          onPressed: () {},

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF334155),

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
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
                            Icons.download,
                            color: Colors.white,
                          ),

                          label: const Text(
                            'Export Report',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// FILTERS
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,

                      children: [

                        filterChip(
                          'This Month',
                          true,
                        ),

                        filterChip(
                          'Last Month',
                          false,
                        ),

                        filterChip(
                          'Last 3 Months',
                          false,
                        ),

                        filterChip(
                          'This Year',
                          false,
                        ),

                        filterChip(
                          'Custom Range',
                          false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ANALYTICS CARDS
                    GridView.count(

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisCount:
                          mobile ? 1 : 4,

                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,

                      childAspectRatio:
                          mobile ? 2.5 : 1.6,

                      children: [

                        analyticsCard(
                          'Total Collections',
                          '₹5000',
                          '+18.5%',
                          Icons.currency_rupee,
                          Colors.blue,
                        ),

                        analyticsCard(
                          'New Customers',
                          '1',
                          '+12%',
                          Icons.people,
                          Colors.green,
                        ),

                        analyticsCard(
                          'Active Chitties',
                          '1',
                          '+5%',
                          Icons.trending_up,
                          Colors.lightBlueAccent,
                        ),

                        analyticsCard(
                          'Pending Payments',
                          '0',
                          '-2%',
                          Icons.calendar_today,
                          Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// CHART SECTION
                    mobile
                        ? Column(
                            children: [

                              chartBox(
                                title:
                                    'Monthly Collections',

                                subtitle:
                                    'Last 6 months trend',
                              ),

                              const SizedBox(height: 20),

                              distributionBox(),
                            ],
                          )

                        : Row(
                            children: [

                              Expanded(
                                child: chartBox(
                                  title:
                                      'Monthly Collections',

                                  subtitle:
                                      'Last 6 months trend',
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(
                                child:
                                    distributionBox(),
                              ),
                            ],
                          ),

                    const SizedBox(height: 30),

                    /// PAYMENT OVERVIEW
                    Container(

                      padding:
                          const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF1E293B),

                        borderRadius:
                            BorderRadius.circular(
                                24),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Payment Status Overview',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 25),

                          SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal,

                            child: DataTable(

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
                                  label:
                                      Text('PAID'),
                                ),

                                DataColumn(
                                  label:
                                      Text('PENDING'),
                                ),

                                DataColumn(
                                  label:
                                      Text('OVERDUE'),
                                ),

                                DataColumn(
                                  label: Text(
                                      'COLLECTION RATE'),
                                ),
                              ],

                              rows: [

                                DataRow(
                                  cells: [

                                    const DataCell(
                                      Text('Overall'),
                                    ),

                                    DataCell(
                                      statusBox(
                                        '1',
                                        Colors.green,
                                      ),
                                    ),

                                    DataCell(
                                      statusBox(
                                        '0',
                                        Colors.orange,
                                      ),
                                    ),

                                    DataCell(
                                      statusBox(
                                        '0',
                                        Colors.red,
                                      ),
                                    ),

                                    const DataCell(
                                      Text(
                                        'Live Data',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(
    String title,
    bool active,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF1E3A8A)
            : const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Text(
        title,

        style: TextStyle(
          color: active
              ? Colors.blue.shade200
              : Colors.white,
        ),
      ),
    );
  }

  Widget analyticsCard(
    String title,
    String value,
    String growth,
    IconData icon,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),

              Container(

                padding:
                    const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(
                          16),
                ),

                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$growth vs last month',

            style: TextStyle(
              color: growth.contains('-')
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget chartBox({
    required String title,
    required String subtitle,
  }) {

    return Container(

      height: 350,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(

                padding:
                    const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color:
                      const Color(0xFF1E3A8A),

                  borderRadius:
                      BorderRadius.circular(
                          14),
                ),

                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: const [

              Text('Jan',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Feb',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Mar',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Apr',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('May',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Jun',
                  style: TextStyle(
                      color: Colors.white38)),
            ],
          ),
        ],
      ),
    );
  }

  Widget distributionBox() {

    return Container(

      height: 350,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(

                padding:
                    const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.green
                      .withOpacity(0.2),

                  borderRadius:
                      BorderRadius.circular(
                          14),
                ),

                child: const Icon(
                  Icons.pie_chart,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 14),

              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    'Plan Distribution',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Active subscriptions by plan',

                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 35),

          const Text(
            'gold savings',

            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 12),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(12),

            child: LinearProgressIndicator(
              value: 0.75,
              minHeight: 12,
              backgroundColor:
                  Colors.white10,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 10),

          const Align(
            alignment: Alignment.centerRight,

            child: Text(
              '1 customers',

              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusBox(
    String value,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        value,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}