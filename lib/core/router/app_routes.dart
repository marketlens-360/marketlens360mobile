abstract final class AppRoutes {
  static const home    = '/';
  static const stocks  = '/stocks';
  static const funds   = '/funds';
  static const aiChat  = '/ai-chat';
  static const profile  = '/profile';
  static const settings = '/settings';

  // Auth
  static const login          = '/auth/login';
  static const register       = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';

  // Detail paths (nested under shell)
  static const stockDetail = '/stocks/:symbol';
  static const fundDetail  = '/funds/:id';

  static String stockDetailPath(String symbol) => '/stocks/$symbol';
  static String fundDetailPath(int id) => '/funds/$id';
}
