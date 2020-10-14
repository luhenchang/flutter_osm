import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterosm/base/mvvm/base.dart';
import 'package:flutterosm/base/mvvm/common.dart';
import 'package:flutterosm/map/vm/map_page_vm.dart';
import 'page/map_page_widget.dart';

class MapPageView extends StatelessWidget with BaseView<MapPageVM> {
  MapPageVM mVm;
  ValueNotifier<String> vnTime = ValueNotifier("暂无");

  @override
  ViewConfig<MapPageVM> initConfig(BuildContext context) {
    /// 动态申请定位权限
    return ViewConfig(vm: MapPageVM(), load: false);
  }

  @override
  Widget vmBuild(
      BuildContext context, MapPageVM vm, Widget child, Widget state) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: InkWell(
          child: Icon(
            Icons.chevron_left,
            size: ScreenUtil().setWidth(66),
          ),
        ),
        elevation: 0,
      ),
      body: state ??
          Stack(
            children: <Widget>[
              Container(
                height: ScreenUtil.screenHeight,
                width: ScreenUtil.screenWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    BMFMapWidget(
                      onBMFMapCreated: (controller) {
                        /// 地图区域改变完成后会调用此接口
                        vm.setMapRegionDidChangeCallback(controller);
                      },
                      mapOptions: vm.mapOptions,
                    ),
                    Image.asset(
                      "imag/map_center.webp",
                      width: ScreenUtil().setHeight(75),
                      height: ScreenUtil().setHeight(75),
                    ),
                  ],
                ),
              ),
              //region 左边按钮
              Positioned(
                child: MapWidget.visibleMark(),
                top: ScreenUtil().setHeight(203),
                left: ScreenUtil().setWidth(60),
              ),
              //显示档距
              Positioned(
                child: MapWidget.lenthImage(),
                top: ScreenUtil().setHeight(339),
                left: ScreenUtil().setWidth(60),
              ),
              //显示和隐藏所有的点
              Positioned(
                child: MapWidget.visibleAllPoint(),
                top: ScreenUtil().setHeight(470),
                left: ScreenUtil().setWidth(60),
              ),
              //移动到地图中点
              Positioned(
                child: MapWidget.positionLocation(vm),
                bottom: ScreenUtil().setHeight(516),
                left: ScreenUtil().setWidth(60),
              ),
              //endregion
              //region 中间按钮
              Positioned(
                bottom: ScreenUtil().setWidth(51),
                left: ScreenUtil().setWidth(239),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "imag/map_dl.webp",
                          height: ScreenUtil().setHeight(130),
                          width: ScreenUtil().setWidth(309),
                        ),
                        Image.asset(
                          "imag/map_zhanfang.webp",
                          height: ScreenUtil().setHeight(130),
                          width: ScreenUtil().setWidth(309),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        vm.addMapMarkers();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        child: Image.asset(
                          "imag/map_tower.webp",
                          height: ScreenUtil().setHeight(240),
                          width: ScreenUtil().setHeight(240),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //endregion
              //region 右边按钮
              Positioned(
                child: MapWidget.accessibility(), //辅助
                top: ScreenUtil().setHeight(203),
                right: ScreenUtil().setWidth(60),
              ),
              Positioned(
                child: MapWidget.setPositioning(vm), //外星定位
                top: ScreenUtil().setHeight(339),
                right: ScreenUtil().setWidth(60),
              ),
              Positioned(
                child: MapWidget.addXiahuGuidian(), //辅助
                bottom: ScreenUtil().setHeight(785),
                right: ScreenUtil().setWidth(60),
              ),
              Positioned(
                child: MapWidget.addXiahu(), //外星定位
                bottom: ScreenUtil().setHeight(599),
                right: ScreenUtil().setWidth(60),
              ),
              Positioned(
                child: MapWidget.addSpan(), //外星定位
                bottom: ScreenUtil().setHeight(416),
                right: ScreenUtil().setWidth(60),
              ),
              //endregion
            ],
          ),
    );
  }
}


