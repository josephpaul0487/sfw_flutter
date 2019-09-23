class SfwStyleAnnotation {
  final List<String> stringFiles;
  final String constantsFile;
  final String colorFile;
  final String styleFile;
  final String inputFocusIconColor;
  final String inputIconColor;
  final String inputFocusPrefixIconColor;
  final String inputPrefixIconColor;
  final String inputSuffixFocusIconColor;
  final String inputSuffixIconColor;
  final double inputIconSize;
  final double inputPrefixIconSize;
  final double inputSuffixIconSize;

  const SfwStyleAnnotation(  {this.inputIconSize, this.inputPrefixIconSize, this.inputSuffixIconSize,this.inputFocusIconColor, this.inputIconColor, this.inputFocusPrefixIconColor, this.inputPrefixIconColor, this.inputSuffixFocusIconColor, this.inputSuffixIconColor,this.stringFiles=const ["sfw/strings.xml"], this.constantsFile="sfw/constants.xml", this.colorFile="sfw/colors.xml", this.styleFile="sfw/styles.xml"});
}