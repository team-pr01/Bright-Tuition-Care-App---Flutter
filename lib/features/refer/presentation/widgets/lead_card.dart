import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:flutter/material.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final bool isOpen;
  final VoidCallback onTap;

  const LeadCard({
    required this.lead,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.4)),
      ),

      child: Column(
        children: [
          /// 🔹 TOP ROW (ALWAYS VISIBLE)
          ListTile(
            onTap: onTap,

            title: Text(
              lead.phone,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            subtitle: Text("Class ${lead.className} • ${lead.status}" ),

            trailing: Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ),

          /// 🔹 EXPANDED SECTION
          if (isOpen)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row("Address", lead.address),
                  _row("Details", lead.details),
                  _row("Date", lead.date),

                  const SizedBox(height: 12),

                  /// 🔥 ACTION BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.payment, color: Colors.green),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
