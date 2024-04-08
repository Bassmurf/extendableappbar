import 'package:flutter/material.dart';

class ExtendableAppBarWillPopScope extends StatefulWidget {
  const ExtendableAppBarWillPopScope({
    Key? key,
    required this.child,
    required this.onWillPop,
  }) : super(key: key);

  final Widget child;
  final WillPopCallback onWillPop;

  @override
  _ExtendableAppBarWillPopScopeState createState() => _ExtendableAppBarWillPopScopeState();

  static _ExtendableAppBarWillPopScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ExtendableAppBarWillPopScopeState>();
  }
}

class _ExtendableAppBarWillPopScopeState extends State<ExtendableAppBarWillPopScope> {
  ModalRoute<dynamic>? _route;

  _ExtendableAppBarWillPopScopeState? _descendant;

  set descendant(state) {
    _descendant = state;
    updateRouteCallback();
  }

  Future<bool> onWillPop() async {
    bool? willPop;
    if (_descendant != null) {
      willPop = await _descendant!.onWillPop();
    }
    if (willPop == null || willPop) {
      willPop = await widget.onWillPop();
    }
    return willPop;
  }

  void updateRouteCallback() {
    _route?.removeScopedWillPopCallback(onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(onWillPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var parentGuard = ExtendableAppBarWillPopScope.of(context);
    if (parentGuard != null) {
      parentGuard.descendant = this;
    }
    updateRouteCallback();
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
