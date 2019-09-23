# sfw_flutter
Simple database generator (private use only)

## Codes to generate files

### Step 1:  flutter packages pub run build_runner clean
### Step 2:  flutter packages pub run build_runner build      OR
###          flutter packages pub run build_runner build --delete-conflicting-outputs

## IMPORT
*  Import following libraries

        dependencies:
          sfw_generator:
            git:
              url: git://github.com/josephpaul0487/sfw_flutter.git
              path: sfw_generator
          flutter:
            sdk: flutter


          sqflite: ^1.1.6+4
          permission_handler: ^3.2.2
          fluttertoast: ^3.1.2
          dio: ^2.1.16
          intl: ^0.16.0
          analyzer: '0.38.2'  //0.38.3 have some build error. So use 0.38.2

        dev_dependencies:
          build_runner: ^1.6.7


## Files

    * Create a new directory under lib folder named "sfw" => without quotes
    * Create following dart files under sfw folder
      1. animations.dart
      2. sfw.dart
      3. strings.dart
      4. styles.dart
      5. ui.dart
      6. ui_helper.dart

    ** See bottom of this ReadMe file to see how to configure the above files.



## Database Config
     
    * Annotate a class using @SfwDbConfig("dbname",6,version:8)

    name, totalDartFileCount, version

    The newly created filename will be thisClassName.sfw.dart


    * should create following functions in this class
    * You can use database object in these functions
    static onOpen(db) {}
    static onCreate(db, version){}
    static onUpgrade(db, version, newVersion){}
    static onDowngrade(db, version, newVersion){}

    * You can use SfwDbQuery to generate query functions

    import 'package:sfw_imports/sfw_imports.dart' show SfwDbConfig,SfwDbQuery;
    @SfwDbConfig("quizup",6,version:3)
    abstract class DB {
        static onOpen(db) {}
        static onCreate(db, version){}
        static onUpgrade(db, version, newVersion){}
        static onDowngrade(db, version, newVersion){}

        @SfwDbQuery(UserModel,false,'tbl_user',limit: 1,orderBy: "updated_at")
         getUser();

    }

## Database model classes

    #### Create model classes and annotate it with SfwEntity

    * The model class should annotate with @SfwEntity
    * Don't use getter or setter for Entity class fields
    * The constructor should be a named constructor
    * Contructor should have all fields as parameter
    * Should annotate a int field with SfwDbPrimary  -  SfwDbPrimary(true) to set auto increment in primary field
    * You can set database column name with  @SfwDbField("name")
        * You can pass null or "" to set field name as database column name
        * Field name will use as column name if you are not annotate the field with SfwDbField
    * Use @SfwDbExclude() to exclude a field from the database table
        * You can specify which tables should exclude - @SfwDbExclude(tables: ["memebrs"])

    * You can use multiple tables in a model class -  See example
    * Inheritance not supported
    * List type and Custom classes should annoate with @SfwDbField and should provide genericType: and isAnEntity: parameters
        * genericType : List's generic type or custom class type


    #### Not supporting foreign keys and other complicated features



    @SfwEntity(["tbl_user","members"])
    class UserModel {
      @SfwDbPrimary(false)
      int id;
      @SfwDbField(null)
      String email;
      @SfwDbField("")
      String name;
      @SfwDbExclude()
      String role;
      @SfwDbExclude()
      String countryCode;
      String mobile;
      String token;
      String image;
      @SfwDbField("created_at")
      String createdAt;
      @SfwDbField("updated_at")
      String updatedAt;
      @SfwDbField("pages",genericType: PageModel,isAnEntity: true)
      List<PageModel> pages;

      bool keepSignedIn;

      @SfwDbField("workAddress",genericType: String,isAnEntity:false)
      List<String> address;

      UserModel(
          {this.id,
            this.email,
            this.name,
            this.role,
            this.countryCode,
            this.mobile,
            this.token,
            this.image,
            this.createdAt,
            this.updatedAt,
            this.keepSignedIn,
          this.pages,this.address})

    }


## SfwHelper

    * generated file name  =>  your package lib folder/sfw/sfw.sfw.dart

    #### Screenutil code is using   https://github.com/OpenFlutter/flutter_screenutil - flutter_screenutil  library

    * should initialize this with SfwHelper.initialize(context)
    * adapting screen and font size. Let your UI display a reasonable layout on different screen sizes!
    * have some date conversion helpers
    * hide keyboard function

    * Have some ui related functions
    * hasPermission to check the permission
    * showToast for toast messages


    Container(
      width: SfwHelper.setWidth(300),
      height: SfwHelper.setHeight(300),
      child: Text(
        "text",
        style: TextStyle(fontSize: SfwHelper.setSp(20)),
      ),
    );




