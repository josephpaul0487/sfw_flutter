import 'package:build/build.dart';
import 'package:xml/xml.dart' as xml;
class XmlDocs {

  build(StringBuffer s,BuildStep buildStep) async {
    try {
       await readColor(s,buildStep);

    } catch(e) {}
  }

  readColor(StringBuffer s,BuildStep buildStep) async {
    try {
      String appColors=await readAsset(AssetId(buildStep.inputId.package, "lib/values/color.xml"), buildStep);
      s.writeln("/*$appColors*/");
      if(appColors.isNotEmpty) {
        xml.XmlDocument document=xml.parse(appColors);
        document.children.forEach((node){
          s.writeln("//NODE = ${node.text}");
          if(node.children.length>0) {
            node.children.forEach((color){
              color.attributes.forEach((attr){
                s.writeln("//${attr.name}  ${attr.text}   ${attr.value}  ${attr.toString()}");
              });
            });
          }

        });
      }

    } catch(e) {
      s.writeln("//${e.toString()}");
    }
  }

  Future<String> readAsset(AssetId assetId,BuildStep buildStep) async {
    try {
      return await buildStep.readAsString(assetId);
    } catch(e){
      return e.toString();
    }
  }
}