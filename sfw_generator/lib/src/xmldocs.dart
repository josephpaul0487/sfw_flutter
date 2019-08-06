import 'package:build/build.dart';
import 'package:xml/xml.dart' as xml;
class XmlDocs {

  static const createColor="MaterialColor(primary, {  50: const Color.fromRGBO(red, green, blue, .1),100: const Color.fromRGBO(red, green, blue, .2),200: const Color.fromRGBO(red, green, blue, .3),300: const Color.fromRGBO(red, green, blue, .4),400: const Color.fromRGBO(red, green, blue, .5),500: const Color.fromRGBO(red, green, blue, .6),600: const Color.fromRGBO(red, green, blue, .7),700: const Color.fromRGBO(red, green, blue, .8),800: const Color.fromRGBO(red, green, blue, .9),900: const Color.fromRGBO(red, green, blue, 1),})";

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
              colorCode=colorCode.length==9?"Color(0x${colorCode.substring(1)})":"Color(0xFF${colorCode.substring(1)})";
            } else if(colorCode.startsWith("@")) {
              colorCode=colorCode.substring(colorCode.indexOf("/")+1);
            } else if(colorCode.split(",").length==3){
              var array=colorCode.split(",");
              s.writeln("const MaterialColor(${fromRGBO(array[0], array[1], array[2], 1).toRadixString(16)},{");
              int j=50;
              for(double i=.1;i<=1;j+=i==.1?50:100,i+=.1) {
                s.write("$j : ${fromRGBO(array[0], array[1], array[2], i).toRadixString(16)},");
              }
              s.writeln("});");

//              int value = ((((1 * 0xff ~/ 1) & 0xff) << 24) |
//              ((int.tryParse(array[0]) & 0xff) << 16) |
//              ((int.tryParse(array[1]) & 0xff) << 8)  |
//              ((int.tryParse(array[2]) & 0xff) << 0)) & 0xFFFFFFFF;
//              colorCode=createColor.replaceFirst("primary", value.toRadixString(16)).replaceAll("red", array[0]).replaceAll("green", array[1]).replaceAll("blue", array[2]);
            } else if(colorCode.length==6) {
              colorCode="Color(0xFF$colorCode)";
            } else if(colorCode.length==8) {
              colorCode="Color(0x$colorCode)";
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

  fromRGBO(String r, String g, String b, double opacity) => ((((opacity * 0xff ~/ 1) & 0xff) << 24) |
        ((int.tryParse(r )                   & 0xff) << 16) |
        ((int.tryParse(g )                   & 0xff) << 8)  |
        ((int.tryParse(b)                    & 0xff) << 0)) & 0xFFFFFFFF;

  Future<String> readAsset(AssetId assetId,BuildStep buildStep) async {
    try {
      return await buildStep.readAsString(assetId);
    } catch(e){
      return e.toString();
    }
  }
}