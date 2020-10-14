import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterosm/map/vm/map_page_vm.dart';

class MapWidget{
  //region 左边功能按钮
 static Widget visibleMark() {
    return Container(
      child: Image.asset(
        "imag/map_visible_marker.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
      ),
    );
  }

 static Widget lenthImage() {
    return Container(
      child: Image.asset(
        "imag/map_visible_length.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
      ),
    );
  }

 static Widget visibleAllPoint() {
    return Container(
      child: Image.asset(
        "imag/map_visible_all.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
        fit: BoxFit.fill,
      ),
    );
  }

 static Widget positionLocation(MapPageVM vm) {
    return InkWell(
      onTap: () {
        vm.moveToCenter();
      },
      child: Image.asset(
        "imag/map_location.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
        fit: BoxFit.fill,
      ),
    );
  }

  //endregion
  //region 右边功能按钮
  //辅助功能
 static Widget accessibility() {
    return Container(
      child: Image.asset(
        "imag/map_fzebp.png",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
        fit: BoxFit.fill,
      ),
    );
  }

 static Widget setPositioning(MapPageVM vm) {
    return InkWell(
      onTap: () {
        vm.positioningMobile = !vm.positioningMobile;
      },
      child: Container(
        child: Image.asset(
          "imag/map_location_selected.webp",
          width: ScreenUtil().setHeight(91),
          height: ScreenUtil().setHeight(91),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

 static  Widget addXiahuGuidian() {
    return Container(
      child: Image.asset(
        "imag/main_gd.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
        fit: BoxFit.fill,
      ),
    );
  }

 static Widget addXiahu() {
    return Container(
      child: Image.asset(
        "imag/main_xiahu.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
        fit: BoxFit.fill,
      ),
    );
  }

 static  Widget addSpan() {
    return Container(
      child: Image.asset(
        "imag/main_kyw.webp",
        width: ScreenUtil().setHeight(91),
        height: ScreenUtil().setHeight(91),
        fit: BoxFit.fill,
      ),
    );
  }
//endregion
}
