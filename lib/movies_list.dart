import 'dart:convert';

import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'models/movies.dart';

import 'models/api.dart';
import 'package:http/http.dart' as http;

import 'details_movies.dart';

import 'bottom_bar.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  String order = 'now_playing';

  @override
  void initState() {
    super.initState();
    _pagingController
        .addPageRequestListener((pageKey) => moviesListAPI(pageKey));
  }

  final PagingController<int, Movies> _pagingController =
      PagingController(firstPageKey: 0);

  Future<void> moviesListAPI(int pageKey) async {
    try {
      final response =
          await http.get(Uri.parse(urlBaseApi + order + apiParam + apiKey));
      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body)['results'];
        List<Movies> movies = result.map((e) => Movies.fromJson(e)).toList();
        _pagingController.appendLastPage(movies);
      } else {
        throw Exception("[DATA] Failed to load data");
      }
    } catch (e) {
      debugPrint(e.toString());
      _pagingController.error = e;
    }
  }

  Widget imageConstraint(String? urlImage) {
    return DropShadow(
      borderRadius: 9.0,
      blurRadius: 5.0,
      spread: 0.1,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: 180,
            child: Image.network(posterUrl + urlImage!),
          ),
        ),
      ),
    );
  }

  Widget titleDecoration(String? text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget overviewDecoration(String? text) {
    return Text(
      text!,
      style: const TextStyle(fontFamily: 'Raleway'),
    );
  }

  static const List<String> list = <String>['Now Playing', 'Top Rated'];

  String dropdownValue = list.first;

  Widget selectMovies() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.menu),
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        if (value == "Now Playing") {
          order = 'now_playing';
        } else {
          order = 'top_rated';
        }

        dropdownValue = value!;

        setState(() {
          
        });

        _pagingController.refresh();
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selectMovies(),
        Expanded(
          child: Center(
            child: PagedListView<int, Movies>(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Movies>(
                itemBuilder: (context, Movies item, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MovieDetails(
                                idMovie: item.id ?? 0,
                                posterMovie: item.image,
                                backgroundMovie: item.backdropPath,
                              );
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            imageConstraint(item.image),
                            Expanded(
                              child: Container(
                                height: 180,
                                padding: const EdgeInsets.all(12),
                                child: titleDecoration(item.originalTitle),
                              ),
                            ),
                            Expanded(
                                child: Text(
                              item.overview ?? "",
                              style: const TextStyle(fontSize: 10),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
