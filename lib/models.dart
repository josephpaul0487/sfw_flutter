
import 'package:sfw_imports/sfw_imports.dart' show SfwEntity,HelperMethods,SfwDbField;

@SfwEntity(["tbl_user"])
class UserModel with HelperMethods {
  int id;
  String email;
  String firstName;
  String lastName;
  String countryCode;
  String mobile;
  String token;
  String image;
  @SfwDbField("created_at")
  String createdAt;
  @SfwDbField("updated_at")
  String updatedAt;

  bool keepSignedIn;

  UserModel(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.countryCode,
        this.mobile,
        this.token,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.keepSignedIn});

  getEmail() => avoidNull(email);

  getName() => "${avoidNull(firstName)} ${avoidNull(lastName)}";

  getImage() => avoidNull(image);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;



}