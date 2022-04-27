final String tableCategory = 'category';

class CategoryFields {
  static final List<String> values = [
    /// Add all fields
    sno, id, category
  ];
  static final String sno = '_sno';
  static final String id = 'id';
  static final String category = 'category';
}

class Category {
  final int? sno;
  final int? id;
  final String? category;

  const Category({
    this.sno,
    required this.id,
    required this.category,
  });

  Category copy({
    int? sno,
    int? id,
    String? category,
  }) =>
      Category(
        sno: sno ?? this.sno,
        id: id ?? this.id,
        category: category ?? this.category,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
        sno: json[CategoryFields.id] as int?,
        category: json[CategoryFields.category] as String?,
        id: json[CategoryFields.id] as int?,
      );

  Map<String, Object?> toJson() => {
        CategoryFields.sno: sno,
        CategoryFields.id: id,
        CategoryFields.category: category,
      };
}
