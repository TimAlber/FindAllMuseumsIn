import 'package:all_museums_in/listpage/search_bar.dart';
import 'package:all_museums_in/main.dart';
import 'package:flutter/material.dart';

class ChooseFilter extends StatefulWidget {
  final List<Filter> filters;
  final Function(Filter) callback;

  const ChooseFilter({required this.filters, required this.callback, Key? key})
      : super(key: key);

  @override
  State<ChooseFilter> createState() => _ChooseFilterState();
}

class _ChooseFilterState extends State<ChooseFilter> {
  var _searchText = '';

  @override
  Widget build(BuildContext context) {
    return SearchBarScaffold(
      onUpdateSearch: (value) {
        setState(() {
          _searchText = value;
        });
      },
      body: _getFilterList(filters: widget.filters),
      title: 'Choose a place to find:',
    );
  }

  Widget _getFilterList({
    required List<Filter> filters,
  }) {
    final filteredList = filters
        .where((entry) =>
            _searchText.isEmpty ||
            (entry.word.toLowerCase().contains(_searchText)))
        .toList();

    filteredList.sort((a, b) {
      return a.word.toLowerCase().compareTo(b.word.toLowerCase());
    });

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var element = filteredList[index];
        return ListTile(
          title: Text(element.word),
          subtitle: Text('${element.key} = ${element.value}'),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => _getConfirmPopup(context, element),
            );
          },
        );
      },
    );
  }

  Widget _getConfirmPopup(BuildContext context, Filter filter) {
    return AlertDialog(
      title: const Text('Choose this place to search for?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
          onPressed: () async {
            widget.callback(filter);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('Choose'),
        )
      ],
    );
  }
}
