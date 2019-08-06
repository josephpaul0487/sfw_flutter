

enum NavigationType {
  PUSH_NAMED,PUSH,PUSH_NAMED_REPLACE,REMOVE_NAMED_UNTIL
}

class SfwAnim {

  static Future<dynamic> navigate(BuildContext ctx,String route,Object classObject,{NavigationType type=NavigationType.PUSH_NAMED,Object arguments,bool useAsync=false,RoutePredicate predicate}) async {
    if(useAsync) {
      switch (type) {
        case NavigationType.PUSH_NAMED:
          return await Navigator.of(ctx).push(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(name: route, arguments: arguments,)));
          break;
        case NavigationType.PUSH:
          return await Navigator.of(ctx).push(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(arguments: arguments,)));
          break;
        case NavigationType.PUSH_NAMED_REPLACE:
          return await Navigator.of(ctx).pushReplacement(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(name: route, arguments: arguments,)));
          break;
        case NavigationType.REMOVE_NAMED_UNTIL:
          return await Navigator.of(ctx).pushAndRemoveUntil(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(name: route, arguments: arguments,)),
              predicate ?? (Route<dynamic> route) => false);
          break;
      }
    } else {
      switch (type) {
        case NavigationType.PUSH_NAMED:
          Navigator.of(ctx).push(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(name: route, arguments: arguments,)));
          break;
        case NavigationType.PUSH:
          Navigator.of(ctx).push(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(arguments: arguments,)));
          break;
        case NavigationType.PUSH_NAMED_REPLACE:

          Navigator.of(ctx).push(CupertinoPageRoute(
              builder: (context) => classObject,maintainState: route==null || route.isEmpty,
              settings: RouteSettings(name: route, arguments: arguments,)));
          try {
            if(route==null || route.isEmpty)
              Navigator.of(ctx).removeRoute(ModalRoute.of(ctx));
          } catch(e){}

          break;
        case NavigationType.REMOVE_NAMED_UNTIL:
          Navigator.of(ctx).pushAndRemoveUntil(CupertinoPageRoute(
              builder: (context) => classObject,
              settings: RouteSettings(name: route, arguments: arguments,)),
              predicate ?? (Route<dynamic> route) => false);
          break;
      }
    }
    return null;
  }

  static Widget fadeAnimation(
      TickerProviderStateMixin tickerProvider, int duration,
      {@required Widget child,
      double durationPercentFrom = 0,
      double durationPercentTo = 1,
      AnimationStatusListener listener,
      bool addAnimation = true,
      bool hideChild = false,
      bool childInvisible = false}) {
    if (addAnimation) {
      AnimationController controller = AnimationController(
          duration: Duration(milliseconds: duration), vsync: tickerProvider);
      Animation animation = CurvedAnimation(
          parent: controller,
          curve: Interval(durationPercentFrom, durationPercentTo,
              curve: Curves.easeIn));
      controller.forward();
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          try {
            controller.dispose();
          } catch (e) {}
        }
      });

      if (listener != null) animation.addStatusListener(listener);

      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
    return hideChild
        ? Container()
        : childInvisible ? Opacity(opacity: 0, child: child) : child;
  }

  static Widget scaleAnimation(
      SingleTickerProviderStateMixin tickerProvider, int duration,
      {@required Widget child,
      double durationPercentFrom = 0,
      double durationPercentTo = 1,
      AnimationStatusListener listener,
      bool addAnimation = true,
      bool hideChild = false,
      bool childInvisible = false}) {
    if (addAnimation) {
      AnimationController controller = AnimationController(
          duration: Duration(milliseconds: duration), vsync: tickerProvider);
      Animation animation =
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      controller.forward();
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          try {
            controller.dispose();
          } catch (e) {}
        }
      });

      if (listener != null) animation.addStatusListener(listener);

      return ScaleTransition(
        scale: animation,
        child: child,
      );
    }
    return hideChild
        ? Container()
        : childInvisible ? Opacity(opacity: 0, child: child) : child;
  }
}

class FadeAnimWidget extends StatefulWidget {
  final TickerProviderStateMixin tickerProvider;
  final int duration;
  final Widget child;
  final double durationPercentFrom;

  final double durationPercentTo;

  final AnimationStatusListener listener;
  final bool addAnimation;

  final bool hideChild;

  final bool childInvisible;

