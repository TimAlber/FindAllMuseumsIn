import 'package:all_museums_in/filterchooser/choose_filter.dart';
import 'package:all_museums_in/listpage/see_all_museums.dart';
import 'package:all_museums_in/services/place_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(const MyApp());
}

class Filter {
  Filter({
    required this.word,
    required this.key,
    required this.value,
  });
  String word;
  String key;
  String value;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find all ... in ...',
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
  List<Filter> filters = [];
  Filter? choosenFilter;
  var placeText = 'Berlin';

  @override
  void initState() {
    placeTextController.addListener(() {
      setState(() {
        placeText = placeTextController.text;
      });
    });

    _getAllFilters();
    super.initState();
  }

  void _getAllFilters() async {
    final all = await rootBundle.loadString('assets/csv/filters2.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(all);

    for (final row in rowsAsListOfValues){
      final nrow = row.first.toString().split(';');
      if(nrow.last == 'N' && nrow[3] == '-'){
        final newFilter = Filter(word: nrow.first, key: nrow[1], value: nrow[2]);
        filters.add(newFilter);
      }
    }
  }

  @override
  void dispose() {
    placeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find all ${choosenFilter != null ? choosenFilter!.word : '...'} in ${placeText.isNotEmpty ? placeText : '...'}"),
      ),
      body: !loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'Find all: ',
                    style: TextStyle(fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChooseFilter(
                                    filters: filters,
                                    callback: (filter ) {
                                      setState(() {
                                        choosenFilter = filter;
                                      });
                                    },
                                  )),
                        );
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: choosenFilter != null ? choosenFilter!.word : 'for example Museum',
                      ),
                    ),
                  ),
                  const Text(
                    'in: ',
                    style: TextStyle(fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: placeTextController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'for example Berlin',
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
                        if (placeTextController.text.isEmpty || choosenFilter == null) {
                          return;
                        }
                        final value = placeTextController.text.trim();
                        setState(() {
                          loading = true;
                        });
                        PlaceStore()
                            .getAllMueseumsIn(value, choosenFilter!)
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
                                              "There is no ${choosenFilter!.word} in $value."),
                                        }
                                      else
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeAllMuseumsPage(
                                                      elements: elementList,
                                                      placeType: choosenFilter!.word,
                                                    )),
                                          ),
                                        }
                                    },
                                  setState(() {
                                    loading = false;
                                  }),
                                });
                      },
                      child: Text('Find all ${choosenFilter != null ? choosenFilter!.word : '...'} in ${placeText.isNotEmpty ? placeText : '...'}')),
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
