import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'providers/settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _appNameController = TextEditingController();
  final _appDescriptionController = TextEditingController();
  final _primaryColorController = TextEditingController();
  final _emailController = TextEditingController();

  String? _logoUrl;
  String? _faviconUrl;
  bool _maintenanceMode = false;
  bool _isSaving = false;
  bool _isLogoLoading = false;
  bool _isFaviconLoading = false;

  final List<_SocialLink> _socialLinks = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await ref.read(adminSettingsProvider.future);
    if (settings != null && mounted) {
      setState(() {
        _appNameController.text = settings.appName;
        _appDescriptionController.text = settings.appDescription ?? '';
        _primaryColorController.text = settings.primaryColor ?? '';
        _emailController.text = settings.email ?? '';
        _logoUrl = settings.logoUrl;
        _faviconUrl = settings.faviconUrl;
        _maintenanceMode = settings.maintenanceMode;
        _socialLinks.clear();
        settings.socialLinks?.forEach((key, value) {
          _socialLinks.add(_SocialLink(key: key, value: value));
        });
      });
    }
  }

  Future<void> _uploadImage({required bool isLogo}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null && file.path == null) return;

    setState(() => isLogo ? _isLogoLoading = true : _isFaviconLoading = true);

    try {
      final cloudinary = ref.read(cloudinaryServiceProvider);
      if (cloudinary == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Cloudinary no configurado')),
          );
        }
        return;
      }

      final bytes = file.bytes ?? await File(file.path!).readAsBytes();

      final response = await cloudinary.uploadBytes(
        bytes: bytes,
        folder: 'leoart/app',
      );

      setState(() {
        if (isLogo) {
          _logoUrl = response['secure_url'] as String?;
        } else {
          _faviconUrl = response['secure_url'] as String?;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir imagen: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLogo ? _isLogoLoading = false : _isFaviconLoading = false);
    }
  }

  void _addSocialLink() {
    setState(() => _socialLinks.add(_SocialLink()));
  }

  void _removeSocialLink(int index) {
    setState(() => _socialLinks.removeAt(index));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final socialLinks = <String, String>{};
      for (final link in _socialLinks) {
        if (link.key.trim().isNotEmpty && link.value.trim().isNotEmpty) {
          socialLinks[link.key.trim()] = link.value.trim();
        }
      }

      final settings = Settings(
        id: 'app',
        appName: _appNameController.text.trim(),
        appDescription: _appDescriptionController.text.trim(),
        primaryColor: _primaryColorController.text.trim(),
        logoUrl: _logoUrl,
        faviconUrl: _faviconUrl,
        email: _emailController.text.trim(),
        socialLinks: socialLinks.isEmpty ? null : socialLinks,
        maintenanceMode: _maintenanceMode,
      );

      final existing = await ref.read(adminSettingsProvider.future);
      if (existing != null) {
        await ref.read(updateSettingsProvider(settings).future);
      } else {
        await ref.read(createSettingsProvider(settings).future);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuración guardada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _appDescriptionController.dispose();
    _primaryColorController.dispose();
    _emailController.dispose();
    for (final link in _socialLinks) {
      link.keyController.dispose();
      link.valueController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Información general', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _appNameController,
                decoration: const InputDecoration(labelText: 'Nombre de la app *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _appDescriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Imágenes', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _ImageUploadCard(
                      label: 'Logo',
                      imageUrl: _logoUrl,
                      isLoading: _isLogoLoading,
                      onTap: () => _uploadImage(isLogo: true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ImageUploadCard(
                      label: 'Favicon',
                      imageUrl: _faviconUrl,
                      isLoading: _isFaviconLoading,
                      onTap: () => _uploadImage(isLogo: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Apariencia', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _ColorField(
                hexColor: _primaryColorController.text,
                onChanged: (hex) => setState(() => _primaryColorController.text = hex),
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                title: const Text('Modo mantenimiento'),
                subtitle: const Text('Deshabilita el acceso público a la app'),
                value: _maintenanceMode,
                onChanged: (v) => setState(() => _maintenanceMode = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Contacto', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email de contacto'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text('Redes sociales', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: _addSocialLink,
                    label: const Text('Añadir'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ..._socialLinks.asMap().entries.map((entry) {
                final index = entry.key;
                final link = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: link.keyController,
                          decoration: const InputDecoration(
                            labelText: 'Plataforma',
                            hintText: 'instagram',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: link.valueController,
                          decoration: const InputDecoration(
                            labelText: 'URL',
                            hintText: 'https://instagram.com/...',
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: theme.colorScheme.error),
                        onPressed: () => _removeSocialLink(index),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

}
class _ColorField extends StatelessWidget {
  final String hexColor;
  final ValueChanged<String> onChanged;

  const _ColorField({required this.hexColor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = hexColor.isNotEmpty ? _parseHex(hexColor) : Colors.grey;

    return InkWell(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (_) => _ColorPickerDialog(initialHex: hexColor),
        );
        if (result != null) onChanged(result);
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Color primario',
          hintText: '#D8A84A',
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              hexColor.isNotEmpty ? hexColor.toUpperCase() : 'Toca para elegir',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hexColor.isNotEmpty ? null : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _parseHex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length != 6) return Colors.grey;
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final String initialHex;

  const _ColorPickerDialog({required this.initialHex});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late String _hex;
  late double _hue;

  static const _presetColors = [
    '#D8A84A', '#E53935', '#D81B60', '#8E24AA',
    '#5E35B1', '#3949AB', '#1E88E5', '#039BE5',
    '#00ACC1', '#00897B', '#43A047', '#7CB342',
    '#C0CA33', '#FDD835', '#FFB300', '#FB8C00',
    '#F4511E', '#6D4C41', '#757575', '#546E7A',
    '#000000', '#FFFFFF', '#F5F5F5', '#212121',
  ];

  @override
  void initState() {
    super.initState();
    _hex = widget.initialHex.isEmpty ? '#D8A84A' : widget.initialHex.toUpperCase();
    _hue = _colorToHue(_hexToColor(_hex));
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length != 6) return Colors.grey;
    return Color(int.parse('FF$hex', radix: 16));
  }

  double _colorToHue(Color color) {
    return HSLColor.fromColor(color).hue;
  }

  String _hueToHex(double hue) {
    final color = HSLColor.fromAHSL(1.0, hue, 0.8, 0.55);
    final r = (color.toColor().r * 255).round().clamp(0, 255);
    final g = (color.toColor().g * 255).round().clamp(0, 255);
    final b = (color.toColor().b * 255).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${g.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _hexToColor(_hex);

    return AlertDialog(
      title: const Text('Color primario'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(80),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                _hex,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Predefinidos', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _presetColors.map((presetHex) {
                final presetColor = _hexToColor(presetHex);
                final isSelected = _hex == presetHex;
                return GestureDetector(
                  onTap: () => setState(() {
                    _hex = presetHex;
                    _hue = _colorToHue(presetColor);
                  }),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: presetColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Personalizado', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Text('Hue', style: TextStyle(fontSize: 12)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    ),
                    child: Slider(
                      value: _hue,
                      min: 0,
                      max: 360,
                      divisions: 360,
                      activeColor: _hexToColor(_hueToHex(_hue)),
                      onChanged: (v) => setState(() {
                        _hue = v;
                        _hex = _hueToHex(v);
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_hex),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

class _SocialLink {
  final TextEditingController keyController;
  final TextEditingController valueController;

  _SocialLink({String key = '', String value = ''})
      : keyController = TextEditingController(text: key),
        valueController = TextEditingController(text: value);

  String get key => keyController.text;
  String get value => valueController.text;
}

class _ImageUploadCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool isLoading;
  final VoidCallback onTap;

  const _ImageUploadCard({
    required this.label,
    required this.imageUrl,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
            : imageUrl != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.network(imageUrl!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(AppRadius.md),
                            ),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 32,
                          color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                    ],
                  ),
      ),
    );
  }
}
