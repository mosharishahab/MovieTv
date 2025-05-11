# TV Movie App Setup Script
# Save this file as setup-tv-movie-app.ps1 and run with PowerShell

Write-Host "======================================"
Write-Host "TV Movie App Project Generator"
Write-Host "======================================"
Write-Host ""

# Check if Flutter is installed
try {
    $flutterVersion = flutter --version
    Write-Host "Flutter is installed. Creating TV Movie App project..."
} catch {
    Write-Host "Flutter not found. Please install Flutter first."
    Write-Host "Visit https://flutter.dev/docs/get-started/install/windows"
    exit 1
}

# Create a project directory
$projectPath = "tv_movie_app"
Write-Host "Creating project at: $projectPath"

# Create Flutter project
flutter create --org com.yourdomain --platforms=android,windows $projectPath

# Navigate to project directory
Set-Location $projectPath

# Update pubspec.yaml
$pubspecContent = @"
name: tv_movie_app
description: A TV Movie streaming app similar to Apple TV+.

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  video_player: ^2.8.1
  cached_network_image: ^3.3.0
  flutter_riverpod: ^2.4.9
  go_router: ^12.1.3
  http: ^1.1.0
  flutter_animate: ^4.5.0 
  hive: ^2.2.3
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
"@

Set-Content -Path "pubspec.yaml" -Value $pubspecContent

# Create folder structure
Write-Host "Creating folder structure..."
New-Item -ItemType Directory -Path "lib\models" -Force
New-Item -ItemType Directory -Path "lib\screens" -Force
New-Item -ItemType Directory -Path "lib\widgets" -Force
New-Item -ItemType Directory -Path "lib\utils" -Force
New-Item -ItemType Directory -Path "assets\images" -Force

# Create content model
$contentModelCode = @"
enum ContentType { movie, series, documentary }

class Content {
  final String id;
  final String title;
  final String description;
  final String fullDescription;
  final String thumbnailUrl;
  final String backdropUrl;
  final String logoUrl;
  final int year;
  final String ageRating;
  final ContentType contentType;
  final String genre;
  final int seasons;
  final int duration;
  final List<Episode>? episodes;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.thumbnailUrl,
    required this.backdropUrl,
    required this.logoUrl,
    required this.year,
    required this.ageRating,
    required this.contentType,
    required this.genre,
    this.seasons = 0,
    this.duration = 0,
    this.episodes,
  });
}

class Episode {
  final String id;
  final int season;
  final int number;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int duration;

  Episode({
    required this.id,
    required this.season,
    required this.number,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
  });
}

// Sample data
final List<Content> dummyContent = [];
"@

Set-Content -Path "lib\models\content.dart" -Value $contentModelCode

# Create main.dart
$mainDartCode = @"
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

void main() {
  // Set landscape orientation for TV
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Apply dark theme similar to Apple TV+
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const ProviderScope(child: TvMovieApp()));
}

class TvMovieApp extends StatelessWidget {
  const TvMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF2C2C2E),
          surface: Color(0xFF1C1C1E),
          background: Colors.black,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
"@

Set-Content -Path "lib\main.dart" -Value $mainDartCode

# Create home_screen.dart
$homeScreenCode = @"
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _focusNode.requestFocus());
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TV Movie App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to your TV Movie App!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
"@

Set-Content -Path "lib\screens\home_screen.dart" -Value $homeScreenCode

# Create tv_focus_utils.dart
$focusUtilsCode = @"
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TVFocusScope extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const TVFocusScope({
    Key? key,
    required this.child,
    required this.focusNode,
  }) : super(key: key);

  @override
  _TVFocusScopeState createState() => _TVFocusScopeState();
}

class _TVFocusScopeState extends State<TVFocusScope> {
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      child: RawKeyboardListener(
        focusNode: widget.focusNode,
        onKey: _handleKeyEvent,
        child: widget.child,
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      
      if (key == LogicalKeyboardKey.select) {
        _handleSelect();
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        _handleArrowKey(TraversalDirection.left);
      } else if (key == LogicalKeyboardKey.arrowRight) {
        _handleArrowKey(TraversalDirection.right);
      } else if (key == LogicalKeyboardKey.arrowUp) {
        _handleArrowKey(TraversalDirection.up);
      } else if (key == LogicalKeyboardKey.arrowDown) {
        _handleArrowKey(TraversalDirection.down);
      } else if (key == LogicalKeyboardKey.escape ||
               key == LogicalKeyboardKey.goBack) {
        Navigator.of(context).maybePop();
      }
    }
  }

  void _handleSelect() {
    final primaryContext = primaryFocus?.context;
    if (primaryContext != null) {
      // Handle selection
    }
  }

  void _handleArrowKey(TraversalDirection direction) {
    final result = Focus.of(context).focusInDirection(direction);
    // Handle navigation result if needed
  }
}
"@

Set-Content -Path "lib\utils\tv_focus_utils.dart" -Value $focusUtilsCode

# Create focusable_card.dart
$focusableCardCode = @"
import 'package:flutter/material.dart';

class FocusableCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final double scale;
  
  const FocusableCard({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.scale = 1.05,
  }) : super(key: key);

  @override
  _FocusableCardState createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: const EdgeInsets.all(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform: _isFocused
                ? Matrix4.identity()..scale(widget.scale)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
"@

Set-Content -Path "lib\widgets\focusable_card.dart" -Value $focusableCardCode

# Create a banner.xml for Android TV
New-Item -ItemType Directory -Path "android\app\src\main\res\drawable" -Force

$bannerXml = @"
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <solid android:color="#000000"/>
    <padding android:bottom="10dp" android:left="10dp" android:right="10dp" android:top="10dp"/>
</shape>
"@

Set-Content -Path "android\app\src\main\res\drawable\banner.xml" -Value $bannerXml

# Update AndroidManifest.xml
$manifestPath = "android\app\src\main\AndroidManifest.xml"
$manifestContent = Get-Content -Path $manifestPath -Raw

# Add TV features and categories
$updatedManifest = $manifestContent -replace "<manifest ", "<manifest xmlns:android=`"http://schemas.android.com/apk/res/android`">
    <uses-feature android:name=`"android.software.leanback`" android:required=`"true`" />
    <uses-feature android:name=`"android.hardware.touchscreen`" android:required=`"false`" />

"
$updatedManifest = $updatedManifest -replace "android:icon=`"@mipmap/ic_launcher`"", "android:icon=`"@mipmap/ic_launcher`" android:banner=`"@drawable/banner`""
$updatedManifest = $updatedManifest -replace "<category android:name=`"android.intent.category.LAUNCHER`"/>", "<category android:name=`"android.intent.category.LAUNCHER`"/>
                <category android:name=`"android.intent.category.LEANBACK_LAUNCHER`"/>"

Set-Content -Path $manifestPath -Value $updatedManifest

# Get dependencies
Write-Host "Fetching dependencies..."
flutter pub get

Write-Host ""
Write-Host "======================================"
Write-Host "Project setup complete!"
Write-Host "======================================"
Write-Host ""
Write-Host "Project created at: $(Get-Location)"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Open the project in your IDE"
Write-Host "2. Copy additional code from your Google Drive document"
Write-Host "3. Run the app using: flutter run -d windows"
Write-Host ""