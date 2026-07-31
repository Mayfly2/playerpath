class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String google = '/auth/google';
  static const String apple = '/auth/apple';
  static const String verifyEmail = '/auth/verify-email';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String me = '/users/me';

  // Players
  static const String playerProfile = '/players/profile';
  static const String playerPositions = '/players/profile/positions';
  static const String playerStatistics = '/players/profile/statistics';
  static const String playerClubHistory = '/players/profile/club-history';
  static String playerById(String id) => '/players/$id';

  // Clubs
  static const String clubProfile = '/clubs/profile';
  static String clubById(String id) => '/clubs/$id';

  // Search
  static const String searchPlayers = '/search/players';
  static const String searchClubs = '/search/clubs';

  // Matching
  static String matchesForClub(String clubId) => '/matching/players/$clubId';
  static String matchesForPlayer(String playerId) => '/matching/clubs/$playerId';
  static const String matchScore = '/matching/score';

  // Messaging
  static const String sendInvite = '/messaging/invite';
  static String acceptInvite(String id) => '/messaging/invite/$id/accept';
  static String rejectInvite(String id) => '/messaging/invite/$id/reject';
  static const String conversations = '/messaging/conversations';
  static String conversation(String id) => '/messaging/conversations/$id';
  static String messages(String id) => '/messaging/conversations/$id/messages';
  static String markRead(String id) => '/messaging/conversations/$id/read';

  // Feed
  static const String feed = '/feed';
}
