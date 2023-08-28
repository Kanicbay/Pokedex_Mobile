import 'package:flutter/material.dart';
import 'package:pokedex/widgets/login_form.dart';

class PokemonLoginScreen extends StatefulWidget {
  const PokemonLoginScreen({super.key});

  @override
  State<PokemonLoginScreen> createState() => PokemonLoginScreenState();
}

class PokemonLoginScreenState extends State<PokemonLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: LoginFormWidget())],
    ));
  }
}
