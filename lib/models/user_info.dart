enum UserType { Admin, ServiceProvider, Customer, NotAUser }

class UserInfo {
  final String userId;
  final String email;
  String contact;
  String userName;
  String location;
  String imageUrl;
  UserType userType;

  UserInfo({
    this.email,
    this.location,
    this.userId,
    this.userName,
    this.contact,
    this.userType,
    this.imageUrl,
  });
}
