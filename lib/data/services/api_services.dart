import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApiServices {
  final FirebaseDynamicLinks _dynamicLinks;

  ApiServices(this._dynamicLinks);

  Future<String> generateShortUrl(String url) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: dotenv.get('URI_PREFIX_URL'),
      link: Uri.parse(url),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'dwarfUrl',
        description: 'This link is generated using dwarfUrl',
      ),
    );
    final link = await _dynamicLinks.buildShortLink(parameters);
    return link.shortUrl.toString();
  }
}
