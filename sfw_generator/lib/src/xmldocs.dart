import 'package:build/build.dart';
import 'package:xml/xml.dart' as xml;
class XmlDocs {

  static const createColor="MaterialColor(const Color.fromRGBO(red, green, blue, 1.0).value, {  50: const Color.fromRGBO(red, green, blue, .1),100: const Color.fromRGBO(red, green, blue, .2),200: const Color.fromRGBO(red, green, blue, .3),300: const Color.fromRGBO(red, green, blue, .4),400: const Color.fromRGBO(red, green, blue, .5),500: const Color.fromRGBO(red, green, blue, .6),600: const Color.fromRGBO(red, green, blue, .7),700: const Color.fromRGBO(red, green, blue, .8),800: const Color.fromRGBO(red, green, blue, .9),900: const Color.fromRGBO(red, green, blue, 1),})";

  build(StringBuffer s,BuildStep buildStep) async {
    try {
       await readColor(s,buildStep);

    } catch(e) {}
  }

  readColor(StringBuffer s,BuildStep buildStep) async {
    try {
      String appColors=await readAsset(AssetId(buildStep.inputId.package, "lib/values/color.xml"), buildStep);
      if(appColors.isNotEmpty) {
        xml.XmlDocument document=xml.parse(appColors);
        document.children.forEach((child){
          child.children.forEach((node){
            String colorCode=node.text;
            if(colorCode.startsWith("#")) {
              colorCode="Color(0xFF${colorCode.substring(1)})";
            } else if(colorCode.startsWith("@")) {
              colorCode=colorCode.substring(colorCode.indexOf("/")+1);
            } else if(colorCode.split(",").length==3){
              var array=colorCode.split(",");
              colorCode=createColor.replaceAll("red", array[0]).replaceAll("green", array[1]).replaceAll("blue", array[2]);
            } else {
              return;
            }
//            if(node.children.length>0) {
//              node.children.forEach((color){
                node.attributes.forEach((attr){
                  s.writeln("static const Color ${attr.value} = $colorCode;");
                });
//              });
//            }

          });
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