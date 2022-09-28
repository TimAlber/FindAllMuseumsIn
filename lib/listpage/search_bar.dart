import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SearchBarScaffold extends StatefulWidget {
  final Widget body;
  final String title;
  final Function(String) onUpdateSearch;

  const SearchBarScaffold(
      {required this.body,
      required this.title,
      required this.onUpdateSearch,
      Key? key})
      : super(key: key);

  @override
  State<SearchBarScaffold> createState() => _SearchBarScaffoldState();
}

class _SearchBarScaffoldState extends State<SearchBarScaffold> {
  var _isInSearchMode = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(() {
      widget.onUpdateSearch(_searchController.text.toLowerCase());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: _isInSearchMode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isInSearchMode = false;
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.blue,
                  ),
                )
              : null,
          title: _getAppBarTitle(),
          trailingActions: [
            PlatformIconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.search),
              onPressed: () => setState(() {
                _isInSearchMode = true;
              }),
            )
          ],
        ),
        body: widget.body,
      ),
    );
  }

  Widget _getAppBarTitle() {
    return _isInSearchMode
        ? TextFormField(
            autofocus: true,
            controller: _searchController,
            maxLines: 1,
            decoration: InputDecoration(
                isDense: true,
                hintStyle: TextStyle(color: Colors.grey[400]),
                hintText: 'search for museum by name...'),
          )
        : Text(widget.title);
  }
}
