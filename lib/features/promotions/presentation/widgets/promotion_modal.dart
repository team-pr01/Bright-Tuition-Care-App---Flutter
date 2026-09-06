import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/theme.dart';
import '../../data/models/promotion_model.dart';

class PromotionModal extends StatefulWidget {
  final List<PromotionModel> promotions;

  const PromotionModal({
    super.key,
    required this.promotions,
  });

  @override
  State<PromotionModal> createState() =>
      _PromotionModalState();
}

class _PromotionModalState
    extends State<PromotionModal> {
  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _startAutoScroll();
  }

  // ==============================================================
  // AUTO SCROLL
  // ==============================================================

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();

    if (widget.promotions.length <= 1) {
      return;
    }

    _autoScrollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!mounted ||
            !_pageController.hasClients) {
          return;
        }

        final nextPage =
            (_currentPage + 1) %
                widget.promotions.length;

        _pageController.animateToPage(
          nextPage,
          duration:
              const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // ==============================================================
  // OPEN PROMOTION LINK
  // ==============================================================

  Future<void> _openPromotionLink(
    PromotionModel promotion,
  ) async {
    final link = promotion.buttonLink;

    if (link == null ||
        link.trim().isEmpty) {
      return;
    }

    final uri = Uri.tryParse(
      link.trim(),
    );

    if (uri == null) {
      return;
    }

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint(
        'Could not open promotion link: $e',
      );
    }
  }

  // ==============================================================
  // DISPOSE
  // ==============================================================

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
Widget build(BuildContext context) {
  if (widget.promotions.isEmpty) {
    return const SizedBox.shrink();
  }

  return AspectRatio(
    aspectRatio: 1,
    child: Stack(
      children: [
        // ==========================================================
        // SQUARE PROMOTION CAROUSEL
        // ==========================================================

        Positioned.fill(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.promotions.length,
            physics: const BouncingScrollPhysics(),

            onPageChanged: (index) {
              if (!mounted) return;

              setState(() {
                _currentPage = index;
              });
            },

            itemBuilder: (context, index) {
              final promotion =
                  widget.promotions[index];

              return _PromotionPage(
                promotion: promotion,
                onTap: () {
                  _openPromotionLink(
                    promotion,
                  );
                },
              );
            },
          ),
        ),

        // ==========================================================
        // INDICATOR OVER IMAGE
        // ==========================================================

        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: _buildPromotionIndicator(),
        ),
      ],
    ),
  );
}
 // ==============================================================
  // PAGE INDICATOR
  // ==============================================================

  Widget _buildPromotionIndicator() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        widget.promotions.length,
        (index) {
          final isSelected =
              _currentPage == index;

          return AnimatedContainer(
            duration:
                const Duration(milliseconds: 250),

            curve: Curves.easeInOut,

            margin:
                const EdgeInsets.symmetric(
              horizontal: 3,
            ),

            width:
                isSelected ? 16 : 6,

            height: 6,

            decoration:
                BoxDecoration(
              color: isSelected
                  ? AppColors.primary01
                  : Colors.grey[300],

              borderRadius:
                  BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}

// ==================================================================
// SINGLE PROMOTION PAGE
// ==================================================================

class _PromotionPage
    extends StatelessWidget {
  final PromotionModel promotion;

  final VoidCallback onTap;

  const _PromotionPage({
    required this.promotion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasLink =
        promotion.buttonLink != null &&
            promotion.buttonLink!
                .trim()
                .isNotEmpty;

    return GestureDetector(
      onTap: hasLink ? onTap : null,

      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 0,
        ),

        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(16),

          child: Container(
            width: double.infinity,
            height: double.infinity,

            color: Colors.white,

            child: Stack(
              fit: StackFit.expand,

              children: [
                // ==================================================
                // 1:1 PROMOTION IMAGE
                // ==================================================

                Image.network(
                  promotion.imageUrl.trim(),

                  width: double.infinity,
                  height: double.infinity,

                  fit: BoxFit.contain,

                  filterQuality:
                      FilterQuality.high,

                  loadingBuilder:
                      (
                        context,
                        child,
                        loadingProgress,
                      ) {
                    if (loadingProgress ==
                        null) {
                      return child;
                    }

                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  },

                  errorBuilder:
                      (
                        context,
                        error,
                        stackTrace,
                      ) {
                    debugPrint(
                      'PROMOTION IMAGE ERROR',
                    );

                    debugPrint(
                      'URL: ${promotion.imageUrl}',
                    );

                    debugPrint(
                      'ERROR: $error',
                    );

                    return Container(
                      color:
                          AppColors.primary03,

                      alignment:
                          Alignment.center,

                      child: const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons
                                .image_not_supported_outlined,
                            size: 48,
                            color:
                                Colors.grey,
                          ),

                          SizedBox(
                            height: 8,
                          ),

                          Text(
                            'Unable to load image',
                            style: TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // ==================================================
                // OPTIONAL BUTTON
                // ==================================================

                if (promotion.buttonText !=
                        null &&
                    promotion.buttonText!
                        .trim()
                        .isNotEmpty &&
                    hasLink)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,

                    child: ElevatedButton(
                      onPressed: onTap,

                      style:
                          ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 13,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                      ),

                      child: Text(
                        promotion.buttonText!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}