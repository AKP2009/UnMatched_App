import 'dart:math';
import 'package:flutter/material.dart';
import '../data/map.dart';
import '../data/character.dart';
import 'game_result_page.dart'; // Import the GameResultPage

class MapSelectionPage extends StatefulWidget {
  final Map<String, List<Character>> finalTeams;

  const MapSelectionPage({
    super.key,
    required this.finalTeams,
  });

  @override
  State<MapSelectionPage> createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  GameMap? selectedMap;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectRandomMap();
  }

  void _selectRandomMap() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (globalMaps.isNotEmpty) {
        final random = Random();
        final selectedIndex = random.nextInt(globalMaps.length);

        setState(() {
          selectedMap = globalMaps[selectedIndex];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the actual team names from the finalTeams map
    final List<String> teamNames = widget.finalTeams.keys.toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Selection'),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Selecting a map...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTeamSection(teamNames[0], widget.finalTeams[teamNames[0]]!, Colors.blue),
                  const SizedBox(height: 24),
                  _buildTeamSection(teamNames[1], widget.finalTeams[teamNames[1]]!, Colors.red),
                  const SizedBox(height: 32),

                  const Text(
                    'Selected Map:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (selectedMap != null) ...[
                    Text(
                      selectedMap!.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          selectedMap!.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error, size: 48),
                                  SizedBox(height: 16),
                                  Text(
                                    'Map image not found. Please ensure images are in the correct location.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else
                    const Center(child: Text('No maps available.')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectRandomMap,
                    child: const Text('Reshuffle Map'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (selectedMap != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameResultPage(
                              selectedMap: selectedMap!.name,
                              finalTeams: widget.finalTeams,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Map not selected yet!'),
                          ),
                        );
                      }
                    },
                    child: const Text('Finish and Save Result'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTeamSection(String teamName, List<Character> characters, Color color) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: characters.map((character) {
                return Expanded(
                  child: Card(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            character.imagePath,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 40),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            character.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Tier ${character.tier}'),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}