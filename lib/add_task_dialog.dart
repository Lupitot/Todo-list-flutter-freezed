import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  AddTaskDialog({super.key});
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'A propos',
        style: TextStyle(
          color: Color.fromARGB(223, 32, 142, 34),
          fontSize: 30,
        ),
      ),
      content: TextField(
        controller: _textController,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(223, 32, 142, 34),
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(10)),
          ),
          labelText: 'Entrez votre tâche',
          labelStyle: TextStyle(
            color: Color.fromARGB(223, 238, 238, 238),
          ),
          hintText: 'Exemple : Apprendre le flutter',
          hintStyle: TextStyle(
            color: Color.fromARGB(98, 203, 203, 203),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.pop(context, _textController.text),
          child: const Text(
            'Ok',
            style: TextStyle(
              color: Color.fromARGB(223, 32, 142, 34),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      );
  }
}