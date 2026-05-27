// REPLACE START
enum PaymentType { bank, ewallet }
enum TransactionType { income, expense }

class PaymentAccountModel {
  final String id;
  final PaymentType type;
  final String platform;
  final String accountHolder;
  final String accountNumber;
  final bool isPrimary;

  const PaymentAccountModel({
    required this.id,
    required this.type,
    required this.platform,
    required this.accountHolder,
    required this.accountNumber,
    this.isPrimary = false,
  });
}

class TransactionModel {
  final String id;
  final String title;
  final TransactionType type;
  final String amount; 
  final String date;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
  });
}

class FinanceState {
  final int balance;
  final int totalIncome;
  final List<TransactionModel> transactions;
  final List<PaymentAccountModel> paymentAccounts;

  const FinanceState({
    this.balance = 0,
    this.totalIncome = 0,
    this.transactions = const [],
    this.paymentAccounts = const [],
  });

  FinanceState copyWith({
    int? balance,
    int? totalIncome,
    List<TransactionModel>? transactions,
    List<PaymentAccountModel>? paymentAccounts,
  }) {
    return FinanceState(
      balance: balance ?? this.balance,
      totalIncome: totalIncome ?? this.totalIncome,
      transactions: transactions ?? this.transactions,
      paymentAccounts: paymentAccounts ?? this.paymentAccounts,
    );
  }
}
// REPLACE END
