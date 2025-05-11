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
