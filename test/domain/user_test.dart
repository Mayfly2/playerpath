import 'package:flutter_test/flutter_test.dart';
import 'package:playerpath/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('fromJson with full data', () {
      final json = {'id': '123', 'email': 'a@a.com', 'userType': 'player', 'isVerified': true, 'isPremium': false};
      final user = User.fromJson(json);
      expect(user.id, '123');
      expect(user.isPlayer, true);
      expect(user.isClub, false);
    });

    test('fromJson with defaults', () {
      final json = {'id': '456', 'email': 'club@test.com', 'userType': 'club'};
      final user = User.fromJson(json);
      expect(user.isVerified, false);
      expect(user.isPremium, false);
      expect(user.isClub, true);
    });

    test('equality', () {
      final a = User(id: '1', email: 'a@a.com', userType: 'player');
      final b = User(id: '1', email: 'a@a.com', userType: 'player');
      final c = User(id: '2', email: 'a@a.com', userType: 'player');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
