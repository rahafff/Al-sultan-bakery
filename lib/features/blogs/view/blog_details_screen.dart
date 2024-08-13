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

import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/widgets/busy_loader.dart';

class BlogDetailsScreen extends ConsumerStatefulWidget {
  final BlogResponse blog;
  const BlogDetailsScreen({super.key, required this.blog});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends ConsumerState<BlogDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);

    return Scaffold(
      body: FutureBuilder(
        future: ref.read(blogRepo).getBlogDetails(blogId: widget.blog.id),
        builder: ((context, AsyncSnapshot<BlogDetailsModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                S.of(context).someThingWrong,
                style: textStyle.subTitle,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final BlogDetailsModel? details = snapshot.data;

            return Padding(
              padding: EdgeInsets.all(10.0.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    NewsDetailsHeader(shopDetails: details!,),
                    Html(
                      style: {
                        '*': Style(
                            fontSize: FontSize(14.sp),
                            fontFamily: 'Open Sans',
                            color: colors(context).bodyTextColor)
                      },
                      data: details.content,
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

  Future<void> getUserReviewList() async {
    await ref
        .read(blogDetailsNotifierProvider.notifier)
        .getBlogDetails(blogId: widget.blog.id)
        .then((response) {});
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
