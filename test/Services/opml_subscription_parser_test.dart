import 'package:podboi/Services/opml_subscription_parser.dart';
import 'package:test/test.dart';

void main() {
  const parser = OpmlSubscriptionParser();

  test('parses nested OPML outlines and removes duplicate feeds', () {
    const opml = '''
<opml version="2.0">
  <body>
    <outline text="Technology">
      <outline text="The Feed" type="rss" xmlUrl="https://example.com/feed.xml" />
      <outline title="Another Feed" xmlurl="https://example.org/podcast.rss" />
      <outline text="Duplicate" xmlUrl="https://example.com/feed.xml" />
    </outline>
  </body>
</opml>
''';

    final subscriptions = parser.parse(opml);

    expect(subscriptions, hasLength(2));
    expect(subscriptions[0].title, 'The Feed');
    expect(subscriptions[0].feedUrl, 'https://example.com/feed.xml');
    expect(subscriptions[1].title, 'Another Feed');
  });

  test('ignores non-feed and unsupported URL outlines', () {
    const opml = '''
<opml><body>
  <outline text="Folder" />
  <outline text="File" xmlUrl="file:///local/podcast.xml" />
  <outline text="Podcast" xmlUrl="http://example.com/feed" />
</body></opml>
''';

    final subscriptions = parser.parse(opml);

    expect(subscriptions, hasLength(1));
    expect(subscriptions.single.feedUrl, 'http://example.com/feed');
  });
}
