// lib/data/map.dart
class GameMap {
  final String name;
  final String imagePath;

  GameMap({
    required this.name,
    required this.imagePath,
  });
}

// Define the global list of available maps
List<GameMap> globalMaps = [
  GameMap(name: 'Baskerville Manor', imagePath: 'assets/images/maps/baskerville_manor.png'),
  GameMap(name: 'Globe Theatre', imagePath: 'assets/images/maps/globe_theatre.png'),
  GameMap(name: 'Hanging Gardens', imagePath: 'assets/images/maps/hanging_gardens.png'),
  GameMap(name: 'Helicarrier', imagePath: 'assets/images/maps/helicarrier.png'),
  GameMap(name: 'Hell\'s Kitchen', imagePath: 'assets/images/maps/hells_kitchen.png'),
  GameMap(name: 'Marmoreal', imagePath: 'assets/images/maps/marmoreal.png'),
  GameMap(name: 'Navy Pier', imagePath: 'assets/images/maps/navy_pier.png'),
  GameMap(name: 'Sanctum Sanctorum', imagePath: 'assets/images/maps/sanctum_sanctorum.png'),
  GameMap(name: 'Sarpedon', imagePath: 'assets/images/maps/sarpedon.png'),
  GameMap(name: 'Soho', imagePath: 'assets/images/maps/soho.png'),
  GameMap(name: 'The Raft', imagePath: 'assets/images/maps/the_raft.png'),
];