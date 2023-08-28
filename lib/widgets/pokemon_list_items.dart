import 'package:flutter/material.dart';
import 'package:pokedex/dtos/pokemon_model.dart';
import 'package:pokedex/screens/pokemon_details.dart';
import 'package:pokedex/widgets/pokemon_favorite.dart';

class PokemonListItems extends StatefulWidget {
  final List<Pokemon> pokemons;
  const PokemonListItems({super.key, required this.pokemons});

  @override
  State<PokemonListItems> createState() => _PokemonListItemsState();
}

class _PokemonListItemsState extends State<PokemonListItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: GestureDetector(
            onTap: () => {
              /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PokemonDetailsScreen()))*/
              Navigator.pushNamed(context, PokemonDetailsScreen.routeName,
                  arguments: widget.pokemons[index].id)
            },
            child: Card(
              elevation: 10,
              child: ListTile(
                  leading: Hero(
                      tag: widget.pokemons[index].id,
                      child: Image.network(widget.pokemons[index].imageUrl)),
                  title: Text(
                    widget.pokemons[index].name,
                  ),
                  trailing: PokemonFavorite(id: widget.pokemons[index].id)),
            ),
          ),
        );
      },
      itemCount: widget.pokemons.length,
    );
  }
}
