import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/logic/cart_repo.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/buttons/add_to_cart_button.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartTile extends StatefulWidget {
  final HiveCartModel cartItem;
  final Box<HiveCartModel> box;
  final int index;
  const CartTile(
      {Key? key,
      required this.cartItem,
      required this.box,
      required this.index})
      : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  num totalItemPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return Consumer(
      builder: (context, ref, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                  color: colors(context).bodyTextColor!.withOpacity(0.4)),
            ),
          ),
          padding: EdgeInsets.only(bottom: 2.h, top: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 72.h,
                width: 72.h,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.cartItem.productImage,
                  placeholder: (context, url) => const Icon(Icons.image),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              5.pw,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.name,
                      style: textStyle.subTitle.copyWith(fontSize: 16),
                    ),
                    Text(
                      '€${totalItemPrice.toStringAsFixed(2)}',
                      style: textStyle.bodyText.copyWith(
                        color: colors(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Visibility(
                      visible: widget.cartItem.addons.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${S.current.addOns}: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            children: widget.cartItem.addons
                                .map(
                                  (e) => Text('${e.name}, '),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.cartItem.variant.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${S.current.variation}: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            children: widget.cartItem.variant
                                .map(
                                  (e) => Text('${e.name}, '),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppIconButton(
                    size: 28,
                    iconData: Icons.remove,
                    btnColor: colors(context).accentColor ??
                        AppStaticColor.accentColor,
                    iconColor: AppStaticColor.blackColor,
                    onTap: () {
                      ref.read(cartRepo).decrementProductQuantity(
                            cartItem: widget.cartItem,
                            cartBox: widget.box,
                            index: widget.index,
                          );
                      _calculatePrice();
                    },
                  ),
                  5.pw,
                  Text(
                    widget.cartItem.productsQTY.toString(),
                    style: textStyle.subTitle,
                  ),
                  5.pw,
                  AppIconButton(
                    size: 28,
                    iconData: Icons.add,
                    btnColor: colors(context).primaryColor ??
                        AppStaticColor.primaryColor,
                    onTap: () {
                      ref.read(cartRepo).incrementProductQuantity(
                            cartItem: widget.cartItem,
                            box: widget.box,
                            index: widget.index,
                          );
                      _calculatePrice();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _calculatePrice();
  }

  _calculatePrice() {
    totalItemPrice =0.0;
    num totalAddons = 0.0;
    num totalVariant = 0.0;
    num price = widget.cartItem.price;

    widget.cartItem.addons.forEach(
      (element) => totalAddons += element.price,
    );
    widget.cartItem.variant.forEach(
      (element) => totalVariant += element.price,
    );

    totalItemPrice =
        (totalAddons + totalVariant + price) * widget.cartItem.productsQTY;
  }
}
