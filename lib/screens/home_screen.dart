import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import 'mushaf_screen.dart';

import '../services/quran_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final page = await StorageService.getLastPage();
    setState(() {
      _lastPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'القرآن الكريم',
                style: GoogleFonts.amiri(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0C3E26), Color(0xFF1B5E20)],
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: FaIcon(
                      FontAwesomeIcons.quran,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContinueReading(),
                  const SizedBox(height: 24),
                  Text(
                    'فهرس السور',
                    style: GoogleFonts.amiri(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0C3E26),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          _buildSurahList(),
        ],
      ),
    );
  }

  Widget _buildContinueReading() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MushafScreen(initialPage: _lastPage),
          ),
        );
        _loadProgress();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.bookOpen,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'متابعة القراءة',
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'الصفحة الأخيرة: $_lastPage',
                    style: GoogleFonts.amiri(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final surah = QuranData.surahs[index];
        return ListTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.certificate,
                color: Color(0xFF0C3E26),
                size: 36,
              ),
              Text(
                '${surah.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          title: Text(
            surah.name,
            style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          subtitle: Text('${surah.numberOfAyahs} آية', style: GoogleFonts.amiri(fontSize: 16)),
          trailing: Text(
            'صفحة ${surah.startPage}',
            style: GoogleFonts.amiri(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MushafScreen(initialPage: surah.startPage),
              ),
            );
            _loadProgress();
          },
        );
      }, childCount: QuranData.surahs.length),
    );
  }
}
