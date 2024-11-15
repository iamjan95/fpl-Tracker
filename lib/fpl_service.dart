import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FPLService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Future<Map<String, dynamic>?> fetchTeamData(String teamId, int gameweek) async {
    try {
      // Fetch team points
      final historyResponse = await http.get(
        Uri.parse('https://fantasy.premierleague.com/api/entry/$teamId/history/')
      );
      
      if (historyResponse.statusCode != 200) {
        throw Exception('Failed to load team history');
      }
      
      final historyData = json.decode(historyResponse.body);
      final points = historyData['current'].lastWhere((week) => week['event'] == gameweek)['points'];
      
      // Fetch team players
      final picksResponse = await http.get(
        Uri.parse('https://fantasy.premierleague.com/api/entry/$teamId/event/$gameweek/picks/')
      );

      if (picksResponse.statusCode != 200) {
        throw Exception('Failed to load team picks');
      }

      final picksData = json.decode(picksResponse.body);

      final picks = picksData['picks'];

      final List<Map<String, dynamic>> playerDetails = [];
      for (var pick in picks) {
        final playerId = pick['element'];
        final playerData = await fetchPlayerData(playerId, gameweek);
        
        if (playerData.isNotEmpty) {
          final pointsgw = playerData[1];
          final opponentTeam = await _dbHelper.getTeamName(int.parse(playerData[0])); // Ensure teamId is parsed
          final player = await _dbHelper.getPlayerName(playerId); // Resolve the future
        playerDetails.add({
          'playerId': playerId,
          'playerName': player[0],
          'teamName' : player[1],
          'multiplier': pick['multiplier'],
          'pointsgw':  pointsgw,
          'opponentTeam': opponentTeam
        });
      }
    }

      return {
        'points': points,
        'picks': playerDetails,
      };
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

}

Future<List<String>> fetchPlayerData(int playerId, int gameweek) async {
  try {
    // Define the URL with the player ID
    final url = Uri.parse('https://fantasy.premierleague.com/api/element-summary/$playerId/');

    // Send GET request to fetch player data
    final response = await http.get(url);

    // Check if the response is successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = json.decode(response.body);
      
      // Find the data for the given gameweek
      final gwdata = data['history'].lastWhere((week) => week['round'] == gameweek, orElse: () => null);

      if (gwdata != null) {
        final List<String> playerData = [];
        playerData.add(gwdata['opponent_team'].toString());
        playerData.add(gwdata['total_points'].toString());

        return playerData; 
      } else {
        return []; // Return empty list if data for the gameweek is not found
      }
    } else {
      throw Exception('Failed to fetch player data');
    }
  } catch (e) {
    print("Error fetching player data: $e");
    return [];
  }
}