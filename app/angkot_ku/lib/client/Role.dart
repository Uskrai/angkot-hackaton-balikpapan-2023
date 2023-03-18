enum RoleType {
  customer,
  sharedTaxi,
  bus,
}

class Role {
  const Role({required this.id, required this.name});

  final RoleType name;
  final int id;
}