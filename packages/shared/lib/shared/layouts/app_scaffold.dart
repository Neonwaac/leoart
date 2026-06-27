import 'package:flutter/material.dart';
import 'package:shared/shared/layouts/responsive_padding.dart';
import 'package:shared/shared/layouts/safe_area_wrapper.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final bool showBackButton;
  final String? title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? bodyPadding;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.showBackButton = false,
    this.title,
    this.actions,
    this.bodyPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar ??
          (title != null || showBackButton || actions != null
              ? AppBar(
                  title: title != null ? Text(title!) : null,
                  leading: showBackButton
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      : null,
                  actions: actions,
                )
              : null),
      body: SafeAreaWrapper(
        child: ResponsivePadding(padding: bodyPadding, child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
