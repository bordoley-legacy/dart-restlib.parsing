part of parsing;

final StreamTransformer<List<int>, IterableString> asciiTransformer =
  new StreamTransformer(
      (final Stream<List<int>> input, final bool cancelOnError) =>
          input.map((final List<int> data) =>
              new IterableString.ascii(data)).listen(null, cancelOnError: cancelOnError));


final StreamTransformer<List<int>, IterableString> latin1Transformer =
  new StreamTransformer(
    (final Stream<List<int>> input, final bool cancelOnError) =>
        input.map((final List<int> data) =>
            new IterableString.latin1(data)).listen(null, cancelOnError: cancelOnError));