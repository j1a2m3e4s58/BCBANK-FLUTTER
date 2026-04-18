import 'package:flutter_test/flutter_test.dart';
import 'package:skoolatlas/main.dart';

void main() {
  testWidgets('BCB auth screen loads first', (WidgetTester tester) async {
    await tester.pumpWidget(const BcbBankApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Bank safely with BCB.'), findsOneWidget);
    expect(find.text('Customer login'), findsOneWidget);
    expect(find.text('Login to Demo'), findsOneWidget);
  });
}
