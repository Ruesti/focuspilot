import 'package:flutter/material.dart';
import 'package:focuspilot/widgets/stacked_carousel.dart';
import 'gpt_chat_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 2000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header minimal
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                  child: Row(
                    children: [
                      Text(
                        "Hi Uli",
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings_rounded),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Zentrum
                Expanded(
                  child: Center(
                    child: StackedCardCarousel(
                      height: 700,
                      overlapX: 110,       // steuert Overlap (kleiner = mehr Overlap)
                      sideScale: 0.92,    // Größe der Seitenkarten
                      sideOpacity: 0.88,  // Sichtbarkeit der Seitenkarten
                      neighbors: 2, // optional: 5 Karten statt 3
                      dragPixelsPerCard: 460,       // mehr Mausweg pro Karte => weniger versehentlich wechseln
commitThresholdCards: 0.60,   // muss weiter “über die Mitte” gezogen werden, bevor es wechselt
flingVelocity: 1400,          // schneller Flick nötig, sonst bleibt er auf der Karte

                      items: [
                        StackedCarouselItem(
                          id: 'gpt',
                          card: const _GPTPreviewCard(),
                          fullScreen: const GPTChatPage(),
                        ),
                        StackedCarouselItem(
                          id: 'day',
                          card: const _SimplePreviewCard(
                            title: "Mein Tag",
                            subtitle: "Heute: 1 Fokusblock. 1 kleiner Erfolg.",
                            icon: Icons.today_rounded,
                            badge: "Co-Pilot",
                          ),
                          fullScreen: const _PlaceholderFull(title: "Mein Tag"),
                        ),
                        StackedCarouselItem(
                          id: 'journal',
                          card: const _SimplePreviewCard(
                            title: "Journal",
                            subtitle: "Ein Satz reicht. FokusPilot merkt sich den Kontext.",
                            icon: Icons.article_rounded,
                            badge: "Markdown",
                          ),
                          fullScreen: const _PlaceholderFull(title: "Journal"),
                        ),
                      ],
                    ),
                  ),
                ),

                // Optional: unten leer lassen / später bottom nav
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GPTPreviewCard extends StatelessWidget {
  const _GPTPreviewCard();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      color: cs.surface.withOpacity(0.001), // Shell macht den Clay-Look
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: cs.primaryContainer.withOpacity(0.55),
                ),
                child: Icon(Icons.chat_bubble_rounded, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "GPT-Chat",
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              _Badge(text: "Zentrum"),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Was ist das eine Ding, das heute wirklich zählen würde?",
            style: t.bodyLarge?.copyWith(
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Zieh die Karte nach oben für Vollbild.",
            style: t.bodyMedium?.copyWith(
              color: t.bodyMedium?.color?.withOpacity(0.70),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                "Vollbild öffnen",
                style: t.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_upward_rounded, size: 18, color: cs.primary),
            ],
          )
        ],
      ),
    );
  }
}

class _SimplePreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String badge;

  const _SimplePreviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: cs.secondaryContainer.withOpacity(0.55),
                ),
                child: Icon(icon, color: cs.onSecondaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              ),
              _Badge(text: badge),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: t.bodyLarge?.copyWith(height: 1.25, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            "nach oben ziehen",
            style: t.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
      ),
      child: Text(
        text,
        style: t.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.onTertiaryContainer,
        ),
      ),
    );
  }
}

class _PlaceholderFull extends StatelessWidget {
  final String title;
  const _PlaceholderFull({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
