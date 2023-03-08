
import 'package:hive/hive.dart';

part 'movies.g.dart';

@HiveType(typeId: 0)
class Movies {
  @HiveField(0)
  late final int? id;
  @HiveField(1)
  final String? originalTitle;
  @HiveField(2)
  final String? overview;
  @HiveField(3)
  final String? image;
  @HiveField(4)
  final String? backdropPath;
  @HiveField(5)
  final String? homePage;
  @HiveField(6)
  final String? release_date;


  Movies(
      {this.id,
      this.originalTitle,
      this.overview,
      this.image,
      this.backdropPath,
      this.homePage,
      this.release_date});

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
        id: json['id'] ?? "",
        originalTitle: json['original_title'] ?? "",
        overview: json['overview'] ?? "",
        image: json['poster_path'] ?? "",
        backdropPath: json['backdrop_path'] ?? "",
        homePage: json['homepage'] ?? "",
        release_date: json['release_date'] ?? "");
  }
}
