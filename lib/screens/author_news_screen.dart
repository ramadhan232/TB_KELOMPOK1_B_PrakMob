import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/author_news_controller.dart';
import '../widgets/author_news_list_item.dart';
import '../widgets/author_news_post_form.dart';
import '../widgets/author_news_detail_form.dart';

class AuthorNewsScreen extends StatefulWidget {
  const AuthorNewsScreen({super.key});

  @override
  State<AuthorNewsScreen> createState() => _AuthorNewsScreenState();
}

class _AuthorNewsScreenState extends State<AuthorNewsScreen> {
  String? selectedNewsId;
  bool showSnackBarAfterClose = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthorNewsController>().fetchAllNews();
    });
  }

  void openDetail(String id) {
    setState(() {
      selectedNewsId = id;
    });
  }

  void closeDetail({bool refresh = false}) {
    setState(() {
      selectedNewsId = null;
      showSnackBarAfterClose = refresh;
    });
    if (refresh) {
      context.read<AuthorNewsController>().fetchAllNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<AuthorNewsController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.error != null) {
                return Center(child: Text(controller.error!));
              }
              return ListView.builder(
                itemCount: controller.newsList.length,
                itemBuilder: (context, index) {
                  final news = controller.newsList[index];
                  return AuthorNewsListItem(
                    news: news,
                    onTap: () => openDetail(news.id),
                  );
                },
              );
            },
          ),

          /// FORM DETAIL TAMPIL DI ATAS SECARA PENUH
          if (selectedNewsId != null)
            Positioned.fill(
              child: Material(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      AppBar(
                        title: const Text('Edit Berita'),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => closeDetail(refresh: true),
                        ),
                      ),
                      Expanded(
                        child: AuthorNewsDetailForm(
                          newsId: selectedNewsId!,
                          onClose: () => closeDetail(refresh: false),
                          onSubmitSuccess: () => closeDetail(refresh: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AuthorNewsPostForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
