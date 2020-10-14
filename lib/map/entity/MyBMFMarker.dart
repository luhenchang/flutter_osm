import 'import_library_map.dart';

class MyBMFMarker extends BMFMarker {
  dynamic relativelyObject;
  /// 标题
  String title;

  /// 子标题
  ///
  /// Android没有该属性
  String subtitle;

  /// marker位置经纬度
  BMFCoordinate position;

  /// 标注固定在指定屏幕位置,  必须与screenPointToLock一起使用。
  ///
  /// 注意：拖动Annotation isLockedToScreen会被设置为false。
  /// 若isLockedToScreen为true，拖动地图时annotaion不会跟随移动；
  /// 若isLockedToScreen为false，拖动地图时annotation会跟随移动。
  bool isLockedToScreen;

  /// 标注锁定在屏幕上的位置，
  ///
  /// 注意：地图初始化后才能设置screenPointToLock。可以在地图加载完成的回调方法：mapViewDidFinishLoading中使用此属性。
  BMFPoint screenPointToLock;

  /// markerView的复用标识符
  String identifier;

  /// markView显示的图片
  String icon;

  /// 默认情况下, annotation view的中心位于annotation的坐标位置，
  ///
  /// 可以设置centerOffset改变view的位置，正的偏移使view朝右下方移动，负的朝左上方，单位是像素
  ///
  /// 目前Android只支持Y轴设置偏移量对应SDK的 yOffset(int yOffset) 方法
  BMFPoint centerOffset;

  /// 默认情况下,标注没有3D效果，可以设置enabled3D改变使用3D效果，
  ///
  /// 使得标注在地图旋转和俯视时跟随旋转、俯视
  ///
  /// iOS独有
  bool enabled3D;

  /// 默认为true,当为false时view忽略触摸事件
  bool enabled;

  /// 当设为true支持将view在地图上拖动
  bool draggable;

  /// x方向缩放倍数
  ///
  /// Android独有
  double scaleX;

  /// y方向缩放倍数
  ///
  /// Android独有
  double scaleY;

  /// 透明度
  ///
  /// Android独有
  double alpha;

  /// 在有俯仰角的情况下，是否近大远小
  ///
  /// Android独有
  bool isPerspective;

  /// BMFMarker构造方法
  MyBMFMarker({
    @required this.position,
    @required this.icon,
    this.relativelyObject,
    this.title,
    this.subtitle,
    this.isLockedToScreen: false,
    this.screenPointToLock,
    this.identifier,
    this.centerOffset,
    this.enabled3D,
    this.enabled: true,
    this.draggable: false,
    this.scaleX: 1.0,
    this.scaleY: 1.0,
    this.alpha: 1.0,
    this.isPerspective,
    int zIndex: 0,
    bool visible: true,
  }) : super(
            position: position,
            icon: icon,
            title: title,
            subtitle: subtitle,
            isLockedToScreen: isLockedToScreen,
            screenPointToLock: screenPointToLock,
            identifier: identifier,
            centerOffset: centerOffset,
            enabled3D: enabled3D,
            enabled: true,
            draggable: false,
            scaleX:scaleX,
            scaleY:scaleY,
            alpha:alpha,
            isPerspective: isPerspective,
            zIndex: zIndex,
            visible: visible);
}