## SfwAnim

    * generated file name  =>  your package lib folder/sfw/animations.sfw.dart

    * for navigation using CupertinoPageRoute

    SfwAnim.navigate(context, "page name", Splash(),type: NavigationType.REMOVE_NAMED_UNTIL,arguments:[],useAsync: true);

    * set useAsync parameter true if you want to wait for result

    * Have fadeAnimation  and scaleAnimation  widget



## SfwHtmlParser   and   HtmlParser
    * generated file name  =>  your package lib folder/sfw/ui_helper.sfw.dart

    * Html to text parser  -> copied from a library


## SfwState
    * generated file name  =>  your package lib folder/sfw/sfw.sfw.dart

    * Replace extends State to SfwState
    * You can call setState with null parameter
    * You can use toastMessage function to show a message
    * isEmpty function will validate a string is empty or not and showing a message

## SfwNotifier
    * generated file name  =>  your package lib folder/sfw/sfw.sfw.dart

    * A notifier like java interface
    * You can use this in a class
    * You can use a set of keys
    * Class should implement SfwNotifierListener
    * override   void onSfwNotifierCalled(String key, dynamic data)
    * SfwNotifier.addListener(this,{keys})  to add a listener
    * SfwNotifier.removeListener(this) to remove a listener  ->  should call on dispose or equalant method

    ##### To notify all listener

    * SfwNotifier.notify(key,data); //This will trigger all listeners's (registered with this key) onSfwNotifierCalled function

## SfwNotifierForSingleKey
    * generated file name  =>  your package lib folder/sfw/sfw.sfw.dart

    * Same as SfwNotifier  but can only use one key for a listener
    * Use SfwNotifier for multiple keys or Add multiples keys with SfwNotifierForSingleKey.addListener  one by one

## SfwNotifierSingleKeyWidget
    * generated file name  =>  your package lib folder/sfw/sfw.sfw.dart

    * You can use this widget to update a single widget on data change without updating all widgets
    * This will use SfwNotifierForSingleKey.
    * Use SfwNotifierForSingleKey.notify(key,data); to notify this widget
    * Use builder function to build your widget


## SfwNotifierMultiKeyWidget
    * generated file name  =>  your package lib folder/sfw/sfw.sfw.dart

    * Same as SfwNotifierSingleKeyWidget
    * Can use multiple keys
    * Use SfwNotifier.notify(key,data); to notify this widget


## FadeAnimWidget , ScaleAnimWidget , RotateAnimWidget , DrawerAnimWidget , CollapseAnimWidget
    * generated file name  =>  your package lib folder/sfw/animations.sfw.dart

    * Animated widgets



