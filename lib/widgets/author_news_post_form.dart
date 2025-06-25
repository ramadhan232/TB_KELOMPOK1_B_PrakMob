import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/author_news_controller.dart';
import '../model/author_news_model.dart';

class AuthorNewsPostForm extends StatefulWidget {
  const AuthorNewsPostForm({super.key});

  @override
  State<AuthorNewsPostForm> createState() => _AuthorNewsPostFormState();
}

class _AuthorNewsPostFormState extends State<AuthorNewsPostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    final controller = context.read<AuthorNewsController>();
    final news = AuthorNewsModel(
      id: '',
      title: _titleController.text,
      slug: _titleController.text.toLowerCase().replaceAll(' ', '-'),
      summary: _summaryController.text,
      content: _contentController.text,
      featuredImageUrl: _imageController.text,
      category: _categoryController.text,
      tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
      publishedAt: DateTime.now().toIso8601String(),
      viewCount: 0,
      createdAt: '',
      updatedAt: '',
      isPublished: true,
    );

    final success = await controller.postNews(news);
    if (success) {
      controller.fetchAllNews(); // ← update daftar
    }
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Berita berhasil ditambahkan'
                : 'Gagal menambahkan berita',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tambah Berita',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Ringkasan'),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Konten'),
                minLines: 3,
                maxLines: 5,
                validator:
                    (value) =>
                        value == null || value.length < 10
                            ? 'Minimal 10 karakter'
                            : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (opsional)',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL gambar wajib diisi';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null ||
                      !uri.hasAbsolutePath ||
                      !(uri.scheme == 'http' || uri.scheme == 'https')) {
                    return 'Masukkan URL yang valid';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tag (pisahkan dengan koma)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Kirim')),
            ],
          ),
        ),
      ),
    );
  }
}
