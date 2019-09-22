import 'package:sfw_imports/sfw_imports.dart';
import 'models.dart';

@SfwDbConfig('ops', 3, version: 1)
abstract class DB {
  @SfwDbQuery(UserModel,false,'tbl_user',limit: 1,orderBy: "updated_at")
 getUser();
}
