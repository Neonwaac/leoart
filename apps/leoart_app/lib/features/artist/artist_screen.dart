import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../providers/artist_providers.dart';
import 'widgets/artist_biography.dart';
import 'widgets/artist_header.dart';
import 'widgets/contact_info_section.dart';

class ArtistScreen extends ConsumerWidget {
  const ArtistScreen({super.key});

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
                        duration: AppDurations.fast,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          child: ArtistHeader(
                            artist: artist,
                            quote: artist.quote ?? '',
                            profession: artist.profession,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.fast,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: AppDivider(),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (artist.bio != null)
                      FadeAnimation(
                        child: SlideAnimation(
                          begin: const Offset(0, 0.04),
                          duration: AppDurations.fast,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: ArtistBiography(text: artist.bio!),
                          ),
                        ),
                      ),
                    if (artist.bio != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      FadeAnimation(
                        child: SlideAnimation(
                          begin: const Offset(0, 0.04),
                          duration: AppDurations.fast,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: AppDivider(),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.fast,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: _SocialAndContact(
                            artist: artist,
                            isWide: isWide,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.fast,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.xl,
                          ),
                          child: Center(
                            child: _CatalogButton(theme: theme),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.fast,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: AppDivider(),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeAnimation(
                      child: SlideAnimation(
                        begin: const Offset(0, 0.04),
                        duration: AppDurations.fast,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            0,
                            AppSpacing.md,
                            AppSpacing.xl,
                          ),
                          child: Center(
                            child: _ContactCta(theme: theme),
                          ),
                        ),
                      ),
                    ),
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

class _SocialAndContact extends StatelessWidget {
  final Artist artist;
  final bool isWide;

  const _SocialAndContact({required this.artist, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final socialSection = EditorialSection(
      title: 'Redes sociales',
      padding: EdgeInsets.zero,
      child: SocialLinksRow(links: artist.socialLinks),
    );

    final contactSection = ContactInfoSection(
      email: artist.email,
      website: artist.website,
      location: artist.location,
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: socialSection),
          const SizedBox(width: AppSpacing.xl),
          Expanded(child: contactSection),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        socialSection,
        const SizedBox(height: AppSpacing.md),
        contactSection,
      ],
    );
  }
}

class _CatalogButton extends StatelessWidget {
  final ThemeData theme;

  const _CatalogButton({required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => context.push('/catalog'),
        icon: const Icon(Icons.arrow_forward, size: 18),
        label: const Text('Ver todas las obras'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            color: theme.colorScheme.outline.withAlpha(120),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      ),
    );
  }
}

class _ContactCta extends StatelessWidget {
  final ThemeData theme;

  const _ContactCta({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 640,
        child: Column(
          children: [
            Text(
              '\u00bfTe interesa una obra?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Si deseas adquirir una pieza, realizar una consulta o '
              'iniciar una colaboraci\u00f3n art\u00edstica, ser\u00e1 un '
              'placer conversar contigo.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/contact'),
                icon: const Icon(Icons.send_outlined, size: 18),
                label: const Text('Contactar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  side: BorderSide(
                    color: theme.colorScheme.outline.withAlpha(120),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