## Generate files under sfw directory

  #### animations.dart

        * You can leave it as blank
        * A new file named "animations.sfw.dart" will create after calling build_runner
        * This file includes the following classes

            1. SfwAnim  -> includes navigator help and two  animations - fadeAnimation and scaleAnimation
            2. FadeAnimWidget
            3. ScaleAnimWidget
            4. RotateAnimWidget
            5. DrawerAnimWidget
            6. CollapseAnimWidget

  ####  sfw.dart
        * You can leave it as blank
        * A new file named "sfw.sfw.dart" will create after calling build_runner
        * This file includes the following classes

            #### SfwNotifier
            2. SfwNotifierForSingleKey
            3. SfwNotifierSingleKeyWidget
            4. SfwNotifierMultiKeyWidget
            5. SfwHelper
            6. SfwState




  ####   strings.dart

        * Create a class and annotate it with SfwStyleAnnotation

        @SfwStyleAnnotation(stringFiles: ["sfw/strings.xml","strings_en.xml","src/strings_de.xml"])
        class Strings {

        }

        * If you are not providing stringFiles parameter "sfw/strings.xml" will treated as  default string file
        * You can provide multiple string files
        * The locale name should be in the provided file name. ie.. for "strings_en.xml" "en"  will be trated as locale.
        * If the file name is "strings.xml",then the locale will be "us""

        eg. strings.xml

        <?xml version="1.0" encoding="utf-8" ?>
        <resources>
            <string name="PASSWORD">Password</string>
            <string name="ERR_PASSWORD">Password must contain 1 lowercase , 1 uppercase , 1 number , one of [@#&amp;%] and 6-32 characters</string>
            <string name="WEB_DATE_FORMAT" type="static">dd-MM-yyyy HH:mm:ss</string>
        </resources>

        The generated file will be

        ///STRINGS
        class SfwStrings {
          static const String WEB_DATE_FORMAT = 'dd-MM-yyyy HH:mm:ss';

          static const int PASSWORD = 1;
          static const int ERR_PASSWORD = 2;

          static get(int code, {String locale = 'us'}) {
            switch ('$locale') {
              case 'us':
                return getUs(code);
              case 'en':
                return getEn(code);
              case 'de':
                return getDe(code);
              default:
                return '';
            }
          }

          static String getUs(int code) {
            switch (code) {
              case PASSWORD:
                return 'Password';
              case ERR_PASSWORD:
                return 'Password must contain 1 lowercase , 1 uppercase , 1 number , one of [@#&%] and 6-32 characters';
              default:
                return '';
            }
          }
          static String getDe(int code) {
              switch (code) {
                case PASSWORD:
                  return 'Password';
                case ERR_PASSWORD:
                  return 'Password must contain 1 lowercase , 1 uppercase , 1 number , one of [@#&%] and 6-32 characters';
                default:
                  return '';
              }
            }
            static String getEn(int code) {
                switch (code) {
                  case PASSWORD:
                    return 'Password';
                  case ERR_PASSWORD:
                    return 'Password must contain 1 lowercase , 1 uppercase , 1 number , one of [@#&%] and 6-32 characters';
                  default:
                    return '';
                }
              }
        }

        You can get the String in code via SfwStrings.get(SfwStrings.PASSWORD,locale:"en");



  #### styles.dart

        * You can leave it as blank.
        * You should create new files under "sfw" folder named "colors.xml" and "constants.xml"

        //Colors.xml
        <?xml version="1.0" encoding="UTF-8" ?>
        <resources>


            <color name="txtCommon">#000</color>
            <color name="txtBoldCommon">@color/txtCommon</color>
            <color name="txtSemiBoldCommon">@color/txtCommon</color>
            <color name="txtLightCommon">@color/txtCommon</color>
            <color name="txtMediumCommon">@color/txtCommon</color>
            <color name="txtSmallCommon">@color/txtCommon</color>

            <color name="btnCommonBack">#36E4CF</color>
            <color name="btnCommonSplashBack">#fff</color>
            <color name="btnTxtCommon">#fff</color>

            <color name="edtIconNormal">#000</color>
            <color name="edtIconFocused">@color/primaryColor</color>
            <color name="edtIconDisabled">#D8D8D8</color>
            <color name="edtIconPrefixNormal">@color/edtIconNormal</color>
            <color name="edtIconPrefixFocused">@color/edtIconFocused</color>
            <color name="edtIconPrefixDisabled">@color/edtIconDisabled</color>
            <color name="edtIconSuffixFocused">@color/edtIconFocused</color>
            <color name="edtIconSuffixNormal">@color/edtIconNormal</color>
            <color name="edtIconSuffixDisabled">@color/edtIconDisabled</color>



            <color name="edtBorderNormal">#D8D8D8</color>
            <color name="edtBorderFocused">@color/primaryColor</color>
            <color name="edtBorderFocusedError">@color/primaryColor</color>
            <color name="edtBorderError">#FE1515</color>
            <color name="edtBorderDisabled">#D8D8D8</color>
            <color name="edtBorderEnabled">#D8D8D8</color>

            <color name="edtHint">#D8D8D8</color>
            <color name="edtLabel">#D8D8D8</color>
            <color name="edtCounter">#000</color>
            <color name="edtError">@color/edtBorderError</color>
            <color name="edtPrefix">#000</color>
            <color name="edtSuffix">#000</color>
            <color name="edtHelper">#FE9E15</color>

            <color name="cbTintChecked">@color/primaryColor</color>
            <color name="cbTintNormal">@color/accentColor</color>


            <color name="cardBackCommon">#fff</color>
            <color name="primarySwatch">255,255,255</color>
            <color name="primaryColor">#0084FF</color>
            <color name="accentColor">#36E4CF</color>
            <color name="progressWidgetColor">#36E4CF</color>

            <!-- The following colors are optional : These colors used to set the app theme. -->

            <color name="primaryColorLight">#0084FF</color>
            <color name="primaryColorDark">#0084FF</color>
            <color name="canvasColor">#fff</color>

            <color name="scaffoldBackgroundColor">#fff</color>
            <color name="bottomAppBarColor">#fff</color>
            <color name="dividerColor">#D8D8D8</color>
            <color name="cardColor">#fff</color>
            <color name="focusColor">@color/primaryColor</color>
            <color name="hoverColor">#fff</color>
            <color name="highlightColor">#fff</color>
            <color name="splashColor">@color/primaryColor</color>
            <color name="selectedRowColor">#fff</color>
            <color name="unselectedWidgetColor">#fff</color>
            <color name="disabledColor">#fff</color>
            <color name="buttonColor">@color/accentColor</color>
            <color name="secondaryHeaderColor">#fff</color>
            <color name="textSelectionColor">#fff</color>
            <color name="cursorColor">#000</color>
            <color name="textSelectionHandleColor">#fff</color>
            <color name="backgroundColor">#fff</color>
            <color name="dialogBackgroundColor">#fff</color>
            <color name="indicatorColor">#fff</color>
            <color name="hintColor">#D8D8D8</color>
            <color name="errorColor">#FE1515</color>
            <color name="toggleableActiveColor">#fff</color>


        </resources>

        //Constants.xml
        <?xml version="1.0" encoding="UTF-8" ?>
        <resources>
            <double name="tsTxtCommon" type="double">40.0</double>
            <double name="tsTxtBoldCommon" type="double">@constant/tsTxtCommon</double>
            <double name="tsTxtSemiCommon" type="double">@constant/tsTxtCommon</double>
            <double name="tsTxtLightCommon" type="double">@constant/tsTxtCommon</double>
            <double name="tsTxtMediumCommon" type="double">@constant/tsTxtCommon</double>
            <double name="tsTxtSmallCommon" type="double">@constant/tsTxtCommon</double>
            <double name="tsBtnTxtCommon" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtCommon" type="double">@constant/tsTxtCommon</double>

            <double name="tsEdtHint" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtCounter" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtLabel" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtError" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtPrefix" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtSuffix" type="double">@constant/tsTxtCommon</double>
            <double name="tsEdtHelper" type="double">@constant/tsTxtCommon</double>


            <double name="hEdtCommon" type="double">70.0</double>
            <double name="hBtnCommon" type="double">60.0</double>
            <double name="btnPadLeft" type="double">20.0</double>
            <double name="btnPadRight" type="double">20.0</double>
            <double name="btnElevation" type="double">3.0</double>

            <double name="commonTopMargin" type="double">15.0</double>
            <double name="edtIconPaddingLeft" type="double">10.0</double>
            <double name="edtIconPaddingRight" type="double">10.0</double>
            <double name="edtIconSize" type="double">40.0</double>
            <double name="edtLeftPadding" type="double">10.0</double>
            <double name="edtRightPadding" type="double">10.0</double>
            <double name="edtBottomPadding" type="double">10.0</double>
            <double name="edtBottomPaddingWhenUsingOutline" type="double">10.0</double>

            <double name="edtCursorWidth" type="double">2.0</double>

            <double name="cbIconSize" type="double">32.0</double>
            <double name="cbTextLeftMargin" type="double">20.0</double>

            <int name="edtMultiMaxLines"  type="int">8</int>
            <int name="edtMultiMinLines" type="int">1</int>

            <int name="edtMaxLength" type="int">255</int>
            <int name="edtMultiMaxLength" type="int">800</int>

            <int name="edtPasswordMinLength" type="int">6</int>
            <int name="edtPasswordMaxLength" type="int">32</int>



            <bool name="edtTextDirectionLtr" type="bool">true</bool>
            <bool name="edtAutoCorrect" type="bool">true</bool>
            <bool name="edtAutoFocus" type="bool">false</bool>
            <bool name="edtShowCursor" type="bool">true</bool>
            <bool name="edtAutoValidate" type="bool">false</bool>
            <bool name="edtExpands" type="bool">false</bool>
            <bool name="edtMaxLengthEnforced" type="bool">true</bool>
            <bool name="edtEnableInteractiveSelection" type="bool">true</bool>
            <bool name="edtIsBrightnessDark" type="bool">false</bool>

            <!-- start , end , center , justify , left , right -->
            <string name="edtTextAlign" type="String">start</string>


            <!-- The following constants are optional : These colors used to set the app theme. -->
            <bool name="isDarkTheme" type="bool">false</bool>
            <bool name="isPrimaryColorBrightnessIsDark" type="bool">false</bool>
            <bool name="isAccentColorBrightnessIsDark" type="bool">false</bool>

        </resources>














