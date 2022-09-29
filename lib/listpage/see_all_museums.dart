import 'package:all_museums_in/detailview/detail_view.dart';
import 'package:all_museums_in/listpage/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:all_museums_in/services/museums.dart' as musem;
import 'package:all_museums_in/geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';

class SeeAllMuseumsPage extends StatefulWidget {
  final List<musem.Element> elements;
  final String placeType;

  const SeeAllMuseumsPage({
    required this.elements,
    required this.placeType,
    Key? key}) : super(key: key);

  @override
  State<SeeAllMuseumsPage> createState() => _SeeAllMuseumsPageState();
}

class _SeeAllMuseumsPageState extends State<SeeAllMuseumsPage> {
  var _searchText = '';
  Position? devicePosition;

  @override
  void initState() {
    determinePosition().then((position) => {
          setState(() {
            devicePosition = position;
          }),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarScaffold(
        onUpdateSearch: (value) {
          setState(() {
            _searchText = value;
          });
        },
        title: 'All ${widget.placeType}:',
        body: devicePosition != null
            ? _getPlaceList(
                elements: widget.elements,
              )
            : const Center(child: CircularProgressIndicator()));
  }

  Widget _getPlaceList({
    required List<musem.Element> elements,
  }) {
    final filteredList = elements
        .where((entry) =>
            _searchText.isEmpty ||
            (entry.tags.name != null &&
                entry.tags.name!.toLowerCase().contains(_searchText)))
        .toList();


    for(var ele in filteredList){
      final distance = Geolocator.distanceBetween(ele.lat, ele.lon, devicePosition!.latitude, devicePosition!.longitude) / 1000;
      ele.distance = distance;
    }

    filteredList.sort((a, b) {
      return a.distance!.compareTo(b.distance!);
    });

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailView(
                  element: element,
                ),
              ),
            );
          },
          trailing: Text('${element.distance!.toStringAsFixed(3)} km'),
        );
      },
    );
  }
}
