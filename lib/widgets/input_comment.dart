import 'package:flutter/material.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

class InputCommentWidget extends StatefulWidget {
  final int id;
  const InputCommentWidget({super.key, required this.id});

  @override
  State<InputCommentWidget> createState() => _InputCommentWidgetState();
}

class _InputCommentWidgetState extends State<InputCommentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _myController = TextEditingController();

  late FocusNode _textFocus;

  _printText() {
    print("El texto del input es: ${_myController.text}");
  }

  @override
  void initState() {
    super.initState();
    _textFocus = FocusNode();
    _myController.addListener(_printText);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.comment),
                  hintText: 'Ingrese un comentario',
                  labelText: 'Comentario'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El comentario es requerido';
                }
                return null;
              },
              controller: _myController,
              focusNode: _textFocus,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Agregando comentario...')));
                      print(
                          'El valor del comentario es: ${widget.id} :${_myController.text}');
                      Provider.of<PokemonProvider>(context, listen: false)
                          .addCommentToPokemonDoc(
                              widget.id, _myController.text);
                      _myController.clear();
                    }
                  },
                  child: const Text('Submit')),
              OutlinedButton(
                  onPressed: () {
                    _textFocus.requestFocus();
                  },
                  child: const Text('Set Focus'))
            ],
          )
        ]));
  }
}
