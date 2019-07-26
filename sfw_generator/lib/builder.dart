import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/generator.dart';
//import 'src/db_generator.dart';


Builder db(BuilderOptions options) =>
    LibraryBuilder (DbGenerator(),generatedExtension:'.sfw.dart');