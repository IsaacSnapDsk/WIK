class Player {
  const Player({
    required this.id,
    // required this.name,
    // required this.socketID,
    required this.wins,
    required this.drinks,
    required this.shots,
    required this.bb,
    // this.vote,
  });

  final String id;
  // final String name;
  // final String socketID;
  final int wins;
  final int drinks;
  final int shots;
  final int bb;
}
