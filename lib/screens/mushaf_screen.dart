import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/storage_service.dart';

class MushafScreen extends StatefulWidget {
  final int initialPage;

  const MushafScreen({super.key, required this.initialPage});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getPagePath(int page) {
    String formattedPage = page.toString().padLeft(3, '0');
    return 'assets/pages/$formattedPage.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الصفحة $_currentPage / 604',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        // Standard Medina Mushaf is 604 pages
        itemCount: 604,
        onPageChanged: (index) {
          int page = index + 1;
          setState(() {
            _currentPage = page;
          });
          StorageService.saveLastPage(page);
        },
        reverse: true, // Mushaf starts from right to left
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Container(
              color: const Color(0xFFF4EAD5), // Beige paper background
              child: Center(
                child: Image.asset(
                  _getPagePath(index + 1),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    String formattedPage = (index + 1).toString().padLeft(3, '0');
                    return CachedNetworkImage(
                      imageUrl: 'https://raw.githubusercontent.com/GovarJabbar/Quran-PNG/master/$formattedPage.png',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                      ),
                      errorWidget: (context, url, err) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          const Text(
                            'فشل تحميل صفحة المصحف.',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'تأكد من تنزيل الصفحات أو تحقق من الإنترنت.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
