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

        dev_dependencies:
          build_runner: ^1.6.7





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

    #### Copied code from  https://github.com/OpenFlutter/flutter_screenutil - flutter_screenutil

    * should initialize this with SfwHelper.initialize(context)
    * adapting screen and font size. Let your UI display a reasonable layout on different screen sizes!
    * have some date conversion helpers
    * hide keyboard function


    Container(
      width: SfwHelper.setWidth(300),
      height: SfwHelper.setHeight(300),
      child: Text(
        "text",
        style: TextStyle(fontSize: SfwHelper.setSp(20)),
      ),
    );




## SfwAnim

    * for navigation using CupertinoPageRoute

    SfwAnim.navigate(context, "page name", Splash(),type: NavigationType.REMOVE_NAMED_UNTIL,arguments:[],useAsync: true);

    * set useAsync parameter true if you want to wait for result

    * Have fadeAnimation  and scaleAnimation  widget



## SfwUi

    * Have some ui related functions
    * hasPermission to check the permission
    * showToast for toast messages


## SfwHtmlParser   and   HtmlParser

    * Html to text parser  -> copied from a library


## SfwState

    * Replace extends State to SfwState
    * You can call setState with null parameter
    * You can use toastMessage function to show a message
    * isEmpty function will validate a string is empty or not and showing a message

## SfwNotifier

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

    * Same as SfwNotifier  but can only use one key for a listener
    * Use SfwNotifier for multiple keys or Add multiples keys with SfwNotifierForSingleKey.addListener  one by one

## SfwNotifierSingleKeyWidget

    * You can use this widget to update a single widget on data change without updating all widgets
    * This will use SfwNotifierForSingleKey.
    * Use SfwNotifierForSingleKey.notify(key,data); to notify this widget
    * Use builder function to build your widget


## SfwNotifierMultiKeyWidget

    * Same as SfwNotifierSingleKeyWidget
    * Can use multiple keys
    * Use SfwNotifier.notify(key,data); to notify this widget


## FadeAnimWidget , ScaleAnimWidget , RotateAnimWidget , DrawerAnimWidget , CollapseAnimWidget

    * Animated widgets







