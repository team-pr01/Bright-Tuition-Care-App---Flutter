import 'package:btcclient/core/widgets/input/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';

class Step3Form extends ConsumerWidget {
  const Step3Form({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postJobProvider);
    final data = state.data;
    final notifier = ref.read(postJobProvider.notifier);

    /// 🔥 GET AREAS BASED ON CITY
    List<String> getAreas() {
      final cityData =
          (filterData["cityCorporationWithLocation"] as List? ?? []);

      final matched = cityData.where(
        (c) => c["name"] == data.city,
      ).toList();

      if (matched.isEmpty) return [];

      return List<String>.from(matched.first["locations"] ?? []);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// 🔥 CITY
          FormHelpers.field(
            AppInputField(
              label: "City",
              required: true,
              hint: "Select Option",
              type: AppInputType.dropdown,
              dropdownItems: List<String>.from(
                filterData["cityCorporations"] ?? [],
              ),
              value: data.city,
              onChanged: (v) {
                notifier.update((d) {
                  d.city = v;

                  /// 🔥 RESET AREA
                  d.area = null;
                });
              },
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 AREA
          FormHelpers.field(
            AppInputField(
              label: "Area",
              required: true,
              hint: "Select Option",
              type: AppInputType.dropdown,
              dropdownItems: getAreas(),
              value: data.area,
              onChanged: (v) {
                notifier.update((d) => d.area = v);
              },
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 ADDRESS
          FormHelpers.field(
            AppInputField(
              label: "Address",
              required: true,
              hint: "Enter address",
              type: AppInputType.text,
              maxLines: 2,
              value: data.address,
              onChanged: (v) {
                notifier.update((d) => d.address = v);
              },
            ),
          ),
        ],
      ),
    );
  }
}