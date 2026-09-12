void main() {
  String user = 'Nastya';
  double balance = 2000.0;

  checkBalance(name: user, balance: balance);

  balance = deposit(currentBalance: balance, amount: 1000.0);

  balance = withdraw(
    name: user,
    currentBalance: balance,
    amount: 400.0,
    pinCode: 1234,
  );

  balance = withdraw(
    name: user,
    currentBalance: balance,
    amount: 5000.0,
    pinCode: 1234,
  );
}

void checkBalance({required String name, required double balance}) =>
    print('User: $name | Current Balance: \$$balance');

double deposit({required double currentBalance, double? amount}) {
  double depositAmount = amount ?? 0.0;
  double updatedBalance = currentBalance + depositAmount;
  print('Deposited: \$$depositAmount | New Balance: \$$updatedBalance');
  return updatedBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  int enteredPin = pinCode ?? 0000;
  if (enteredPin != 1234) {
    print('Transaction Declined: Incorrect PIN code.');
    return currentBalance;
  }

  double withdrawAmount = amount ?? 0.0;

  if (withdrawAmount > currentBalance) {
    print('Transaction Declined: Insufficient funds.');
    return currentBalance;
  }

  double updatedBalance = currentBalance - withdrawAmount;
  print('Successfully withdrew \$$withdrawAmount | Remaining Balance: \$$updatedBalance');
  return updatedBalance;
}

