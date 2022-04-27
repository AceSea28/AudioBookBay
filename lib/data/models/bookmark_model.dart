final String tableBookmarks = 'bookmarks';

class BookmarkFields {
  static final List<String> values = [
    /// Add all fields
    id, img, title, href
  ];

  static final String id = '_id';
  static final String img = 'img';
  static final String href = 'href';
  static final String title = 'title';
}

class Bookmark {
  final int? id;
  final String? title;
  final String? img;
  final String? href;

  const Bookmark({
    this.id,
    required this.img,
    required this.title,
    required this.href,
  });

  Bookmark copy({
    int? id,
    String? title,
    String? href,
    String? img,
  }) =>
      Bookmark(
        id: id ?? this.id,
        img: img ?? this.img,
        href: href ?? this.href,
        title: title ?? this.title,
      );

  static Bookmark fromJson(Map<String, Object?> json) => Bookmark(
        id: json[BookmarkFields.id] as int?,
        img: json[BookmarkFields.img] as String?,
        href: json[BookmarkFields.href] as String?,
        title: json[BookmarkFields.title] as String?,
      );

  Map<String, Object?> toJson() => {
        BookmarkFields.id: id,
        BookmarkFields.title: title,
        BookmarkFields.img: img,
        BookmarkFields.href: href,
      };
}
