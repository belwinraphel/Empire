 

 

int roundHalfUp(int numerator, int denominator) {
  if (numerator < 0 || denominator <= 0) {
    throw ArgumentError('Positive numbers only');
  }
  int quotient = numerator ~/ denominator;
  int remainder = numerator % denominator;
  if (remainder * 2 >= denominator) {
    quotient += 1;
  }
  return quotient;
}

 
int prorate(int part, int whole, int totalAmount) {
  if (whole == 0) return 0;
  int multiplied = part * totalAmount;
  return roundHalfUp(multiplied, whole);
}