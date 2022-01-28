import 'dart:math';
import 'package:flutter/material.dart';

class StarWarsCrawl extends StatefulWidget {
  final String title;
  final String crawlText;

  const StarWarsCrawl(this.title, this.crawlText, {Key? key}) : super(key: key);

  @override
  _StarWarsCrawlState createState() => _StarWarsCrawlState();
}

class _StarWarsCrawlState extends State<StarWarsCrawl> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ClipRect(
        child: _StarWarsCrawlAnimation(
          widget.title,
          widget.crawlText,
          controller: _animationController,
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class _StarWarsCrawlAnimation extends StatelessWidget {
  final Size size;
  final AnimationController controller;
  final Animation<double> spaceOpacity;
  final Animation<double> introTextOpacityShow;
  final Animation<double> introTextOpacityHide;
  final Animation<double> starWarsLogoOpacityShow;
  final Animation<double> starWarsLogoOpacityHide;
  final Animation<double> starWarsLogoSize;
  final Animation<double> crawlingTextOpacityShow;
  final Animation<double> crawlingTextOpacityHide;
  final Animation<double> crawlingTextPosition;

  final String title;
  final String crawlText;

  _StarWarsCrawlAnimation(this.title, this.crawlText, {required this.controller, required this.size, Key? key})
      : introTextOpacityShow = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.01, curve: Curves.ease),
        )),
        introTextOpacityHide = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.08, 0.1, curve: Curves.ease),
        )),
        spaceOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.12, 0.12, curve: Curves.ease),
        )),
        starWarsLogoOpacityShow = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.12, 0.12, curve: Curves.ease),
        )),
        starWarsLogoOpacityHide = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.25, 0.3, curve: Curves.ease),
        )),
        starWarsLogoSize = Tween(begin: size.width, end: 0.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.09, 0.25, curve: Curves.decelerate),
        )),
        crawlingTextPosition = Tween(begin: size.height / 2, end: -size.height / 2).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.15, 1.0, curve: Curves.linear),
        )),
        crawlingTextOpacityShow = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.15, 0.25, curve: Curves.linear),
        )),
        crawlingTextOpacityHide = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.9, 1.0, curve: Curves.linear),
        )),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
        color: Colors.black,
        child: Stack(
          children: [
            _SpaceBackground(opacity: spaceOpacity),
            _IntroText(opacity: controller.value > 0.09 ? introTextOpacityHide : introTextOpacityShow),
            _StarWarsLogo(
                opacity: controller.value > 0.2 ? starWarsLogoOpacityHide : starWarsLogoOpacityShow,
                size: starWarsLogoSize),
            _CrawlingText(
              title,
              crawlText,
              position: crawlingTextPosition,
              opacity: controller.value > 0.5 ? crawlingTextOpacityHide : crawlingTextOpacityShow,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: _buildAnimation);
  }
}

class _IntroText extends StatelessWidget {
  final Animation<double> opacity;

  const _IntroText({required this.opacity}) : super(key: const ValueKey('StarWarsCrawlIntroText'));

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.value,
      child: const Center(
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              'A long time ago in a galaxy far,\nfar away...',
              style: TextStyle(
                color: Color(0xFF11B2A3),
                fontSize: 72,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LittleStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 1,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SpaceBackground extends StatefulWidget {
  final Animation<double> opacity;

  const _SpaceBackground({required this.opacity}) : super(key: const ValueKey('StarWarsCrawlSpaceBackground'));

  @override
  _SpaceBackgroundState createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<_SpaceBackground> {
  final int _starCount = 300;
  late List<Widget> _stars;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stars = _generateStars();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity.value,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.black,
          child: Stack(children: _stars),
        ),
      ),
    );
  }

  List<Widget> _generateStars() {
    return List.generate(_starCount, (index) {
      List<double> xy = _getRandomPosition(context);
      return Positioned(
        top: xy[0],
        left: xy[1],
        child: _LittleStar(),
      );
    });
  }

  List<double> _getRandomPosition(BuildContext context) {
    double x = MediaQuery.of(context).size.height;
    double y = MediaQuery.of(context).size.width;

    double randomX = double.parse((Random().nextDouble() * x).toStringAsFixed(3));
    double randomY = double.parse((Random().nextDouble() * y).toStringAsFixed(3));

    return [randomX, randomY];
  }
}

class _StarWarsLogo extends StatelessWidget {
  final Animation<double> size;
  final Animation<double> opacity;

  const _StarWarsLogo({required this.size, required this.opacity}) : super(key: const ValueKey('StarWarsCrawlLogo'));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: opacity.value,
        child: Image.network(
          'https://logos-download.com/wp-content/uploads/2016/09/Star_Wars_logo-1.png',
          width: size.value,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class _CrawlingText extends StatelessWidget {
  final Animation<double> position;
  final Animation<double> opacity;

  final String title;
  final String crawlText;

  final _textStyle = const TextStyle(
    color: Color(0xFFFFC500),
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  const _CrawlingText(this.title, this.crawlText, {required this.position, required this.opacity})
      : super(key: const ValueKey('StarWarsCrawlText'));

  @override
  Widget build(BuildContext context) {
    final double maxWidthConstraint = MediaQuery.of(context).size.width;

    return Opacity(
      opacity: opacity.value,
      child: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.007)
            ..rotateX(5.6)
            ..translate(0.0, position.value, 0.0),
          alignment: FractionalOffset.center,
          child: FittedBox(
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: maxWidthConstraint * 1.6,
                  ),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: _textStyle,
                      ),
                      Text(
                        crawlText,
                        textAlign: TextAlign.justify,
                        style: _textStyle,
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
