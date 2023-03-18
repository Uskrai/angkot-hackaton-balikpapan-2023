import 'Role.dart';

class Authenticated {
  Authenticated({required this.session, required this.roles});

  String session;
  List<Role> roles;
}