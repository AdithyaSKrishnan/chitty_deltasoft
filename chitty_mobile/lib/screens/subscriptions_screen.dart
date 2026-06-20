import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/subscription_dialog.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState
    extends State<SubscriptionsScreen> {

  List<dynamic> subscriptions = [];
  bool isLoading = true;
  @override
void initState() {
  super.initState();
  loadSubscriptions();
}

Future<void> loadSubscriptions() async {
  final data = await AuthService.getSubscriptions();

  setState(() {
    subscriptions = data;
    isLoading = false;
  });

  print(data);
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

                    /// HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Subscriptions',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage customer subscriptions',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () async {

  final result = await showDialog(
    context: context,
    builder: (_) =>
        const SubscriptionDialog(),
  );

  if (result == true) {
    await loadSubscriptions();
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
                            'Enroll Customer',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// MAIN BOX
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
                                  'Search subscriptions...',

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
                          if (isLoading)
  const Center(
    child: CircularProgressIndicator(),
  )
else

                          mobile
                              ? Column(
                                  children:
                                      subscriptions
                                          .map((s) {

                                    return mobileCard(
                                        s);
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
                                            'CUSTOMER'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('PLAN'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('AMOUNT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('STATUS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('PAYMENT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('JOINED'),
                                      ),
                                    ],

                                    rows:
                                        subscriptions
                                            .map((s) {

                                      return DataRow(
                                        cells: [

                                          DataCell(
                                            Text(
                                              s['customer_name'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              s['chit_plan_name'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              s['chit_plan_code'],

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
                                              s['subscription_status'],
                                            ),
                                          ),

                                          DataCell(
                                            paymentChip(
                                              s['payment_status'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              s['joined_date'],
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

  Widget paymentChip(String status) {

    Color color = status == 'Paid'
        ? Colors.green
        : Colors.redAccent;

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
    Map<String, dynamic> s,
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
            s['customer'],

            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            s['plan'],

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: 20),

          infoText('Amount', s['amount']),
          infoText('Joined', s['date']),

          const SizedBox(height: 15),

          Row(
            children: [

              statusChip(s['status']),

              const SizedBox(width: 10),

              paymentChip(s['payment']),
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