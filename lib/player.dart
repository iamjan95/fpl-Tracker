class Player {
  final int id;
  final String name;
  final String team;
  final String position;

  Player({required this.id, required this.name, required this.team, required this.position});

  // Convert Player object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'team': team,
      'position': position,
    };
  }

  // Convert Map from database to Player object
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      team: map['team'],
      position: map['position'],
    );
  }
}
