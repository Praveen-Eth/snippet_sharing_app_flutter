import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/sqflite/snippet_backend.dart';
import 'package:flutter_application_1/model/snippet_entity.dart';
import 'package:flutter_application_1/view_layer/new_note_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //await SnippetDataBase.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor:const Color(0xff2e90e5),
            background:const Color(0xff121212)),
        useMaterial3: true,
      ),
      home: const DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Snippet> snippetList = List.empty();
  final _controller = TextEditingController(); // Declare the controller

  @override
  void initState() {
    super.initState();

    refreshData();
  }

  @override
  void dispose() {
    SnippetDataBase.instance.close();
    super.dispose();
  }

  Future<void> refreshData() async {
    // Perform the asynchronous operation to fetch data
    final List<Snippet> refreshedSnippetList = await SnippetDataBase.instance.readAllNote();

    // Update the state with the new data
    setState(() {
      snippetList = refreshedSnippetList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
             SearchBar(controller: _controller),
              Expanded(child:
              RefreshIndicator(
              onRefresh: refreshData,
              child: ListView.builder(
                  itemCount: snippetList.length,
                  itemBuilder: (context, index) {
                    return SnippetItem(snippetData: snippetList[index]);
                  }
                  )
              )
              )
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton(
          onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const NewSnippetWidget())); },
        backgroundColor: const Color(0xff2e90e5),
        heroTag: "create snippet",
        child: const Icon(Icons.add,color: Colors.white),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
        child: DecoratedBox(
            decoration: BoxDecoration(
                color: const Color(0x00000000),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color(0x2e2e90e5),
                  width: 1.0
                )
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) => {print('hello')},
              style: const TextStyle(color: Color(0xffe2e2e2)),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  prefixIcon: SearchIcon(key: key),
                  prefixIconColor: Color(0xff242529),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 16.0, minHeight: 16.0)),
              cursorColor: Colors.white,
            )
        )
    );
  }
}

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
        child: SvgPicture.asset('assets/search.svg',
            colorFilter:
                const ColorFilter.mode(Color(0xff2e90e5), BlendMode.srcIn)));
  }
}

class SnippetItem extends StatelessWidget {
  final Snippet snippetData;

  const SnippetItem({super.key, required this.snippetData});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: const Color(0xff242529),
              borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: [
              Text(
                snippetData.title,
                style:
                    const TextStyle(fontSize: 16.0, color: Color(0xffcccccc)),
              ),
              Text(snippetData.codeSnippet,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style:
                      const TextStyle(fontSize: 12.0, color: Color(0xff8e8e8e)))
            ],
          ),
        ));
  }
}
