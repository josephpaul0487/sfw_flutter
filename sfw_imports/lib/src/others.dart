class SfwStyleAnnotation {
  final List<String> stringFiles;
  final String constantsFile;
  final String colorFile;
  final String styleFile;

  const SfwStyleAnnotation({this.stringFiles=const ["values/strings.xml"], this.constantsFile="values/constants.xml", this.colorFile="values/colors.xml", this.styleFile="values/styles.xml"});
}