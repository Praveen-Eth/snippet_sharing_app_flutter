final String snippetNote = 'snippetnote';


class SnippetFields {
  static final String id = '_id';
  static final String createdTime = 'createdTime';
  static final String title  = 'title';
  static final String codeSnippet = 'codeSnippet';
}


class Snippet{
  final int? id;
  final DateTime createdTime;
  final String title;
  final String codeSnippet;

  const Snippet({
    this.id,
    required this.createdTime,
    required this.title,
    required this.codeSnippet
  });


  static Snippet fromJson(Map<String, Object?> json) => Snippet(
    id: json[SnippetFields.id] as int?,
    createdTime: DateTime.parse(json[SnippetFields.createdTime] as String),
    title: json[SnippetFields.title] as String,
    codeSnippet: json[SnippetFields.codeSnippet] as String,
  );

  Map<String,Object?> toJson() => {
    SnippetFields.id: id,
    SnippetFields.createdTime: createdTime.toIso8601String(),
    SnippetFields.title: title,
    SnippetFields.codeSnippet: codeSnippet
  };
  
}