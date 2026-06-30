import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'providers/artwork_providers.dart';
import '../collections/providers/collection_providers.dart';
import '../techniques/providers/technique_providers.dart';

class ArtworkFormScreen extends ConsumerStatefulWidget {
  final String? artworkId;

  const ArtworkFormScreen({super.key, this.artworkId});

  @override
  ConsumerState<ArtworkFormScreen> createState() => _ArtworkFormScreenState();
}

class _ArtworkFormScreenState extends ConsumerState<ArtworkFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _artistId;
  List<String> _collectionIds = [];
  List<String> _techniqueIds = [];
  String? _imageUrl;
  String? _thumbnailUrl;
  String? _blurHash;
  double _aspectRatio = 1.0;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.artworkId != null;
    if (_isEditing) {
      _loadArtwork();
    }
  }

  void _loadArtwork() async {
    final artwork = await ref.read(adminArtworkProvider(widget.artworkId!).future);
    if (artwork != null && mounted) {
      setState(() {
        _titleController.text = artwork.title;
        _descriptionController.text = artwork.description ?? '';
        _artistId = artwork.artistId;
        _collectionIds = List.from(artwork.collectionIds);
        _techniqueIds = List.from(artwork.techniqueIds);
        _imageUrl = artwork.imageUrl;
        _thumbnailUrl = artwork.thumbnailUrl;
        _blurHash = artwork.blurHash;
        _aspectRatio = artwork.aspectRatio;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null && file.path == null) return;

    setState(() => _isLoading = true);

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
        folder: 'leoart/artworks',
      );

      final width = (response['width'] as num?)?.toDouble();
      final height = (response['height'] as num?)?.toDouble();

      setState(() {
        _imageUrl = response['secure_url'] as String?;
        _blurHash = response['blurhash'] as String?;
        if (width != null && height != null && height > 0) {
          _aspectRatio = width / height;
        }
        final publicId = response['public_id'] as String?;
        if (publicId != null) {
          _thumbnailUrl = cloudinary.getTransformUrl(
            publicId: publicId,
            width: 400,
            quality: 'auto',
            format: 'auto',
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir imagen: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final artwork = Artwork(
        id: widget.artworkId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrl,
        thumbnailUrl: _thumbnailUrl,
        blurHash: _blurHash,
        artistId: _artistId,
        collectionIds: _collectionIds,
        techniqueIds: _techniqueIds,
        aspectRatio: _aspectRatio,
        published: true,
      );

      if (_isEditing) {
        await ref.read(updateArtworkProvider(artwork).future);
      } else {
        await ref.read(createArtworkProvider(artwork).future);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Obra actualizada' : 'Obra creada')),
        );
        Navigator.of(context).pop();
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
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artistsAsync = ref.watch(adminArtistsProvider);
    final collectionsAsync = ref.watch(adminCollectionsProvider);
    final techniquesAsync = ref.watch(adminTechniquesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar obra' : 'Nueva obra'),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageUploadSection(
                imageUrl: _imageUrl,
                isLoading: _isLoading,
                onTap: _pickAndUploadImage,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.md),
              artistsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Text('Error al cargar artistas'),
                data: (artists) => InputDecorator(
                  decoration: const InputDecoration(labelText: 'Artista'),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _artistId,
                      isDense: true,
                      items: artists
                          .map((a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.name),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _artistId = v),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              collectionsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Text('Error al cargar colecciones'),
                data: (collections) => _MultiSelectChips(
                  label: 'Colecciones',
                  allItems: collections,
                  selectedIds: _collectionIds,
                  onChanged: (ids) => setState(() => _collectionIds = ids),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              techniquesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Text('Error al cargar técnicas'),
                data: (techniques) => _MultiSelectChips(
                  label: 'Técnicas',
                  allItems: techniques,
                  selectedIds: _techniqueIds,
                  onChanged: (ids) => setState(() => _techniqueIds = ids),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageUploadSection extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;
  final VoidCallback onTap;

  const _ImageUploadSection({
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
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
            : imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(imageUrl!, fit: BoxFit.cover),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Toca para cambiar',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Toca para subir imagen',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _MultiSelectChips extends StatelessWidget {
  final String label;
  final List<dynamic> allItems;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChanged;

  const _MultiSelectChips({
    required this.label,
    required this.allItems,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: allItems.map((item) {
            final id = item.id as String?;
            final name = item.name as String? ?? item.title as String? ?? '';
            final selected = id != null && selectedIds.contains(id);
            return FilterChip(
              label: Text(name, style: theme.textTheme.labelSmall),
              selected: selected,
              onSelected: (isSelected) {
                if (id == null) return;
                final newIds = List<String>.from(selectedIds);
                if (isSelected) {
                  newIds.add(id);
                } else {
                  newIds.remove(id);
                }
                onChanged(newIds);
              },
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }
}
