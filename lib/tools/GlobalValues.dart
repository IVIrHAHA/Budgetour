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

class DbRefrence {
  /// TABLE NAMES
  // Budget Table
  static const String bo_TABLE = "BudgetObjectsTable";
  // FixedPayment Table
  static const String fx_TABLE = "FixedObjectsTable";
  // Cash On Hand
  static const String coh_TABLE = "CashOnHandTable";
  // Transaction Table
  static const String trxt_TABLE = "TransactionsTable";

  /// COLUMN NAMES
  // Budget specific 
  static const String bo_AllocationAmount = "TargetedAllocation";

  //FixedPayment specific
  static const String fx_markedAsAutoPay = "AutoPay"; 

  // From Recurrence
  static const String rec_StartDate = "RecurrenceStartDate";
  static const String rec_Duration = "RecurrenceDuration";

  // From Finance Object
  static const String fo_ObjectId = "ID";
  static const String fo_Category = "Category";
  static const String fo_Name = "ObjectName";

  // From CashHolder
  static const String fo_CashReserve = "CashReserved";
  static const String fo_TransactionLink = "TransactionsLink";

  // From StatMixin
  static const String fo_Stat1 = "Stat1";
  static const String fo_Stat2 = "Stat2";
}
