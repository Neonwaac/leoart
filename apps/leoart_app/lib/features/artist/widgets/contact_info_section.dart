import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ContactInfoSection extends StatelessWidget {
  final String? email;
  final String? website;
  final String? location;

  const ContactInfoSection({
    super.key,
    this.email,
    this.website,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: 680,
        child: EditorialSection(
          title: 'Contacto',
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (email != null) ...[
                _ContactRow(
                  icon: Icons.mail_outline,
                  label: email!,
                  theme: theme,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (website != null) ...[
                _ContactRow(
                  icon: Icons.language,
                  label: website!,
                  theme: theme,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (location != null)
                _ContactRow(
                  icon: Icons.place_outlined,
                  label: location!,
                  theme: theme,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
