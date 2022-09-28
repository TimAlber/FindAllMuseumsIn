import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'museums.dart';

class PlaceStore {
  Future<List<Element>?> getAllMueseumsIn(String input) async {
    try {
      var headers = {
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.9,de-DE;q=0.8,de;q=0.7',
        'Connection': 'keep-alive',
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'DNT': '1',
        'Origin': 'https://overpass-turbo.eu',
        'Referer': 'https://overpass-turbo.eu/',
        'Sec-Fetch-Dest': 'empty',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'cross-site',
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36',
        'sec-ch-ua':
            '"Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"'
      };
      var request =
          Request('POST', Uri.parse('https://overpass-api.de/api/interpreter'));
      request.body =
          '''data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3B%0Aarea%5Bname%3D%22$input%22%5D-%3E.searchArea%3B%0A(%0A++node%5B%22tourism%22%3D%22museum%22%5D(area.searchArea)%3B%0A)%3B%0A%2F%2F+print+results%0Aout+body%3B%0A%3E%3B%0Aout+skel+qt%3B''';
      request.headers.addAll(headers);

      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final jsonString = await response.stream.bytesToString();
        try {
          print('jsonString: ' + jsonString);

          final museums = museumsFromJson(jsonString);

          print('elements: ' + museums.elements.toString());

          return museums.elements;
        } catch (e) {
          Logger().e(e);
          return null;
        }
      } else {
        print(response.reasonPhrase);
        return null;
      }
    } catch (e) {
      Logger().e(e);
    }
    return null;
  }
}
