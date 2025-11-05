class FirestorePaths {
  static String products() => 'products';
  static String product(String id) => 'products/$id';

  static String categories() => 'categories';
  static String category(String id) => 'categories/$id';

  static String sellers() => 'sellers';
  static String seller(String id) => 'sellers/$id';

  static String transactions() => 'transactions';
  static String transaction(String id) => 'transactions/$id';

  static String meta() => 'meta';
  static String ping() => 'meta/ping';
}
