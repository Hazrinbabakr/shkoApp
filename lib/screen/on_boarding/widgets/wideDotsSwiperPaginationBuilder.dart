
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WideDotsSwiperPaginationBuilder extends SwiperPlugin {
  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(config.itemCount??0, (index) {
          bool isActive = config.activeIndex == index;
          return AnimatedContainer(
            duration: Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            width: isActive ? 32.0 : 8.0,
            decoration: BoxDecoration(
              color: isActive ? Colors.black :
              Color(0xFFBFBFBF),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          );
        }
        )
    );
  }
}
