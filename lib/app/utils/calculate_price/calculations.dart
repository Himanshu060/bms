double calculateDueAmount(
    {required double totalSellAmount, required double totalCollectedAmount}) {
  double dueAmount = 0.0;
  if (totalSellAmount != 0.0) {
    dueAmount = (totalSellAmount - totalCollectedAmount);
  }
  return dueAmount;
}

double calculateItemTotal(
    {required double sellPrice,
    required double qty,
    bool isTaxInc = true,
    double gstValue = 0.0}) {
  double totalPrice = 0.0;
  double gst = 0.0;

  if (isTaxInc == false && gstValue != 0) {
    gst = calculateDiscountAmount(
        totalAmount: sellPrice,
        additionalCharges: 0,
        discountPercentage: gstValue);
  };
  totalPrice = ((sellPrice * qty)+gst);
  return totalPrice;
}

double calculateTotalAmount(
    {required double payableAmount,
    required double discountPrice,
    required double additionalCharge}) {
  double totalAmount = 0.0;

  totalAmount = ((payableAmount + discountPrice) - additionalCharge);
  return totalAmount;
}

double calculateDiscountPercentage(
    {required double discountPrice, required double totalAmount}) {
  double discountPercentage = 0.0;
  discountPercentage = ((discountPrice / totalAmount) * 100);
  return discountPercentage;
}

double calculatePayableAmount(
    {required double totalAmount,
    required double additionalCharges,
    required double discountPercentage}) {
  double payableAmount = 0.0;
  double per = ((totalAmount * discountPercentage) / 100);
  payableAmount = ((totalAmount - per) + additionalCharges);
  return payableAmount;
}

double calculateDiscountAmount(
    {required double totalAmount,
    required double additionalCharges,
    required double discountPercentage}) {
  double discountAmount = 0.0;
  discountAmount = ((totalAmount * discountPercentage) / 100);
  // double per = ((totalAmount * discountPercentage) / 100);
  // discountAmount = (((totalAmount - per) + additionalCharges) - totalAmount);
  return discountAmount;
}

double calculateTotalReceivedAmount(
    {required double payableAmount, required double dueAmount}) {
  double totalReceivedAmount = 0.0;

  totalReceivedAmount = (payableAmount - dueAmount);

  return totalReceivedAmount;
}
