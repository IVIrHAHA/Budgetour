class GColors {
  // FinanceTile color scheme
  static const String borderColor = '#DCDCDC';
  static const String alertColor = '#FFEFEF';
  static const String warningColor = '#FFF4D5';
  static const String neutralColor = '#FCFCFC';
  static const String positiveColor = '#F0FCE5';

  // CalculatorView color scheme
  static const String calcButtonColor = '#000000';
  static const String calcDisabledButtonColor = '#1F1F1F';
  static const String calcBackgroundColor = '#393939';
  static const String calcButtonSplashColor = neutralColor;
  static const String calcButtonNoSplashColor = '#F93838';

  // Number Colors
  static const String positiveNumber = '#48C144';
  static const String negativeNumber = '#FF6868';

  // Misc Colors
  static const String blueish = '#64B2FF';
  static const String redish = '#FF6868';
  static const String greenish = '#48C144';
}

class GlobalValues {
  static const double roundedEdges = 8;
  static const double defaultMargin = 24;
  static const double financeTileMargin = 4;
  static const double defaultTilePadding = 16;
}

class DbNames {
  /// TABLE NAMES
  // Total Cash Manager
  static const String fo_TABLE = "FinanceObjectTable";
  // CashHandler Table
  static const String ch_TABLE = "CashOnHandTable";
  // Transaction Table
  static const String trxt_TABLE = "TransactionsTable";

  /// COLUMN NAMES (In order!)
  // From Finance Object
  static const String fo_Category = "Category";
  static const String fo_ObjectId = "ObjectID";
  static const String fo_CashReserve = "CashReserve";
  static const String fo_Object = "ObjectJson";
  static const String fo_Type = "ClassType";

  // From CashHolder
  static const String ch_TransactionLink = "TransactionsLink";
  static const String ch_CashReserve = "CashReserve";

  // From Transaction
  static const String trxt_id = "ID";
  static const String trxt_date = "date";
  static const String trxt_amount = "amount";
  static const String trxt_description = "description";
  static const String trxt_color = "color";
}
