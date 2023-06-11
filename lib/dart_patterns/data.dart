import 'dart:convert';

class Document {
  Document() : _json = jsonDecode(documentJson) as Map<String, Object?>;
  final Map<String, Object?> _json;

  (String, {DateTime modified}) get metadata {
    // Add from here...
    const title = 'My Document';
    final now = DateTime.now();

    return (title, modified: now);
  } // to here.
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';
