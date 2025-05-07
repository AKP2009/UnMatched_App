import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/character.dart';

class GameResultPage extends StatefulWidget {
  final String selectedMap;
  final Map<String, List<Character>> finalTeams;

  const GameResultPage({
    Key? key,
    required this.selectedMap,
    required this.finalTeams,
  }) : super(key: key);

  @override
  State<GameResultPage> createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage> {
  String? winnerTeam;
  List<Map<String, dynamic>> matchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMatchHistory();
  }

  Future<void> _loadMatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('full_match_history');

    if (storedData != null) {
      setState(() {
        matchHistory = List<Map<String, dynamic>>.from(json.decode(storedData));
      });
    }
  }

  Future<void> _saveMatchResult() async {
    if (winnerTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a winning team')),
      );
      return;
    }

    final String loserTeam = widget.finalTeams.keys.firstWhere((team) => team != winnerTeam);

    final matchData = {
      'map': widget.selectedMap,
      'winnerTeam': {
        'name': winnerTeam,
        'characters': widget.finalTeams[winnerTeam]!.map((c) => {
          'name': c.name,
          'tier': c.tier,
        }).toList(),
      },
      'loserTeam': {
        'name': loserTeam,
        'characters': widget.finalTeams[loserTeam]!.map((c) => {
          'name': c.name,
          'tier': c.tier,
        }).toList(),
      },
    };

    matchHistory.add(matchData);

    // Keep only last 50 matches
    if (matchHistory.length > 50) {
      matchHistory = matchHistory.sublist(matchHistory.length - 50);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_match_history', json.encode(matchHistory));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Match result saved!')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final teamNames = widget.finalTeams.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Save Match Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Map: ${widget.selectedMap}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Which team won?',
                border: OutlineInputBorder(),
              ),
              value: winnerTeam,
              items: teamNames.map((team) {
                return DropdownMenuItem(
                  value: team,
                  child: Text(team),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  winnerTeam = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveMatchResult,
              child: const Text('Save Match Result'),
            ),
          ],
        ),
      ),
    );
  }
}
