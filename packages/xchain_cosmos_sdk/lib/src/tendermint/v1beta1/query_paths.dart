const bankQueryPath = '/cosmos.bank.v1beta1.Query';

enum BankMethods { allBalances }

String createBankQueryPath(BankMethods method) {
  switch (method) {
    case BankMethods.allBalances:
      return '$bankQueryPath/AllBalances';
  }
}
