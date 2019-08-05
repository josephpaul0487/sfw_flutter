import 'package:build/build.dart';
//import 'package:xml/xml.dart' as xml;
class XmlDocs {

  Future<String> build(StringBuffer s,BuildStep buildStep) async {
    try {
       String appStyles=await readAsset(buildStep.inputId, buildStep);

    } catch(e) {}
    return "";
  }

  Future<String> readAsset(AssetId assetId,BuildStep buildStep) async {
    try {
      return await buildStep.readAsString(assetId);
    } catch(e){
      return e.toString();
    }
  }
}