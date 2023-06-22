class Filters {
  String filterName;
  int? filterId;
  String sortName;
  bool isSelected;

  Filters(
      {required this.filterName,
      required this.sortName,
      required this.isSelected,
      this.filterId});
}
