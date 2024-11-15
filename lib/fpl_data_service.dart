// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'player.dart';
// import 'database_helper.dart';

// class FPLDataService {
//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   Future<void> fetchAndStorePlayerData() async {
//     final response = await http.get(
//       Uri.parse('https://fantasy.premierleague.com/api/bootstrap-static/')
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<Player> players = [];

//       for (var playerData in data['elements']) {
//         players.add(Player(
//           id: playerData['id'],
//           name: playerData['web_name'],
//           team: playerData['team'],  // or use `team_name` if available
//           position: playerData['element_type'],  // position type (1 for GK, etc.)
//         ));
//       }

//       await _dbHelper.insertPlayers(players); // Insert into database
//     } else {
//       throw Exception('Failed to load player data');
//     }
//   }

//   Future<List<Player>> getPlayers() async {
//     return await _dbHelper.fetchAllPlayers();
//   }
// }
