import 'package:flutter/material.dart';

import '../model/clips_model.dart';

class ClipsScreen extends StatelessWidget {
  ClipsScreen({super.key});

  final List<ClipItem> _clips = [
    ClipItem(
      imageUrl:
          'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      imageUrl:
          'https://images.unsplash.com/photo-1509027572549-2c7b5b02c05a?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      imageUrl:
          'https://images.unsplash.com/photo-1522778119026-d647f0596c20?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adip...',
      views: '2.5M views',
    ),
    ClipItem(
      imageUrl:
          'https://images.unsplash.com/photo-1526244434298-88fcb322fb84?auto=format&fit=crop&w=800&q=80',
      title: 'Excepteur sint occaecat cupidatat non proiden...',
      views: '3.4M views',
    ),
    ClipItem(
      imageUrl:
          'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
    ClipItem(
      imageUrl:
          'https://images.unsplash.com/photo-1509027572549-2c7b5b02c05a?auto=format&fit=crop&w=800&q=80',
      title: 'Lorem ipsum dolor sit amet, consectetur adipi...',
      views: '0.00 views',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3D102F), Color(0xFF180F1E), Color(0xFF0F1018)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 12),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'CLIPS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=200&q=60',
                ),
              ),
            ],
          ),
        ],
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
