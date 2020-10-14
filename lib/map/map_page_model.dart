import 'package:flutterosm/base/mvvm/base.dart';
import 'package:flutterosm/base/mvvm/common.dart';
import 'package:flutterosm/map/entity/map_page.dart';

class MapPageModel extends BaseModel{
  Future<DataResponse<MapPageEntity>> getHttpRequst()async{
    DataResponse<MapPageEntity> dataResponse=new DataResponse(entity:null);
    return await dataResponse;
  }


}