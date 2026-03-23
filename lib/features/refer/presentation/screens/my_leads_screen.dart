import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:btcclient/features/refer/presentation/widgets/lead_card.dart';
import 'package:flutter/material.dart';

class MyLeadsScreen extends StatefulWidget {
  const MyLeadsScreen({super.key});

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  int? expandedIndex;

  final List<Lead> leads = [
    Lead(
      id: "1",
      phone: "9876543210",
      className: "10",
      address: "Nagpur",
      details: "Maths tuition required",
      status: "Pending",
      date: "12 Feb",
    ),
    Lead(
      id: "2",
      phone: "9123456780",
      className: "8",
      address: "Pune",
      details: "Science help",
      status: "Confirmed",
      date: "15 Feb",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: leads.length,
        itemBuilder: (context, index) {
          final lead = leads[index];
          final isOpen = expandedIndex == index;

          return LeadCard(
            lead: lead,
            isOpen: isOpen,
            onTap: () {
              setState(() {
                expandedIndex = isOpen ? null : index;
              });
            },
          );
        },
      ),
    );
  }
}
