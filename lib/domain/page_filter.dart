/// Курсор для пагинации
class PageFilter {
  const PageFilter({
    this.limit = 10,
    this.offset = 0,
  });

  final int limit;
  final int offset;

  PageFilter get nextPage => PageFilter(limit: this.limit, offset: this.offset + this.limit);
}
