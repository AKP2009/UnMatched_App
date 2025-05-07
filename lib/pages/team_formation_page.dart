// lib/pages/team_formation_page.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'choosecharacter.dart';

class TeamFormationPage extends StatefulWidget {
  final List<String> selectedPlayers;

  const TeamFormationPage({super.key, required this.selectedPlayers});

  @override
  State<TeamFormationPage> createState() => _TeamFormationPageState();
}

class _TeamFormationPageState extends State<TeamFormationPage> {
  List<String> teamOne = [];
  List<String> teamTwo = [];
  String? captainOne;
  String? captainTwo;
  bool teamsFormed = false;

  @override
  void initState() {
    super.initState();
    _formTeams();
  }

  void _formTeams() {
    // Shuffle the 4 selected players and split into two teams of 2
    List<String> shuffledPlayers = List.from(widget.selectedPlayers);
    shuffledPlayers.shuffle();

    teamOne = shuffledPlayers.sublist(0, 2);
    teamTwo = shuffledPlayers.sublist(2, 4);

    // Randomly assign a captain from each team
    captainOne = teamOne[Random().nextInt(2)];
    captainTwo = teamTwo[Random().nextInt(2)];

    setState(() {
      teamsFormed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Formation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Teams:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Team One
            _buildTeamCard(
              'Team 1',
              teamOne,
              captainOne,
              Colors.blue.shade100,
              Colors.blue,
              Colors.black,
            ),
            const SizedBox(height: 24),
            // Team Two
            _buildTeamCard(
              'Team 2',
              teamTwo,
              captainTwo,
              Colors.red.shade100,
              Colors.red,
              Colors.black,
            ),
            const Spacer(),
            // Start Draft Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    teamsFormed
                        ? () {
                          // Navigate to the captain selection page with the captain names
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CaptainSelectionPage(
                                    teamOne: teamOne,
                                    teamTwo: teamTwo,
                                    captainOneName:
                                        captainOne!, // Must match the constructor params
                                    captainTwoName:
                                        captainTwo!, // Must match the constructor params
                                  ),
                            ),
                          );
                        }
                        : null,
                child: const Text(
                  'Start Draft',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Reshuffle Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _formTeams,
                child: const Text(
                  'Reshuffle Teams',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(
    String teamName,
    List<String> players,
    String? captain,
    Color backgroundColor,
    Color captainColor,
    Color textColor,
  ) {
    return Card(
      elevation: 4,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ...players.map((player) {
              bool isCaptain = player == captain;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        player,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isCaptain ? FontWeight.bold : FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (isCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: captainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Captain',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
