import 'package:flutter/material.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  String _selectedCategory = 'App Experience';
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  final List<String> _categories = [
    'App Experience',
    'Parking Lot Quality',
    'Payment Process',
    'Customer Support',
  ];

  // Colors aligned with your app's theme
  static const Color appTealStart = Color(0xFF2E7D73); // Light/Main Teal
  static const Color appTealEnd = Color(0xFF1E524C); // Darker Teal for gradient
  static const Color appMint = Color(
    0xFF3AB4A6,
  ); // Mint Green for active button
  static const Color textDark = Colors.black; // Solid Black for questions
  static const Color textMuted = Color(0xFF475569); // Subtle slate color

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: Column(
        children: [
          // ── Beautiful Curved Header (My Bookings style) ──────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [appTealStart, appTealEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Give Feedback',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Share your thoughts to help us improve',
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),

          // ── Scrollable Feedback Form ────────────────────────────────────────
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ), // Perfect for laptop/mobile alignment
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Categories
                      const Text(
                        'What would you like to give feedback about?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : textDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            selected: isSelected,
                            selectedColor: appTealStart,
                            backgroundColor: const Color(0xFFF1F5F9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? appTealStart
                                    : const Color(0xFFCBD5E1),
                                width: 1.2,
                              ),
                            ),
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedCategory = category);
                              }
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 28),

                      // Section 2: Star Rating
                      const Text(
                        'How would you rate your experience?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isSelected = starIndex <= _rating;
                          return GestureDetector(
                            onTap: () => setState(() => _rating = starIndex),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: isSelected
                                    ? const Color(0xFFFFB300)
                                    : const Color(0xFF94A3B8),
                                size: 42,
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 28),

                      // Section 3: Comments Box
                      const Text(
                        'Additional comments (optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 5,
                          maxLength: 500,
                          style: const TextStyle(color: textDark, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Type your feedback here...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFCBD5E1),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: appTealStart,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            counterStyle: const TextStyle(
                              color: textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Section 4: Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appMint,
                            foregroundColor: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            shadowColor: appMint.withValues(alpha: 0.3),
                          ),
                          onPressed: _rating == 0
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Thank you for your valuable feedback! ✓',
                                      ),
                                      backgroundColor: appTealStart,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                  Navigator.maybePop(context);
                                },
                          child: const Text(
                            'Submit Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
