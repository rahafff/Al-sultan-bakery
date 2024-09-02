import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/blogs/blog-logic/blog_repo.dart';
import 'package:grocerymart/features/blogs/details-logic/details_provider.dart';
import 'package:grocerymart/features/blogs/model/blog_models.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/blogs/view/widget/news_details_header.dart';
import 'package:grocerymart/features/menu/logic/menu_repo.dart';
import 'package:grocerymart/features/menu/model/pages_model.dart';
import 'package:grocerymart/features/menu/view/menu_tab.dart';

import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/widgets/busy_loader.dart';

class PageDetailsScreen extends ConsumerStatefulWidget {
  final PageDetailsArguments arguments;
  const PageDetailsScreen({super.key, required this.arguments,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends ConsumerState<PageDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.arguments.title,),centerTitle: false,),
      body: FutureBuilder(
        future: ref.read(menuRepo).getPageInfo(widget.arguments.pageId),
        builder: ((context, AsyncSnapshot<PagesModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                S.of(context).someThingWrong,
                style: textStyle.subTitle,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final PagesModel? details = snapshot.data;

            return Padding(
              padding: EdgeInsets.all(10.0.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(details?.subtitle ?? '',style: textStyle.title,),
                    Html(
                      style: {
                        '*': Style(
                            fontSize: FontSize(14.sp),
                            fontFamily: 'Open Sans',
                            color: colors(context).bodyTextColor)
                      },
                      data: details?.body ?? '',
                    ),
                  ],
                ),
              ),
            );
          }
          return _buildLoader(context);
        }),
      ),
    );
  }



  _buildLoader(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxHeight: 120.h, minWidth: 100.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: colors(context).accentColor),
        width: 200,
        child: const BusyLoader(
          size: 120,
        ),
      ),
    );
  }
}
