import 'package:all_museums_in/listpage/see_all_museums.dart';
import 'package:all_museums_in/services/place_store.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find all museums in ...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final placeTextController = TextEditingController();
  var loading = false;

  @override
  void dispose() {
    placeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find all museums in ..."),
      ),
      body: !loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'Find all museums in:',
                    style: TextStyle(fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: placeTextController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Berlin',
                      ),
                    ),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize:
                              MaterialStateProperty.all(const Size(200, 100))),
                      onPressed: () {
                        if (placeTextController.text.isEmpty) {
                          return;
                        }
                        final value = placeTextController.text.trim();
                        setState(() {
                          loading = true;
                        });
                        PlaceStore()
                            .getAllMueseumsIn(value)
                            .then((elementList) => {
                                  if (elementList == null)
                                    {
                                      showErrorAlert(context,
                                          "Either this place doesn't exist or there was an error connection to the OSM Database."),
                                    }
                                  else
                                    {
                                      if (elementList.isEmpty)
                                        {
                                          showErrorAlert(context,
                                              "There is no museums in this place."),
                                        }
                                      else
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeAllMuseumsPage(
                                                      elements: elementList,
                                                    )),
                                          ),
                                        }
                                    },
                                  setState(() {
                                    loading = false;
                                  }),
                                });
                      },
                      child: const Text('Find all museums')),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void showErrorAlert(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(text),
            ));
  }
}
