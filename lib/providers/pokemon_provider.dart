import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/dtos/pokemon_model.dart';

class PokemonProvider extends ChangeNotifier {
  final List<Pokemon> _originalPokemon = [];
  List<Pokemon> _pokemon = [];

  int get totalPokemons => _pokemon.length;

  UnmodifiableListView<Pokemon> get pokemons => UnmodifiableListView(_pokemon);

  Pokemon getPokemon(int id) {
    return _pokemon.firstWhere((element) => element.id == id);
  }

  void searchPokemonsByName(String name) {
    _pokemon = _originalPokemon
        .where((element) => element.name.contains(name))
        .toList();
    notifyListeners();
  }

  // Puse yo
  void clearSearch() {
    _pokemon = [..._originalPokemon];
    notifyListeners();
  }

  Future<void> updatePokemonFavoriteStatus(int id, bool value) async {
    var db = FirebaseFirestore.instance;
    await db.collection('pokemons').doc(id.toString()).update({
      'isFavorite': value,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPokemonDocument(
      int id) async {
    var db = FirebaseFirestore.instance;
    return await db.collection('pokemons').doc(id.toString()).get();
  }

  Future<bool> checkPokemons() async {
    if (_pokemon.isEmpty) {
      await _initPokemonList();
      return true;
    }
    return false;
  }

  Future<void> _initPokemonList() async {
    var client = http.Client();
    var response = await client.get(Uri.http('pokeapi.co', '/api/v2/pokemon'));
    // ignore: avoid_print
    print('statusPokemon: ${response.statusCode}'); //codigo de retorno HTTP
    //20X -> OK
    //40X -> Errores de lado del cliente (404, 403)
    //50X -> Errores de lado del servidor (500)
    //print('pokemon List: ${response.body}');
    //DART - JSON -> Map<String, Object> -> Object -> List
    var decodedResponse = jsonDecode(response.body);
    var results = decodedResponse['results'] as List;
    for (var ri in results) {
      //ri -Map<String, Object>
      var url = ri['url'] as String;
      await addPokemonList(url);
    }
    notifyListeners();
  }

  void addCommentToPokemonDoc(int id, String comment) {
    var db = FirebaseFirestore.instance;
    final commentObj = <String, dynamic>{
      'comment': comment,
    };
    var setOptions = SetOptions(merge: true);
    db.collection('pokemons').doc(id.toString()).set(commentObj, setOptions);
  }

  Future<void> addPokemonList(String url) async {
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    var pokemonData = jsonDecode(response.body);
    // ignore: avoid_print
    print('Procesando: $url');

    /*
    var pokemon = Pokemon(
        id: pokemonData['id'],
        name: pokemonData['name'],
        imageUrl: pokemonData['sprites']['front_default']);
    */
    _pokemon.add(Pokemon.fromJson(pokemonData));
    _originalPokemon.add(Pokemon.fromJson(pokemonData));

    final pokemonDocument = <String, dynamic>{
      'id': pokemonData['id'],
      'name': pokemonData['name'],
      'imageUrl': pokemonData['sprites']['front_default'],
    };

    var db = FirebaseFirestore.instance;
    /*
      Future:
        - let value = await future();
        - future().then((value) => {

        });
    */
    /*
    Agregar documentos con id autogenerados
    db.collection("pokemons").add(pokemonDocument).then((value) => {
          // ignore: avoid_print
          print("Sucess")
        });*/
    var setOptions = SetOptions(merge: true);
    db
        .collection("pokemons")
        .doc(pokemonData['id'].toString())
        .set(pokemonDocument, setOptions)
        .then((value) => {
              // ignore: avoid_print
              print("Sucess")
            });
  }
}
