class EquationPreprocessor {
  const EquationPreprocessor._();

  static String normalize(String equation) {
    String eq = equation.trim();
    if (eq.isEmpty) return eq;

    // Strip y=, f(x)=, g(x)= prefix
    final prefixRegex = RegExp(
      r'^(?:[a-zA-Z]\s*(?:\(\s*x\s*\))?\s*=\s*)',
      caseSensitive: false,
    );
    eq = eq.replaceFirst(prefixRegex, '');

    // Implicit multiplication: digit followed by letter or opening paren
    eq = eq.replaceAllMapped(
      RegExp(r'(\d)([a-zA-Z(])'),
      (m) => '${m[1]}*${m[2]}',
    );

    // Implicit multiplication: closing paren followed by opening paren, letter, or digit
    eq = eq.replaceAllMapped(
      RegExp(r'(\))([a-zA-Z(0-9])'),
      (m) => '${m[1]}*${m[2]}',
    );

    return eq;
  }

  static bool isEmpty(String equation) => equation.trim().isEmpty;
}
