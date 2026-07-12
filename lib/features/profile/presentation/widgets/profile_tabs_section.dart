
import 'package:btcclient/features/profile/data/models/profile_tab_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_tab_card.dart';
import 'package:flutter/material.dart';

class ProfileTabsSection extends StatefulWidget {

  const ProfileTabsSection({
    super.key,
  });

  @override
  State<ProfileTabsSection> createState() =>
      _ProfileTabsSectionState();
}

class _ProfileTabsSectionState
    extends State<ProfileTabsSection> {

  int selectedIndex = 0;

  final tabs = [

    ProfileTabModel(
      title: "Personal",
      subtitle: "Information",
      icon: Icons.badge_outlined,
      isCompleted: true,
    ),

    ProfileTabModel(
      title: "Educational",
      subtitle: "Information",
      icon: Icons.school_outlined,
    ),

    ProfileTabModel(
      title: "Tuition Related",
      subtitle: "Information",
      icon: Icons.work_outline,
    ),

    ProfileTabModel(
      title: "Credential",
      subtitle: "Information",
      icon: Icons.description_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 95,

      child: ListView.separated(

        scrollDirection: Axis.horizontal,

        itemCount: tabs.length,

        separatorBuilder: (_, __) =>
            const SizedBox(width: 6),

        itemBuilder: (context, index) {

          final tab = tabs[index];

          return SizedBox(

            width: 205,

            child: ProfileTabCard(

              title: tab.title,

              subtitle: tab.subtitle,

              icon: tab.icon,

              isCompleted:
                  tab.isCompleted,

              isActive:
                  selectedIndex == index,

              onTap: () {

                setState(() {

                  selectedIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }
}