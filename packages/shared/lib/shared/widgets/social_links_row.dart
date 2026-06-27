import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';
import 'package:shared/core/design/app_spacing.dart';

class SocialLinksRow extends StatelessWidget {
  final Map<String, String>? links;

  const SocialLinksRow({super.key, this.links});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (links == null || links!.isEmpty) return const SizedBox.shrink();

    final entries = links!.entries.toList();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: entries.map((entry) {
        final info = _networkInfo(entry.key);
        return _SocialLinkChip(
          label: info.$1,
          icon: info.$2,
          theme: theme,
        );
      }).toList(),
    );
  }

  (String, IconData) _networkInfo(String network) {
    return switch (network) {
      'instagram' => ('Instagram', Icons.photo_camera_outlined),
      'twitter' => ('Twitter', Icons.chat_outlined),
      'facebook' => ('Facebook', Icons.people_outlined),
      'tiktok' => ('TikTok', Icons.music_note_outlined),
      'youtube' => ('YouTube', Icons.play_circle_outlined),
      'behance' => ('Behance', Icons.design_services_outlined),
      'website' => ('Sitio web', Icons.language),
      _ => (network, Icons.link),
    };
  }
}

class _SocialLinkChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeData theme;

  const _SocialLinkChip({
    required this.label,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(80),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
