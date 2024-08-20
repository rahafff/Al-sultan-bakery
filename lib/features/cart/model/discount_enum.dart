enum DiscountEnum {
  fixed('fixed', 1),
  percentage('percentage', 2),
  ;

  const DiscountEnum(this.value, this.id);
  final String value;
  final int id;

  static DiscountEnum getEnumValue(String? type) {
    switch (type) {
      case 'fixed':
        return DiscountEnum.fixed;
      case 'percentage':
        return DiscountEnum.percentage;
      default:
        return DiscountEnum.fixed;
    }
  }
}
