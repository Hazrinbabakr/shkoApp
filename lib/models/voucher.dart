enum VoucherType {
  percent,fixed
}

class Voucher {
  String id;
  num value;
  num limit;
  DateTime expiryDate;
  String voucher;
  VoucherType type;

  Voucher({
    required this.id,
    required this.value,
    required this.limit,
    required this.expiryDate,
    required this.voucher,
    required this.type
  });

  factory Voucher.fromJson(data) {
    return Voucher(
        id: data.id,
        value: data["value"],
        limit: data["limit"],
        expiryDate: data["expiry_date"].toDate(),
        voucher: data["voucher"],
        type: getType(data["type"]),
    );
  }

  static VoucherType getType(String type){
    switch(type){
      case "percent":
        return VoucherType.percent;
      case "fixed":
        return VoucherType.fixed;
      default:
        return VoucherType.fixed;
    }
  }
}