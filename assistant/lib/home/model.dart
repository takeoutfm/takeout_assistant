enum ResourceType {
  light,
}

abstract class Resource {
  final String id;
  final String name;
  final String? room;
  final List<String> zones;
  final ResourceType type;

  Resource(
      {required this.id,
      required this.name,
      required this.type,
      this.room,
      this.zones = const []});

  List<String> get qualifiedNames {
    return [
      if (room != null) '${room!.toLowerCase()} ${name.toLowerCase()}',
      ...zones.map((zone) => '${zone.toLowerCase()} ${name.toLowerCase()}'),
    ];
  }
}

class Light extends Resource {
  final bool on;

  Light(
      {required super.id,
      required super.name,
      required super.type,
      required this.on,
      super.room,
      super.zones});
}
