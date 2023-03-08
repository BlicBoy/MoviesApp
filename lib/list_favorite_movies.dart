import 'package:flutter/material.dart';
import 'package:movies/details_movies.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/movies.dart';

class ListFavoriteMovies extends StatefulWidget {
  const ListFavoriteMovies({super.key});

  @override
  State<ListFavoriteMovies> createState() => _ListFavoriteMoviesState();
}

class _ListFavoriteMoviesState extends State<ListFavoriteMovies> {
  late Box<Movies> movieBox;

  @override
  void initState() {
    super.initState();

    movieBox = Hive.box<Movies>("movie");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: movieBox.listenable(),
          builder: (context, Box<Movies> movies, _) {
            List<int> keys = movies.keys.cast<int>().toList();
            return ListView.separated(
              itemBuilder: (_, index) {
                final int key = keys[index];
                final Movies? movieKey = movies.get(key);
                debugPrint(movieKey?.originalTitle.toString());
                debugPrint(movieKey?.backdropPath.toString());
                debugPrint(movieKey?.originalTitle);
                return SingleChildScrollView(
                  child: ListTile(
                    title: Text(movieKey!.originalTitle.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            debugPrint("Apagar da lista");
                            movieBox.delete(key);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 20.0,
                            color: Colors.brown[900],
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      debugPrint(key.toString());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MovieDetails(
                              idMovie: movieKey.id ?? 0,
                              posterMovie: movieKey.image,
                              backgroundMovie: movieKey.backdropPath,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (_, index) => Divider(),
              itemCount: keys.length,
              shrinkWrap: true,
            );
          },
        ),
      ],
    );
  }
}
