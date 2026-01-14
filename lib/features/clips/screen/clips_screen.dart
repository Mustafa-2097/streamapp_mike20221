import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/core/common/widgets/scaffold_bg.dart';

import '../model/clips_model.dart';

class ClipsScreen extends StatelessWidget {
  ClipsScreen({super.key});

  final List<ClipItem> _clips = [
    ClipItem(
      imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      imageUrl: 'https://images.unsplash.com/photo-1509027572549-2c7b5b02c05a?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      imageUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adip...',
      views: '2.5M views',
    ),
    ClipItem(
      imageUrl: 'https://images.unsplash.com/photo-1526244434298-88fcb322fb84?auto=format&fit=crop&w=800&q=80',
      title: 'Excepteur sint occaecat cupidatat non proiden...',
      views: '3.4M views',
    ),
    ClipItem(
      imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      imageUrl: 'https://images.unsplash.com/photo-1509027572549-2c7b5b02c05a?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: Text(
          'CLIPS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ScaffoldBg(
        child: SafeArea(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.64,
                    ),
                itemCount: _clips.length,
                itemBuilder: (context, index) {
                  final clip = _clips[index];
                  return _ClipCard(clip: clip);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClipCard extends StatelessWidget {
  const _ClipCard({required this.clip});

  final ClipItem clip;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(clip.imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clip.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  clip.views,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
