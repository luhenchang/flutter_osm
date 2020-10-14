import 'package:flutter/foundation.dart';
import 'package:flutterosm/base/exclefile/excle_color.dart';
import 'package:flutterosm/base/exclefile/excle_writablecellformat.dart';
import 'package:flutterosm/base/exclefile/excle_writablefont.dart';
import 'package:flutterosm/map/entity/import_library_map.dart';

class MapPageVM extends BaseViewModel<MapPageModel, MapPageEntity> {
  //region 定位
  StreamSubscription<Map<String, Object>> _locationListener;
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
  Map<String, Object> _loationResult;
  BaiduLocation _baiduLocation;

  //endregion
  BMFMapOptions mapOptions;
  ValueNotifier<BMFMapOptions> vnTime;
  /// 我的位置
  BMFUserLocation userLocation;
  BMFMapController controller;
  var positioningMobile = true;
  BMFMapStatus mapStatus;

  @override
  void init() {
    _location();
    mapOptions = BMFMapOptions(
        showZoomControls: false,
        mapType: BMFMapType.Satellite,
        center: BMFCoordinate(39.917215, 116.380341),
        zoomLevel: 12,
        scrollEnabled: true,
        updateTargetScreenPtWhenMapPaddingChanged: true,
        mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0),
        showMapScaleBar: false);
    vnTime = ValueNotifier(mapOptions);
    super.init();
  }

  @override
  Future<DataResponse<MapPageEntity>> requestHttp(
      {bool isLoad, int page, params}) {
    return model.getHttpRequst();
  }

  /// 启动定位
  void startLocation() {
    if (null != _locationPlugin) {
      _setLocOption();
      _locationPlugin.startLocation();
    }
  }

  //定位权限和定位开启。
  Future<void> _location() async {
    await _locationPlugin.requestPermission();
    startLocation();

    /// 设置ios端ak, android端ak可以直接在清单文件中配置
    //LocationFlutterPlugin.setApiKey("百度地图开放平台申请的ios端ak");
    _locationListener =
        _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      _loationResult = result;
      try {
        _baiduLocation = BaiduLocation.fromMap(result);
        BMFCoordinate coordinate =
            BMFCoordinate(_baiduLocation.latitude, _baiduLocation.longitude);
        if (positioningMobile)
          controller?.setCenterCoordinate(coordinate, true);
      } catch (e) {
        print(e);
      }
    });
  }

  //region 定位【开始定位，停止定位，启动定位等】
  /// 设置android端和ios端定位参数
  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停
    Map iosMap = iosOption.getMap();
    _locationPlugin.prepareLoc(androidMap, iosMap);
  }

  /// 停止定位
  void stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

  //endregion
  //region 移动到定位中心
  void moveToCenter() {
    BMFCoordinate coordinate =
        BMFCoordinate(_baiduLocation?.latitude, _baiduLocation?.longitude);
    controller?.setCenterCoordinate(coordinate, true);
  }

  //endregion
  //region设置地图区域改变完成后会调用接口
  void setMapRegionDidChangeCallback(BMFMapController controller) {
    if (this.controller == null) {
      this.controller = controller;
      this.controller?.setMapRegionDidChangeCallback(
          callback: (BMFMapStatus mapStatus) {
        this.mapStatus = mapStatus;
      });
    }
  }

  //endregion
  /// 更新位置
  void updateUserLocation(latitude, longtitude) {
    BMFCoordinate coordinate = BMFCoordinate(latitude, longtitude);
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);
    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    userLocation = userLocation;
    controller?.updateLocationData(userLocation);
  }

  //region marker添加
  List<BMFMarker> _markers;
  bool _addState = false;
  String _btnText = "删除";
  Timer _timer;
  bool enable = false;
  bool dragable = false;
  bool startState = true;
  BMFMarker _marker;
  BMFMarker _cureentmarker;

  BMFMarker _marker1,
      _marker2,
      _marker3,
      _marker4,
      _marker5,
      _marker6,
      _marker7,
      _marker8,
      _marker9,
      _marker10;

  int falg = 0;

  /// 批量添加大头针
  Future<void> addMapMarkers() async {
    BMFCoordinate bmfCenter;
    if (positioningMobile) {
      bmfCenter =
          BMFCoordinate(_baiduLocation?.latitude, _baiduLocation?.longitude);
    } else {
      bmfCenter = BMFCoordinate(
          mapStatus?.targetGeoPt?.latitude, mapStatus?.targetGeoPt?.longitude);
    }

//    double algle = 0f;
//    if (markerRotate > 180 && markerRotate < 360) { //180-360
//      algle = (360 - markerRotate);
//    } else if (markerRotate > 0 && markerRotate < 180) {
//      algle = 180 - markerRotate + 180;
//    }
//    markerOptions.rotate((float) algle);

    _marker = BMFMarker(
        markerType: 0,
        markerRotate: 0,
        title: '东城项目01',
        subtitle: 'test',
        titleColor: "#ff00ff",
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/y_ty_hws.png',
        enabled: true,
        draggable: dragable);
    _marker1 = BMFMarker(
        markerType: 3,
        markerRotate: 45,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker2 = BMFMarker(
        markerType: 3,
        markerRotate: 89,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker3 = BMFMarker(
        markerType: 3,
        markerRotate: 160,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker4 = BMFMarker(
        markerType: 3,
        markerRotate: 179,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker5 = BMFMarker(
        markerType: 3,
        markerRotate: 260,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker6 = BMFMarker(
        markerType: 3,
        markerRotate: 270,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker7 = BMFMarker(
        markerType: 3,
        markerRotate: 330,
        title: '东城项目01',
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/c_ty_zsfhkg.png',
        enabled: true,
        draggable: dragable);
    _marker8 = BMFMarker(
        markerType: 1,
        markerRotate: 0,
        title: '东城项目01',
        subtitle: 'test',
        titleColor: "#00ffff",
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/y_ty_hwx.png',
        enabled: true,
        draggable: dragable);
    _marker9 = BMFMarker(
        markerType: 2,
        markerRotate: 0,
        title: '东城项目01',
        titleColor: "#ffffff",
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/map_tower.png',
        enabled: true,
        draggable: dragable);
    _marker10 = BMFMarker(
        markerType: 0,
        markerRotate: 0,
        title: '东城项目01',
        titleColor: "#ffffff",
        subtitle: 'test',
        position: bmfCenter,
        identifier: 'flutter_marker',
        icon: 'imag/y_ty_hws.png',
        enabled: true,
        draggable: dragable);
    if (falg == 0) {
      this.controller?.addMarker(_marker);
      falg++;
    } else if (falg == 1) {
      this.controller?.addMarker(_marker1);
      falg++;
    } else if (falg == 2) {
      this.controller?.addMarker(_marker2);
      falg++;
    } else if (falg == 3) {
      this.controller?.addMarker(_marker3);
      falg++;
    } else if (falg == 4) {
      this.controller?.addMarker(_marker4);
      falg++;
    } else if (falg == 5) {
      this.controller?.addMarker(_marker5);
      falg++;
    } else if (falg == 6) {
      this.controller?.addMarker(_marker6);
      falg++;
    } else if (falg == 7) {
      this.controller?.addMarker(_marker7);
      falg++;
    } else if (falg == 8) {
      _cureentmarker = _marker8;
      this.controller?.addMarker(_marker8);
      falg++;
    } else if (falg < 15) {
      _cureentmarker = _marker9;
      this.controller?.addMarker(_marker9);
      falg++;
    } else {
      _cureentmarker = _marker10;
      this.controller?.addMarker(_marker10);
    }

    /// 地图marker选中回调
    this.controller?.setMaptDidSelectMarkerCallback(
        callback: (String id, dynamic extra) {
      print('mapDidSelectMarker--\n');
    });

    /// 地图marker取消选中回调
    this.controller?.setMapDidDeselectMarkerCallback(
        callback: (String id, dynamic extra) {
      print('mapDidDeselectMarker');
    });

    /// 地图marker点击回调
    this.controller?.setMapClickedMarkerCallback(
        callback: (String id, dynamic extra) {
      print('mapClickedMarker--\n marker = $id');
    });
    /// 拖拽marker点击回调
    this.controller?.setMapDragMarkerCallback(
        callback: (String id, dynamic extra) {
      String state = extra['state'];

      dynamic centerMap = extra['center'];

      print('drag mapClickedMarker--\n marker = $id');
    });
    if (falg >= 8) {
      /// 坐标点
      List<BMFCoordinate> coordinates = List(5);
      coordinates[0] = BMFCoordinate(39.865, 116.304);
      coordinates[1] = BMFCoordinate(39.825, 116.354);
      coordinates[2] = BMFCoordinate(39.855, 116.394);
      coordinates[3] = BMFCoordinate(39.805, 116.454);
      coordinates[4] = BMFCoordinate(39.865, 116.504);

      /// 颜色索引,索引的值都是0,表示所有线段的颜色都取颜色集colors的第一个值
      List<int> indexs = [0, 0, 0, 0];

      /// 颜色
      List<Color> colors = List(4);
      colors[0] = Colors.blue;
      colors[1] = Colors.orange;
      colors[2] = Colors.red;
      colors[3] = Colors.green;

      /// 创建polyline
      BMFPolyline colorsPolyline = BMFPolyline(
          coordinates: coordinates,
          indexs: indexs,
          colors: colors,
          width: 16,
          lineDashType: BMFLineDashType.LineDashTypeNone,
          lineCapType: BMFLineCapType.LineCapButt,
          lineJoinType: BMFLineJoinType.LineJoinRound);

      /// 添加polyline
       controller?.addPolyline(colorsPolyline);
    }
  }

  //endregion
  @override
  void dispose() {
    super.dispose();
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }
}
