import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({Key? key}) : super(key: key);

  @override
  State<MatchHistoryPage> createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  List<Map<String, dynamic>> matchHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatchHistory();
  }

  Future<void> _loadMatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('full_match_history');

    setState(() {
      if (storedData != null) {
        matchHistory = List<Map<String, dynamic>>.from(json.decode(storedData));
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchHistory.isEmpty
              ? const Center(child: Text('No match history found'))
              : ListView.builder(
                  itemCount: matchHistory.length,
                  itemBuilder: (context, index) {
                    // Display matches in reverse chronological order
                    final match = matchHistory[matchHistory.length - 1 - index];
                    final Map<String, dynamic> winnerTeam = match['winnerTeam'];
                    final Map<String, dynamic> loserTeam = match['loserTeam'];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.map, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Map: ${match['map']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            _buildTeamSection(
                              '🏆 Winner: ${winnerTeam['name']}',
                              List<Map<String, dynamic>>.from(winnerTeam['characters']),
                              Colors.green.shade700, // Darker green for better contrast
                              Colors.white, // White text color for contrast
                            ),
                            const SizedBox(height: 8),
                            _buildTeamSection(
                              'Loser: ${loserTeam['name']}',
                              List<Map<String, dynamic>>.from(loserTeam['characters']),
                              Colors.red.shade700, // Darker red for better contrast
                              Colors.white, // White text color for contrast
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildTeamSection(
    String teamName,
    List<Map<String, dynamic>> characters,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamName,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: characters.map((character) {
              return Expanded(
                child: Card(
                  color: Colors.black.withOpacity(0.1), // Darker card background
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text(
                          character['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Tier ${character['tier']}',
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}