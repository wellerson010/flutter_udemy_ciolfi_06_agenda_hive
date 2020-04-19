import 'package:hive/hive.dart';

part 'contact_helper.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String img;

  Contact();

  Contact.normal(this.id, this.name, this.email, this.phone, this.img);
}