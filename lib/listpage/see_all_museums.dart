import 'package:all_museums_in/listpage/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:all_museums_in/services/museums.dart' as musem;

class SeeAllMuseumsPage extends StatefulWidget {
  final List<musem.Element> elements;

  const SeeAllMuseumsPage({required this.elements, Key? key}) : super(key: key);

  @override
  State<SeeAllMuseumsPage> createState() => _SeeAllMuseumsPageState();
}

class _SeeAllMuseumsPageState extends State<SeeAllMuseumsPage> {
  var _searchText = '';

  @override
  Widget build(BuildContext context) {
    return SearchBarScaffold(
        onUpdateSearch: (value) {
          setState(() {
            _searchText = value;
          });
        },
        title: 'All Museums:',
        body: _getTodoList(
          elements: widget.elements,
        ));
  }

  Widget _getTodoList({
    required List<musem.Element> elements,
  }) {
    final filteredList = elements
        .where((entry) =>
            _searchText.isEmpty ||
            (entry.tags.name != null &&
                entry.tags.name!.toLowerCase().contains(_searchText)))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var element = filteredList[index];
        return ListTile(
          title: Text(
            element.tags.name ?? '<Found no name>',
          ),
          subtitle: Text(
              '${element.tags.addrStreet ?? ''} ${element.tags.addrHousenumber ?? ''} ${element.tags.addrPostcode ?? ''} ${element.tags.addrCity ?? ''}'),
          onTap: () {
            print('tapped ${element.tags.name}');
          },
        );
      },
    );
  }
}
