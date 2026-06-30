import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'providers/technique_providers.dart';

class TechniqueFormScreen extends ConsumerStatefulWidget {
  final String? techniqueId;

  const TechniqueFormScreen({super.key, this.techniqueId});

  @override
  ConsumerState<TechniqueFormScreen> createState() => _TechniqueFormScreenState();
}

class _TechniqueFormScreenState extends ConsumerState<TechniqueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _published = true;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.techniqueId != null;
    if (_isEditing) {
      _loadTechnique();
    }
  }

  void _loadTechnique() async {
    final technique = await ref.read(adminTechniqueProvider(widget.techniqueId!).future);
    if (technique != null && mounted) {
      setState(() {
        _nameController.text = technique.name;
        _descriptionController.text = technique.description ?? '';
        _published = technique.published;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final technique = Technique(
        id: widget.techniqueId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        published: _published,
      );

      if (_isEditing) {
        await ref.read(updateTechniqueProvider(technique).future);
      } else {
        await ref.read(createTechniqueProvider(technique).future);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Técnica actualizada' : 'Técnica creada')),
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
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar técnica' : 'Nueva técnica'),
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.md),
              CheckboxMenuButton(
                value: _published,
                onChanged: (v) => setState(() => _published = v ?? true),
                child: const Text('Publicado'),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
