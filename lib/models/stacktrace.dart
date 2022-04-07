class Stacktrace {
  final int index;
  final String? obfuscated;
  final String? deObfuscated;

  const Stacktrace({
    required this.index,
    this.obfuscated,
    this.deObfuscated,
  });

  Stacktrace copyWith({
    String? obfuscated,
    String? deObfuscated,
  }) =>
      Stacktrace(
        index: index,
        deObfuscated: deObfuscated ?? this.deObfuscated,
        obfuscated: obfuscated ?? this.obfuscated,
      );
}
