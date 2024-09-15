import 'API.dart';
import '../util/http/VoidApiHttp.dart';
class DistributedInstallApi{

///null
static VoidApiHttp set(){
 return VoidApiHttp(Api.INSTALL_DISTRIBUTED_SET);
}

}