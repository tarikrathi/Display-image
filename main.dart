import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Web Image Viewer', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String _currentImageUrl = '';

  @override
  void initState() {
    super.initState();
    // Register the view factory
    ui.platformViewRegistry.registerViewFactory(
      'imageElement',
      (int viewId) => ImageElement()..style.border = 'none',
    );
  }

  void _loadImage() {
    setState(() {
      _currentImageUrl = _urlController.text;
    });
    _updateImageElement();
  }

  void _updateImageElement() {
    final imageElement = html.document.getElementById('imageElement') as html.ImageElement?;
    if (imageElement != null) {
      imageElement.src = _currentImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web Image Viewer')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _currentImageUrl.isNotEmpty
                      ? HtmlElementView(
                          viewType: 'imageElement',
                          onPlatformViewCreated: (_) {
                            _updateImageElement();
                            _setupFullscreenToggle();
                          },
                        )
                      : const Center(child: Text('No image loaded')),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loadImage,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  void _setupFullscreenToggle() {
    html.document.getElementById('imageElement')?.addEventListener('dblclick', (event) {
      _toggleFullscreen();
    });
  }

  void _toggleFullscreen() {
    html.document.documentElement?.requestFullscreen();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

