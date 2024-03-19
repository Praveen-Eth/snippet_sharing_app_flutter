import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/model/snippet_entity.dart';
import 'package:flutter_application_1/sqflite/snippet_backend.dart';

class NewSnippetWidget extends StatefulWidget {
  const NewSnippetWidget({super.key});

  @override
  _NewSnippetState createState() => _NewSnippetState();
}

class _NewSnippetState extends State<NewSnippetWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController snippetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Column(children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Add Title Here',
            hintStyle: TextStyle(
                color: Color(0x2ecccccc),
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
          ),
            style: const TextStyle(
                color:  Color(0xffe2e2e2),
                fontFamily: 'Montserrat',
                fontSize:20,
                fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: 10),
        TextField(
          controller: snippetController,
          decoration: const InputDecoration(
            hintText: 'type or paste the code here',
            hintStyle: TextStyle(
                color: Color(0x2ecccccc),
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.normal),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
          ),
          style:const TextStyle(
              color:  Color(0xffe2e2e2),
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.normal
          ),
        ),
        const Spacer(flex: 1),
        MaterialButton(
          onPressed: addSnippet,
          color: const Color(0xff2e90e5),
          child: const Text(
            'Add Snippet',
            style: TextStyle(
                color: Color(0xffe2e2e2),
                fontFamily: "Montserrat",
                fontSize: 18,
                fontWeight: FontWeight.normal
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        )
      ]),
    )));
  }

  Future<void> addSnippet() async {
    final db = await SnippetDataBase.instance.database;
    await db.insert(
        snippetNote,
        Snippet(
                createdTime: DateTime.now(),
                title: titleController.text,
                codeSnippet: snippetController.text)
            .toJson());
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
