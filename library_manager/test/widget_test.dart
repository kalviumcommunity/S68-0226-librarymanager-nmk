import 'package:flutter_test/flutter_test.dart';

import 'package:library_manager/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LibraryApp());
    expect(find.text('LibraryOS'), findsWidgets);
  });
}
