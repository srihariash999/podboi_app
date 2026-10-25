import 'package:xml/xml.dart';

/// A podcast feed described by an OPML outline.
class OpmlSubscription {
  const OpmlSubscription({required this.feedUrl, required this.title});

  final String feedUrl;
  final String title;
}

/// Parses the common OPML subscription format exported by podcast apps.
///
/// OPML permits folders to be represented as nested outlines, so every
/// outline with an `xmlUrl` is considered a subscription regardless of depth.
class OpmlSubscriptionParser {
  const OpmlSubscriptionParser();

  List<OpmlSubscription> parse(String source) {
    final document = XmlDocument.parse(source);
    final subscriptions = <OpmlSubscription>[];
    final seenFeedUrls = <String>{};

    for (final outline in document.descendants.whereType<XmlElement>()) {
      if (outline.name.local.toLowerCase() != 'outline') continue;

      final feedUrl = _attribute(outline, 'xmlUrl')?.trim();
      if (feedUrl == null || feedUrl.isEmpty) continue;

      final uri = Uri.tryParse(feedUrl);
      if (uri == null ||
          !uri.hasScheme ||
          (uri.scheme != 'http' && uri.scheme != 'https')) {
        continue;
      }

      final canonicalUrl = uri.toString();
      if (!seenFeedUrls.add(canonicalUrl.toLowerCase())) continue;

      final text = _attribute(outline, 'text')?.trim();
      final outlineTitle = _attribute(outline, 'title')?.trim();
      final title = (text?.isNotEmpty ?? false)
          ? text!
          : (outlineTitle?.isNotEmpty ?? false)
              ? outlineTitle!
              : uri.host;
      subscriptions.add(OpmlSubscription(
        feedUrl: canonicalUrl,
        title: title.isEmpty ? 'Untitled podcast' : title,
      ));
    }

    return subscriptions;
  }

  String? _attribute(XmlElement element, String name) {
    for (final attribute in element.attributes) {
      if (attribute.name.local.toLowerCase() == name.toLowerCase()) {
        return attribute.value;
      }
    }
    return null;
  }
}
