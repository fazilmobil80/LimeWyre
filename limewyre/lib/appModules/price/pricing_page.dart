import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  String currency = 'USD'; // or 'INR'
  bool yearly = true;

  // Hardcoded placeholder prices. Replace with backend values later.
  final Map<String, Map<String, Map<String, num>>> prices = {
    // currency -> billing -> plan -> price
    'USD': {
      'monthly': {
        'pro': 4.99,
        'premium': 9.99,
        'lifetime': 79, // one-time
      },
      'yearly': {'pro': 39, 'premium': 79, 'lifetime': 79},
    },
    'INR': {
      'monthly': {'pro': 399, 'premium': 799, 'lifetime': 4999},
      'yearly': {'pro': 3199, 'premium': 6399, 'lifetime': 4999},
    },
  };

  String symbolFor(String cur) => cur == 'USD' ? '\$' : '₹';

  String formatPrice(num value, String cur) {
    // For USD show decimal (e.g. $39), for INR show integer
    if (cur == 'USD') {
      final f = NumberFormat("#,##0.##", "en_US");
      return f.format(value);
    } else {
      final f = NumberFormat("#,##0", "en_IN");
      return f.format(value.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    String country = Localizations.localeOf(context).countryCode ?? '';
    print('aaaaaaaaaaaaaaaaaaaaaaaa ===== $country');
    final theme = Theme.of(context);
    final bg = const Color(0xFFF7F8FB);
    final purple = const Color(0xFF5B4BFF);
    final proPrice = prices[currency]![yearly ? 'yearly' : 'monthly']!['pro']!;
    final premiumPrice =
        prices[currency]![yearly ? 'yearly' : 'monthly']!['premium']!;
    final lifetimePrice =
        prices[currency]![yearly ? 'yearly' : 'monthly']!['lifetime']!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Pricing",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          // Currency toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFFF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [_currencyButton('USD'), _currencyButton('INR')],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Center(
                child: Text(
                  "Choose Your Plan",
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Billing toggle (Monthly / Yearly)
              Center(child: _billingToggle()),

              const SizedBox(height: 18),

              // Starter / Free card
              _planCard(
                icon: Icons.auto_awesome_outlined,
                iconBg: const Color(0xFFF4F7FF),
                badge: null,
                title: "Starter",
                priceLabel: "Free",
                ctaText: "Current",
                ctaIsEnabled: false,
                features: const [
                  "200 notes",
                  "10 AI queries/day",
                  "Basic features",
                ],
                borderColor: Colors.grey.shade300,
              ),

              const SizedBox(height: 12),

              // Pro (Popular)
              Stack(
                children: [
                  _planCard(
                    icon: Icons.flash_on_outlined,
                    iconBg: const Color(0xFFF0F6FF),
                    badge: null, // handled by overlay
                    title: "Pro",
                    priceLabel:
                        "${symbolFor(currency)}${formatPrice(proPrice, currency)}${yearly ? '/yr' : '/mo'}",
                    ctaText: "Upgrade",
                    ctaIsEnabled: true,
                    features: [
                      "Unlimited notes & AI",
                      "3 devices, exports, analytics",
                    ],
                    borderColor: purple.withValues(alpha: 0.35),
                  ),
                  // Popular badge
                  Positioned(
                    left: 12,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        "POPULAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Premium (Best Value)
              Stack(
                children: [
                  _planCard(
                    icon: Iconsax.crown1,
                    iconBg: const Color(0xFFFFF6EB),
                    badge: null,
                    title: "Premium",
                    priceLabel:
                        "${symbolFor(currency)}${formatPrice(premiumPrice, currency)}${yearly ? '/yr' : '/mo'}",
                    ctaText: "Upgrade",
                    ctaIsEnabled: true,
                    features: [
                      "Everything in Pro +",
                      "Voice, OCR, advanced AI",
                    ],
                    borderColor: const Color(0xFFFFCE7A).withValues(alpha: 0.8),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFF6EB),
                        const Color(0xFFFFF0DC),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  Positioned(
                    left: 12,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9A37),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        "BEST VALUE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Lifetime (Limited time)
              Stack(
                children: [
                  _planCard(
                    icon: Icons.flash_on_outlined,
                    iconBg: const Color(0xFFEFF9FF),
                    badge: null,
                    title: "Lifetime",
                    priceLabel:
                        "${symbolFor(currency)}${formatPrice(lifetimePrice, currency)}${yearly ? '/once' : '/once'}",
                    ctaText: "Get It",
                    ctaIsEnabled: true,
                    features: ["All Pro features", "No recurring payments"],
                    borderColor: const Color(0xFF9ED9FF).withValues(alpha: 0.8),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEFF9FF),
                        const Color(0xFFF4FBFF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3AB3FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        "LIMITED TIME",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currencyButton(String code) {
    final selected = currency == code;
    return GestureDetector(
      onTap: () => setState(() => currency = code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          code,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF5B4BFF) : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _billingToggle() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => yearly = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: yearly ? Colors.transparent : const Color(0xFFF4F7FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                "Monthly",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(() => yearly = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: yearly ? const Color(0xFFF4F7FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  const Text(
                    "Yearly",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FFF2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "Save 34%",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF10A661),
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _planCard({
    required IconData icon,
    required Color iconBg,
    String? badge,
    required String title,
    required String priceLabel,
    required String ctaText,
    required bool ctaIsEnabled,
    required List<String> features,
    required Color borderColor,
    LinearGradient? gradient,
  }) {
    final purple = const Color(0xFF5B4BFF);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black87, size: 30),
          ),
          const SizedBox(width: 16),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title and CTA
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // CTA
                    ElevatedButton(
                      onPressed: ctaIsEnabled ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ctaIsEnabled
                            ? purple
                            : Colors.grey.shade200,
                        foregroundColor: ctaIsEnabled
                            ? Colors.white
                            : Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(ctaText),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // price
                Text(
                  priceLabel,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // features
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: features
                      .map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(Icons.check, size: 18, color: purple),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
