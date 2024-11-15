import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
  // Initialize database factory for non-mobile platforms if using `sqflite_common_ffi`
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Path to the existing database
  final path = join('data/fantasy_data.db');

  
  print('Database path: $path');
  
  // Open the database without any schema creation logic
  return await openDatabase(
    path,
    version: 1,
  );
}


  Future<List> getPlayerName(int playerId) async {
    final db = await database; // Obtain the database instance

    final List <String> playerDetails = [];
    // Query the database for the player's name
    final List<Map<String, dynamic>> result = await db.query(
      'Elements', // Table name
      columns: ['first_name', 'second_name','team'], // The column(s) to retrieve
      where: 'id = ?', // SQL WHERE clause to filter by ID
      whereArgs: [playerId], // Arguments for the WHERE clause
    );
     
    // Check if the result is empty and return the player's name or a fallback
    if (result.isNotEmpty) 
    {
      playerDetails.add(result.first['first_name'] + " " + result.first['second_name']);
      final teamName = await getTeamName(result.first['team']);
      playerDetails.add(teamName);
    }
     return playerDetails;
  }

  Future<String> getTeamName(int teamid) async {
    final db = await database; // Obtain the database instance

    
    // Query the database for the team's name
    final List<Map<String, dynamic>> result = await db.query(
      'Teams', // Table name
      columns: ['name'], // The column(s) to retrieve
      where: 'id = ?', // SQL WHERE clause to filter by ID
      whereArgs: [teamid], // Arguments for the WHERE clause
    );

    // Check if the result is empty and return the player's name or a fallback
    if (result.isNotEmpty) {
      return result.first['name']  as String;
    } else {
      return 'Unknown Team'; // Return a default name if no match is found
    }
  }
}
