import 'package:flutter/material.dart';
import 'fpl_service.dart';

class FPLTeamApp extends StatefulWidget {
  @override
  _FPLTeamAppState createState() => _FPLTeamAppState();
}

class _FPLTeamAppState extends State<FPLTeamApp> {
  final _teamIdController = TextEditingController();
  Map<String, dynamic>? _teamData;
  int _gameweek = 10; // set to the latest gameweek

  Future<void> _fetchData() async {
    final fplService = FPLService();
    final data = await fplService.fetchTeamData(_teamIdController.text, _gameweek);
    setState(() {
      _teamData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FPL Team Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamIdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter FPL Team ID'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Get Team Data'),
            ),
            if (_teamData != null) ...[
              Text(
                'Points Last Week: ${_teamData!['points']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _teamData!['picks'].length,
                  itemBuilder: (context, index) {
                    final player = _teamData!['picks'][index];

                    return ListTile(

                      title: Text('Player : ${player['playerName']}'),
                      subtitle: Text('TeamName: ${player['teamName']}'),
                      trailing: Text('points: ${player['pointsgw']}'),
                      
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
