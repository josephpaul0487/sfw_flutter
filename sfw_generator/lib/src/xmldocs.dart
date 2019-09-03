import 'package:build/build.dart';
import 'package:sfw_imports/sfw_imports.dart' show SfwStyleAnnotation;
import 'package:source_gen/source_gen.dart';
import 'package:xml/xml.dart' as xml;
import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/src/output_helpers.dart';

class XmlDocs {

  static Future<bool> isStringAsset(LibraryReader library,BuildStep buildStep) async {
    if(library.element.source.shortName=="strings.dart") {
      ConstantReader styleAnnotation;
      for (var annotatedElement
      in library.annotatedWith(TypeChecker.fromRuntime(SfwStyleAnnotation))) {
        styleAnnotation=annotatedElement.annotation;
        break;
      }
      if(styleAnnotation!=null) {
        List<DartObject> stringFiles=styleAnnotation.read("stringFiles").listValue;
        if(stringFiles!=null && stringFiles.length>0) {
          StringBuffer strings=StringBuffer();
          strings.writeln("///STRINGS");
          strings.writeln('class SfwStrings {');
          List<String> keys=[];
          StringBuffer generatedKeys=StringBuffer();
          StringBuffer generatedStaticStrings=StringBuffer();
          StringBuffer code=StringBuffer();
          List<String> classNames=[];
          for(int i=1,j=0;j<stringFiles.length;++j) {
            i=await _readStrings(stringFiles[j].toStringValue(), keys, generatedKeys,generatedStaticStrings, i, classNames, code, buildStep);
          }
          strings.writeln(generatedStaticStrings);
          strings.writeln(generatedKeys);
          strings.writeln("static get(int code,{String locale='us'}) {");
          strings.writeln("switch('\$locale') {") ;
          classNames.forEach((n){
            strings.writeln("case '$n':return get${n.toLowerCase().replaceRange(0, 1, n.substring(0,1).toUpperCase())}(code);");
          });
          strings.writeln("default:return '';");
          strings.writeln("}");//SWITCH
          strings.writeln("}");//GET
          strings.writeln(code);

          strings.writeln("}");//CLASS
          buildStep.writeAsString(AssetId(buildStep.inputId.package,
              buildStep.inputId.path.replaceFirst(".dart", ".sfw.dart")),
             await normalize(strings.toString()));
          return true;
        }

      }
    }
    return false;
  }

  static Future<bool> isStyleAsset(LibraryReader library,BuildStep buildStep) async {
    if(library.element.source.shortName=="styles.dart") {
      StringBuffer styles=StringBuffer();
      await XmlDocs.build(styles, buildStep);
      if(styles.length>0) {
        StringBuffer imports=StringBuffer();
        imports.writeln("import 'package:flutter/material.dart' show Color,MaterialColor,Colors;");
        buildStep.writeAsString(AssetId(buildStep.inputId.package,
            buildStep.inputId.path.replaceFirst(".dart", ".sfw.dart")),
            await normalize(imports.toString()+styles.toString()));
      }
      return true;
    }
    return false;
  }

  static build(StringBuffer s, BuildStep buildStep) async {
    try {
      await _readColor(s, buildStep);
      await _readDimens(s, buildStep);
    } catch (e) {}
  }

  static Future<int> _readStrings(String fileName,List<String> keys,StringBuffer  generatedKeys,StringBuffer generatedStaticStrings,int lastKeyValue,List<String> classNames,StringBuffer code,BuildStep buildStep) async {
    try {
      String className="";
      String appStrings = await readAsset(
          AssetId(buildStep.inputId.package, "lib/$fileName"),
          buildStep);
      if (appStrings.isNotEmpty) {
        xml.XmlDocument document = xml.parse(appStrings);
        if(fileName.endsWith("strings.xml")) {
          className="us";
        } else {
          className = fileName.substring(fileName.lastIndexOf("_") + 1);
          className = className.substring(0, className.indexOf("."));
        }

        String classToUpper=className.toLowerCase().replaceRange(0, 1, className.substring(0,1).toUpperCase());
        code.writeln("static String get$classToUpper(int code) {");
        code.writeln("switch(code) {");

        List<String> keysLocal=[];
        document.children.forEach((child) {
          child.children.forEach((node) {
            String string = node.text;
            if(string.isEmpty)
              return;
            if (string.startsWith("@string/")) {
              string = "get$classToUpper(${string.substring(string.indexOf("/") + 1)})";
            } else {
              string=" '$string'";
            }
            String key;
            bool isStatic=false;
            node.attributes.forEach((attr) {
              if(attr.name.local=="name")
                key=attr.value;
              else {
                isStatic=attr.name.local=="type" && attr.value=="static";
              }

            });
            if(key==null || key.isEmpty )
              return;
            if(isStatic) {
              generatedStaticStrings.writeln("static const String $key=$string;");
              return;
            }
            if(!keys.contains(key)) {
              keys.add(key);
              generatedKeys.writeln("static const int $key = $lastKeyValue;");
              ++lastKeyValue;
            }
            if(!keysLocal.contains(key)) {
              keysLocal.add(key);
              code.writeln("case $key :return $string;");
            }

          });

        });

        code.writeln("default:return '';");
        code.writeln("}");//SWITCH
        code.writeln("}");//GET
        classNames.add(className);
      }
      return lastKeyValue;

    } catch(e) {
    }
    return lastKeyValue;
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
            String colorCode = _parseColor(node.text);
            if(colorCode==null)
              return;

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
        }
        );
        s.writeln("}");
      }

    } catch(e) {
      s.writeln("/*${e.toString()}*/");
      s.writeln("}");
    }
  }

  static String _parseColor(String colorCode) {
    if (colorCode.startsWith("#")) {
      return colorCode.length == 9
          ? "Color(0x${colorCode.substring(1)})"
          : "Color(0xFF${colorCode.substring(1)})";
    } else if (colorCode.startsWith("@")) {
      if(colorCode.startsWith("@flutter:color"))
        return   'Colors.${colorCode.substring(colorCode.indexOf("/") + 1)}';

      return  colorCode.substring(colorCode.indexOf("/") + 1);
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
      return colorCode;
    } else if (colorCode.length == 6) {
      return  "Color(0xFF$colorCode)";
    } else if (colorCode.length == 8) {
      return  "Color(0x$colorCode)";
    }
      return null;
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
      return "/*${e.toString()}*/";
    }
  }

  static Future<String> normalize(String str) async {
    final values = Set<String>();
    await for (var value in normalizeGeneratorOutput(str)) {
      assert(value == null || (value.length == value.trim().length));
      values.add(value);
    }
    return values.join('\n\n');
  }
}
