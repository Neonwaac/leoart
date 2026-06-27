import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../providers/artist_providers.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistAsync = ref.watch(artistProvider);
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppSpacing.breakpointMedium;

    return Column(
      children: [
        const LeoAppBar(),
        Expanded(
          child: AsyncStateBuilder<Artist?>(
            value: artistAsync,
            loading: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            error: (err, stack) => ErrorView(
              message: 'Error al cargar artista',
              details: err.toString(),
              icon: Icons.cloud_off_rounded,
              onRetry: () => ref.invalidate(artistProvider),
            ),
            builder: (artist) {
              if (artist == null) {
                return ErrorView(
                  message: 'Artist document not found',
                  details:
                      'No se encontró el documento "artist" en la colección "artists". '
                      'Verifica que exista en Firebase Console.',
                  icon: Icons.find_replace_rounded,
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.slow,
                        child: _HeroSection(artist: artist),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: FadeAnimation(
                        child: SlideAnimation(
                          begin: const Offset(0, 0.04),
                          duration: AppDurations.slow,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: AppDivider(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.slow,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: _ContactContent(artist: artist, isWide: isWide),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.slow,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.xl,
                          ),
                          child: _ActionButtons(theme: theme),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final Artist artist;

  const _HeroSection({required this.artist});

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        artist.photoUrl != null && artist.photoUrl!.isNotEmpty;

    return Hero(
      tag: 'contact_hero',
      child: AspectRatio(
        aspectRatio: 21 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surfaceContainerHigh,
                  Theme.of(context).colorScheme.surfaceContainerLow,
                ],
              ),
            ),
            child: hasPhoto
                ? Image.network(
                    artist.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _heroPlaceholder(context),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _heroPlaceholder(context);
                    },
                  )
                : _heroPlaceholder(context),
          ),
        ),
      ),
    );
  }

  Widget _heroPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Icon(
        Icons.mail_outline,
        size: 56,
        color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
      ),
    );
  }
}

class _ContactContent extends StatelessWidget {
  final Artist artist;
  final bool isWide;

  const _ContactContent({
    required this.artist,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final contactColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informaci\u00f3n de contacto',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (artist.email != null)
          InfoRow(
            icon: Icons.mail_outline,
            title: 'Correo electr\u00f3nico',
            value: artist.email!,
          ),
        if (artist.email != null && artist.website != null)
          const SizedBox(height: AppSpacing.sm),
        if (artist.website != null)
          InfoRow(
            icon: Icons.language,
            title: 'Sitio web',
            value: artist.website!,
          ),
        if (artist.website != null)
          const SizedBox(height: AppSpacing.sm),
        if (artist.location != null)
          InfoRow(
            icon: Icons.place_outlined,
            title: 'Ubicaci\u00f3n',
            value: artist.location!,
          ),
      ],
    );

    final socialColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Redes sociales',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SocialLinksRow(links: artist.socialLinks),
      ],
    );

    if (isWide) {
      return Center(
        child: SizedBox(
          width: 880,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: contactColumn),
              const SizedBox(width: AppSpacing.xl),
              Expanded(child: socialColumn),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        contactColumn,
        const SizedBox(height: AppSpacing.xl),
        socialColumn,
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ThemeData theme;

  const _ActionButtons({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 52,
              child: PrimaryButton(
                label: 'Contactar',
                icon: Icons.send_outlined,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 52,
              child: SecondaryButton(
                label: 'Ver cat\u00e1logo',
                icon: Icons.arrow_forward,
                onPressed: () => context.push('/catalog'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
