// lib/home.dart
import 'package:flutter/material.dart';
import 'data/character_list.dart'; // For editing characters
import 'pages/team_formation_page.dart';
import 'pages/match_history_page.dart'; // Import the new match history page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Available players
  final List<String> players = ['Diego', 'Nick', 'Boni', 'Samu', 'Sindri'];
  final List<String> selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unmatched Draft'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to match history screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchHistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to the character editing screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CharacterList()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Select 4 Players:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final isSelected = selectedPlayers.contains(player);

                return ListTile(
                  title: Text(player),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      if (value == true) {
                        // Add if not exceeding 4
                        if (selectedPlayers.length < 4) {
                          setState(() {
                            selectedPlayers.add(player);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You can only select 4 players'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      } else {
                        // Remove if unchecked
                        setState(() {
                          selectedPlayers.remove(player);
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedPlayers.length == 4
                  ? () {
                      // Navigate to team formation page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamFormationPage(
                            selectedPlayers: List.from(selectedPlayers),
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Form Teams', style: TextStyle(fontSize: 16)),
            ),
          ),
          // Match history button - below the Form Teams button
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('View Match History'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MatchHistoryPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}