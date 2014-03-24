part of parsing;

class _EofParser extends ParserBase {
  static const ParseSuccess SUCCESS =
      const _ParseSuccess(
          const Either.leftConstant(const Option.constant("")),
          IterableString.EMPTY);

  const _EofParser();

  ParseResult parseFrom(final IterableString str) =>
      str.isEmpty ? SUCCESS : new ParseResult.failure(str);

  String toString() =>
      "EOF";
}