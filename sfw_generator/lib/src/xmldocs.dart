import 'package:build/build.dart';
import 'package:xml/xml.dart' as xml;

class XmlDocs {

  static build(StringBuffer s, BuildStep buildStep) async {
    try {
      await _readColor(s, buildStep);
      await _readDimens(s, buildStep);
      await _readStrings(s, buildStep);
    } catch (e) {}
  }

  static _readStrings(StringBuffer s, BuildStep buildStep) async {
    try {
      String appStrings = await readAsset(
          AssetId(buildStep.inputId.package, "lib/values/strings.xml"),
          buildStep);
      if (appStrings.isNotEmpty) {
        s.writeln('///STRINGS');
        s.writeln('class SfwStrings {');
        xml.XmlDocument document = xml.parse(appStrings);
        StringBuffer switchStrings=StringBuffer();
        int i=1;
        document.children.forEach((child) {
          child.children.forEach((node) {
            String string = node.text;
            if(string.isEmpty)
              return;
            if (string.startsWith("@")) {
              string = "get(${string.substring(string.indexOf("/") + 1)})";
            } else {
              string="const '$string'";
            }
            String key;
            node.attributes.forEach((attr) {
              if(attr.name.local=="name")
                key=attr.value;

            });
            if(key==null || key.isEmpty)
              return;
            s.writeln("static const int $key = $i;");
            switchStrings.writeln("case $key :return $string;");

          });
        });
        s.writeln("static String get(int code,{String locale}) {");
        s.writeln("switch(code) {");
        s.writeln(switchStrings);
        s.writeln("default:return '';");
        s.writeln("}");//SWITCH
        s.writeln("}");//GET
        s.writeln("}");//CLASS
      }

    } catch(e) {
      s.writeln("/*${e.toString()}*/");
      s.writeln("}");
    }
  }

  static _readColor(StringBuffer s, BuildStep buildStep) async {
    try {
      String appColors = await readAsset(
          AssetId(buildStep.inputId.package, "lib/values/colors.xml"),
          buildStep);
      if (appColors.isNotEmpty) {
        s.writeln('///COLORS');
        s.writeln('class SfwColors {');
        xml.XmlDocument document = xml.parse(appColors);
        document.children.forEach((child) {
          child.children.forEach((node) {
            String colorCode = node.text;
            if (colorCode.startsWith("#")) {
              colorCode = colorCode.length == 9
                  ? "Color(0x${colorCode.substring(1)})"
                  : "Color(0xFF${colorCode.substring(1)})";
            } else if (colorCode.startsWith("@")) {
              colorCode = colorCode.substring(colorCode.indexOf("/") + 1);
            } else if (colorCode.split(",").length == 3) {
              var array = colorCode.split(",");
              colorCode =
                  "const MaterialColor(0x${fromRGBO(array[0], array[1], array[2], 1).toRadixString(16)},{";
              int j = 50;
              for (double i = .1; i <= 1; j += i == .1 ? 50 : 100, i += .1) {
                colorCode +=
                    "$j : const Color(0x${fromRGBO(array[0], array[1], array[2], i).toRadixString(16)}),";
              }
              colorCode += "})";
            } else if (colorCode.length == 6) {
              colorCode = "Color(0xFF$colorCode)";
            } else if (colorCode.length == 8) {
              colorCode = "Color(0x$colorCode)";
            } else {
              return;
            }
            node.attributes.forEach((attr) {
              if(attr.name.local=="name")
                s.writeln("static const Color ${attr.value} = $colorCode;");
            });
          });
        });
        s.writeln("}");
      }

    } catch(e) {
      s.writeln("/*${e.toString()}*/");
      s.writeln("}");
    }
  }

  static _readDimens(StringBuffer s, BuildStep buildStep) async {
    try {
      String appDimens = await readAsset(
          AssetId(buildStep.inputId.package, "lib/values/constants.xml"),
          buildStep);
      if (appDimens.isNotEmpty) {
        s.writeln('///CONSTANTS   --  String , bool , int , double');
        s.writeln('class SfwConstants {');
        xml.XmlDocument document = xml.parse(appDimens);
        document.children.forEach((child) {
          child.children.forEach((node) {
            String dimenCode = node.text;
            if(dimenCode.isEmpty)
              return;
            if (dimenCode.startsWith("@")) {
              dimenCode = dimenCode.substring(dimenCode.indexOf("/") + 1);
            }
            String key,type;
            node.attributes.forEach((attr) {
              if(attr.name.local=="type")
                type=attr.value;
              else if(attr.name.local=="name")
                key=attr.value;

            });
            if(key==null || key.isEmpty)
              return;
            s.writeln("static const ${type==null?'double':type} $key = $dimenCode;");

          });
        });
      }

    } catch(e) {
      s.writeln("/*${e.toString()}*/");
      s.writeln("}");
    }
  }

  static fromRGBO(String r, String g, String b, double opacity) =>
      ((((opacity * 0xff ~/ 1) & 0xff) << 24) |
          ((int.tryParse(r) & 0xff) << 16) |
          ((int.tryParse(g) & 0xff) << 8) |
          ((int.tryParse(b) & 0xff) << 0)) &
      0xFFFFFFFF;

  static Future<String> readAsset(AssetId assetId, BuildStep buildStep) async {
    try {
      return await buildStep.readAsString(assetId);
    } catch (e) {
      return "";
    }
  }
}