  const FadeAnimWidget(this.tickerProvider, this.duration,
      {Key key,
      this.durationPercentFrom=0.0,
      this.durationPercentTo=1.0,
      this.listener,
      this.addAnimation= true,
      this.hideChild=false,
      this.childInvisible=false,
      @required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FadeAnimWidgetState();
  }
}

class _FadeAnimWidgetState extends State<FadeAnimWidget> {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    if (widget.addAnimation) {
      controller = AnimationController(
          duration: Duration(milliseconds: widget.duration),
          vsync: widget.tickerProvider);
      animation = CurvedAnimation(
          parent: controller,
          curve: Interval(widget.durationPercentFrom, widget.durationPercentTo,
              curve: Curves.easeIn));
      controller.forward();
      if (widget.listener != null) animation.addStatusListener(widget.listener);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.addAnimation)
      return ScaleTransition(
        scale: animation,
        child: widget.child,
      );

    return widget.hideChild
        ? Container()
        : widget.childInvisible
            ? Opacity(opacity: 0, child: widget.child)
            : widget.child;
  }

  @override
  void dispose() {
    if (controller != null) controller.dispose();
    super.dispose();
  }
}

class ScaleAnimWidget extends StatefulWidget {
  final Widget child;
  final bool expand;
  final bool addAnimation;
  final bool isVertical;
  final int duration;

  const ScaleAnimWidget(
      {Key key,
      this.expand = true,
      this.child,
      this.addAnimation = true,
      this.isVertical = true,
      this.duration = 500})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScaleAnimState();
  }
}

class _ScaleAnimState extends State<ScaleAnimWidget>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  @override
  void dispose() {
    if (expandController != null) expandController.dispose();
    super.dispose();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: Duration(milliseconds:  widget.duration));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ScaleAnimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expand ) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        axis: widget.isVertical ? Axis.vertical : Axis.horizontal,
        sizeFactor: animation,
        child: widget.child);
  }
}


class RotateAnimWidget extends StatefulWidget {
  final Widget child;
  final bool forward;
  final bool addAnimation;
  final int duration;
  final double from;
  final double to;

  const RotateAnimWidget(
      {Key key,
        this.forward = true,
        this.child,
        this.from=0.0,
        this.to=1.0,
        this.addAnimation = true,
        this.duration = 300})
      :assert(from>=0.0 && to<=1.0 &&  from<to), super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RotateAnimState();
  }
}

class _RotateAnimState extends State<RotateAnimWidget>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  @override
  void dispose() {
    if (expandController != null) expandController.dispose();
    super.dispose();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: Duration(milliseconds:  widget.duration));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: widget.from, end: widget.to).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(RotateAnimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.forward ) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: animation,
        
        child: widget.child);
  }
}



class DrawerAnimWidget extends StatefulWidget {
  final Widget child;
  final bool isVertical;
  final int duration;

  const DrawerAnimWidget(
      {Key key,
        this.child,
        this.isVertical = false,
        this.duration = 1000})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DrawerAnimState();
  }
}

class _DrawerAnimState extends State<DrawerAnimWidget>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;
  bool expand=false;

  @override
  void initState() {
    super.initState();
    expand=true;
    prepareAnimations();
    _update();
  }

  @override
  void dispose() {
    expand=false;
    if (expandController != null) expandController.dispose();
    super.dispose();
  }

  ///Setting up the animation
  void prepareAnimations() {
    if(expandController==null) {
      expandController = AnimationController(
          vsync: this, duration: Duration(milliseconds: widget.duration));
      Animation curve = CurvedAnimation(
        parent: expandController,
        curve: Curves.fastOutSlowIn,
      );
      animation = Tween(begin: 0.0, end: 1.0).animate(curve)
        ..addListener(() {
          setState(() {});
        });
    }
  }

  _update() {
    if (expand ) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(DrawerAnimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
_update();

  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        axis: widget.isVertical ? Axis.vertical : Axis.horizontal,
        sizeFactor: animation,
        child: widget.child);
  }
}

class CollapseAnimWidget extends StatefulWidget {
  final Widget expandedChild;
  final Widget collapsedChild;
  final bool expand;
  final double tweenFrom;
  final double tweenTo;

  const CollapseAnimWidget(
      {Key key, this.expand = true, this.expandedChild, this.collapsedChild})
      : this.tweenFrom = expand ? 100 : 50,
        this.tweenTo = expand ? 50 : 100,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CollapseAnimState();
  }
}

class _CollapseAnimState extends State<CollapseAnimWidget>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 10000));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(
      begin: widget.tweenFrom,
      end: widget.tweenTo,
    ).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(CollapseAnimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "${animation.value}   from=${widget.tweenFrom}    to=${widget.tweenTo}");
    return Container(
      width: animation.value,
      alignment: FractionalOffset.center,
      child:
          animation.value <= 50 ? widget.collapsedChild : widget.expandedChild,
    );
  }
}
