import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecognitionCard extends StatelessWidget {
  final String image;
  final String title;
  final String tutorId;
  final String rating;
  final String name;
  final String date;

  const RecognitionCard({
    super.key,
    required this.image,
    required this.title,
    required this.tutorId,
    required this.rating,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/visual/reward.svg",
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary01,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Recognition",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.neutrals02,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// INNER CARD
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 9),
              child: Row(
                children: [
                  /// PROFILE IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: image.startsWith("http")
                        ? Image.network(
                            image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                "assets/images/dummy-avatar.jpg",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                  ),

                  const SizedBox(width: 12),

                  /// TEXT
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: AppColors.neutrals02,
                                fontWeight: FontWeight.w300,
                                height: 1.5,
                              ),
                        ),

                        const SizedBox(height: 4),

                        /// ID + RATING
                        Row(
                          children: [
                            Text(
                              "ID: $tutorId",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(
                                    color: AppColors.neutrals03,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFCF10),
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(
                                    color: AppColors.neutrals03,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        /// NAME
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(
                                color: AppColors.neutrals03,
                                fontWeight: FontWeight.w300,
                                height: 1.5,
                              ),
                        ),

                        const SizedBox(height: 4),

                        /// DATE
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/visual/calendar.svg",
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                AppColors.neutrals03,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(
                                      color: AppColors.neutrals03,
                                      fontWeight: FontWeight.w300,
                                      height: 1.5,
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
        ],
      ),
    );
  }
}
