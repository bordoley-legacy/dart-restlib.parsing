part of parsing;

class _FollowedByParser<T> extends AbstractParser<T> {
  final Parser<T> parser;
  final Parser next;

  const _FollowedByParser(this.parser, this.next);

  Option<T> doParse(final CodePointIterator itr) =>
      parser.parseFrom(itr).map((final T result) {
        final int startPos = itr.index;
        final T retval =
            (next.parseFrom(itr).isEmpty) ? null : result;
        itr.index = startPos;
        return retval;
    });

  String toString() =>
      "$parser.followedBy($next)";
}