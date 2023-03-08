import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:movies/models/movies.dart';

import 'models/api.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:drop_shadow/drop_shadow.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

class MovieDetails extends StatefulWidget {
  final int idMovie;
  final String? posterMovie;
  final String? backgroundMovie;

  const MovieDetails(
      {super.key,
      required this.idMovie,
      required this.posterMovie,
      this.backgroundMovie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Box<Movies> movieBox;

  List<dynamic> fullMovieDetails = [];
  int idMovie = 0;
  String nameMovie = "";
  String overviewMovie = "";
  String backdropPathDetails = "";
  String poster = "";
  String release_movie = "";
  String genre = '';
  String producers = '';
  int numberProducers = 1;
  @override
  void initState() {
    super.initState();
    //debugPrint(widget.idMovie.toString());
    setState(() {
      _getMovieDetails(widget.idMovie);
      backdropPathDetails = widget.backgroundMovie.toString();
      poster = widget.posterMovie.toString();
      idMovie = widget.idMovie;
    });

    movieBox = Hive.box<Movies>("movie");
  }

  Movies? movies;

  Future<void> _getMovieDetails(int id) async {
    try {
      final response = await http
          .get(Uri.parse(urlBaseMovie + id.toString() + apiParam + apiKey));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fullMovieDetails = data.values.toList();
          nameMovie = fullMovieDetails[9].toString();
          overviewMovie = fullMovieDetails[10].toString();
          genre =
              [for (var data in fullMovieDetails[4]) data['name']].join(' | ');
          release_movie = formarterDate(fullMovieDetails[15].toString());

          int count = 0;
          producers = [
            for (var data in fullMovieDetails[13]) data['name'],
          ].join('  ');

          for (var data in fullMovieDetails[13]) {
            count++;
          }

          numberProducers = count;

          debugPrint(backdropPathDetails);
          debugPrint(id.toString());

          movies = Movies(
              id: idMovie,
              originalTitle: nameMovie,
              overview: overviewMovie,
              image: poster,
              backdropPath: fullMovieDetails[1].toString(),
              homePage: "",
              release_date: "");
        });
      } else {
        throw Exception("[DATA] Failed to load data");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String formarterDate(releaseDate) {
    try {
      DateTime dt = DateTime.parse(releaseDate);
      return DateFormat('dd/MM/yyyy').format(dt).toString();
    } catch (e) {
      debugPrint(e.toString());
      throw ('Error parsing date');
    }
  }

  Widget titleCustom() {
    return AppBar(
      backgroundColor: Colors.black26,
      title: Text(nameMovie),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget imageBackground() {
    return Column(children: <Widget>[
      ClipRRect(
        child: Image.network(posterUrl + backdropPathDetails.toString()),
      ),
    ]);
  }

  Widget posterMovie() {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 15),
      child: Wrap(
        spacing: 32,
        runSpacing: 16,
        children: [
          DropShadow(
            borderRadius: 1.0,
            blurRadius: 2.0,
            spread: 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                posterUrl + poster,
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool click = false;

  Widget followMovie() {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 330),
      child: Wrap(
        spacing: 32,
        runSpacing: 16,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, elevation: 0),
              onPressed: () async {
                bool click = false;

                setState(() {
                  click = !click;
                });

                if (!movieBox.values
                        .any((Movies element) => element.id == movies?.id) ||
                    !click) {
                  movieBox.put(movies!.id, movies!);
                  debugPrint("Adicionado a Lista");
                } else {
                  movieBox.delete(movies!.id);
                  debugPrint("Removido da Lista");
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  (!movieBox.values.any(
                            (Movies element) => element.id == movies?.id,
                          ) &&
                          !click)
                      ? Icons.heart_broken
                      : Icons.favorite,
                  size: 30,
                  color: Colors.red,
                ),
              ))
        ],
      ),
    );
  }

  Widget titleMovieCustom() {
    return Container(
      margin: const EdgeInsets.only(top: 100, left: 155),
      child: Wrap(
        spacing: 32,
        runSpacing: 16,
        children: [
          Text(nameMovie,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.5,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0))
                  ]))
        ],
      ),
    );
  }

  Widget genersMovieCustom() {
    return Container(
      margin: const EdgeInsets.only(top: 130, left: 157),
      child: Wrap(
        spacing: 32,
        runSpacing: 16,
        children: [
          Text(genre,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0))
                  ]))
        ],
      ),
    );
  }

  Widget overviewCustom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(20.0),
          child: const Text(
            'Synpsis',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            overviewMovie,
            style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300),
          ),
        )
      ],
    );
  }

  Widget producersMovieCustom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(25.0),
          child: const Text(
            'Production',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        listProcucers()
      ],
    );
  }

  Widget listProcucers() {
    if (numberProducers > 3) {
      return ScrollLoopAutoScroll(
        scrollDirection: Axis.horizontal,
        child: Text(
          producers,
          style: const TextStyle(fontSize: 15),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Text(producers),
      );
    }
  }

  Widget releaseCustom() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(release_movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: titleCustom()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                imageBackground(),
                posterMovie(),
                titleMovieCustom(),
                genersMovieCustom(),
                followMovie(),
              ],
            ),
            overviewCustom(),
            producersMovieCustom(),
          ],
        ),
      ),
    );
  }
}
