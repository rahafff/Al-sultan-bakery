import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/features/products/model/review_model.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/util/context_less_nav.dart';

class BottomSheetFilterProduct extends StatefulWidget {
  final Function onClearFilter;
  final Function(double?, double?, int?) onFilter;
  final double? min;
  final double? max;
  final int? starCount;
  const BottomSheetFilterProduct(
      {super.key, required this.onClearFilter,
        required this.onFilter,
        this.max,
        this.min,
        this.starCount
      });

  @override
  State<BottomSheetFilterProduct> createState() =>
      _BottomSheetFilterProductState();
}

class _BottomSheetFilterProductState extends State<BottomSheetFilterProduct> {
  RangeValues _rangeSliderDiscreteValues = const RangeValues(1, 20);
  double start = 1.0;
  double end = 20.0;
  List<ReviewModel> reviews = [];

  int? selectStarCount;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.filterBy,
                style: textStyle.subTitle,
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppStaticColor.redColor),
                onPressed: () {
                  widget.onClearFilter();
                  context.nav.pop();
                },
                child: Text(
                  S.current.clearFilter,
                  style: textStyle.bodyTextSmall
                      .copyWith(color: AppStaticColor.whiteColor),
                ),
              ),
            ],
          ),
          Divider(),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    '${S.current.price}: ',
                    style: textStyle.bodyTextSmall
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text('$start' '\$'),
                      SizedBox(
                        width: 5,
                      ),
                      Text('-'),
                      SizedBox(
                        width: 5,
                      ),
                      Text('$end' '\$'),
                    ],
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(start, end),
                labels: RangeLabels(start.toString(), end.toString()),
                onChanged: (value) {
                  setState(() {
                    start = value.start;
                    end = value.end;
                  });
                },
                min: 1.0,
                max: 20.0,
                divisions: 20,
                activeColor: AppStaticColor.primaryColor,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text('${S.current.reviews}: ', style: textStyle.bodyTextSmall
                    .copyWith(fontWeight: FontWeight.w800)),
              ),
              Expanded(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: reviews
                      .map(
                        (e) => RadioListTile(
                            activeColor: AppStaticColor.primaryColor,
                            title: Text(e.message),
                            value: e.starNumber,
                            groupValue: selectStarCount,
                            onChanged: (star) {
                              selectStarCount = star;
                              setState(() {});
                            }),
                      )
                      .toList(),
                ),
              )
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppStaticColor.primaryColor),
                  onPressed: () {
                    context.nav.pop();
                    widget.onFilter(start,end,selectStarCount);
                  },
                  child: Text(
                    S.current.apply,
                    style: textStyle.buttonText
                        .copyWith(color: AppStaticColor.whiteColor),
                  )),
            ],
          )
        ],
      ),
    );
  }

  initReviewOptions() {
    reviews = [
      ReviewModel(message: S.current.oneStar, starNumber: 1),
      ReviewModel(message: S.current.twoStar, starNumber: 5),
      ReviewModel(message: S.current.threeStar, starNumber: 3),
      ReviewModel(message: S.current.fourStar, starNumber: 4),
    ];
  }

  initPreviousValue(){
    start = widget.min ?? 1.0;
    end = widget.max ?? 20.0;
    selectStarCount = widget.starCount;
  }

  @override
  void initState() {
    super.initState();
    initReviewOptions();
    initPreviousValue();
  }
}
