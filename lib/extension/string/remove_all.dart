//~Extension to remove unwanted characters from string.

extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
        this,
        (result, value) => result.replaceAll(
          value,
          '',
        ),
      );
}
