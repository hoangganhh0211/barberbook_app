class CatalogConstraintException implements Exception {
  CatalogConstraintException(this.message);

  final String message;
}