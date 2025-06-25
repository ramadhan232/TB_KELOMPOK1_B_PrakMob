import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/author_news_controller.dart';
import '../model/author_news_model.dart';

class AuthorNewsDetailForm extends StatefulWidget {
  final String newsId;
  final VoidCallback? onClose;
  final VoidCallback? onSubmitSuccess;

  const AuthorNewsDetailForm({
    super.key,
    required this.newsId,
    this.onClose,
    this.onSubmitSuccess,
  });

  @override
  State<AuthorNewsDetailForm> createState() => _AuthorNewsDetailFormState();
}

class _AuthorNewsDetailFormState extends State<AuthorNewsDetailForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNews();
    });
  }

  Future<void> _loadNews() async {
    final controller = context.read<AuthorNewsController>();
    await controller.fetchNewsById(widget.newsId);
    final news = controller.news;
    if (news != null) {
      _titleController.text = news.title;
      _summaryController.text = news.summary;
      _contentController.text = news.content;
      _imageController.text = news.featuredImageUrl;
      _categoryController.text = news.category;
      _tagsController.text = news.tags.join(', ');
    }
    setState(() => _loading = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = context.read<AuthorNewsController>();
    final updatedNews = AuthorNewsModel(
      id: widget.newsId,
      title: _titleController.text,
      slug: _titleController.text.toLowerCase().replaceAll(' ', '-'),
      summary: _summaryController.text,
      content: _contentController.text,
      featuredImageUrl:
          _imageController.text.isNotEmpty
              ? _imageController.text
              : controller.news?.featuredImageUrl ?? '',
      category: _categoryController.text,
      tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
      publishedAt: DateTime.now().toIso8601String(),
      viewCount: 0,
      createdAt: '',
      updatedAt: '',
      isPublished: true,
    );
    final success = await controller.updateNewsById(widget.newsId, updatedNews);
    if (success && mounted) {
      widget.onClose?.call();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berita diperbarui')));
      widget.onSubmitSuccess?.call();
    }
  }

  Future<void> _delete() async {
    final controller = context.read<AuthorNewsController>();
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            title: const Text('Hapus Berita?'),
            content: const Text('Berita akan dihapus secara permanen.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      final success = await controller.deleteNewsById(widget.newsId);
      if (success && mounted) {
        widget.onClose?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berita berhasil dihapus')),
        );
        widget.onSubmitSuccess?.call();
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        )
        : SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Edit Berita',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
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
                      (v) =>
                          v == null || v.length < 10
                              ? 'Minimal 10 karakter'
                              : null,
                ),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'URL Gambar'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tag (pisahkan koma)',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Simpan Perubahan'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _delete,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Hapus Berita'),
                ),
              ],
            ),
          ),
        );
  }
}
