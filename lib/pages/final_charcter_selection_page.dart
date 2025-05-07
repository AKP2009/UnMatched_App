// lib/pages/final_character_selection_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/character.dart';
import '../data/character_list.dart';
import './map_selection_page.dart';

class FinalCharacterSelectionPage extends StatefulWidget {
  final int highestTierTeam; // Team with only one character (needs final second pick)
  final Character lowerTierSecondPick; // Second pick from Ban Phase for team with lower-tier captain
  final Character captainOneCharacter;
  final Character captainTwoCharacter;
  final String captainOneName;
  final String captainTwoName;

  const FinalCharacterSelectionPage({
    super.key,
    required this.highestTierTeam,
    required this.lowerTierSecondPick,
    required this.captainOneCharacter,
    required this.captainTwoCharacter,
    required this.captainOneName,
    required this.captainTwoName,
  });

  @override
  State<FinalCharacterSelectionPage> createState() =>
      _FinalCharacterSelectionPageState();
}

class _FinalCharacterSelectionPageState
    extends State<FinalCharacterSelectionPage> {
  List<Character> finalBanPool = [];
  Character? bannedCharacter;
  Character? finalSelectionPick; // Final second pick for the team with higher-tier captain
  bool selectionPhase = false; // false = ban phase, true = pick phase

  String get highestTierCaptainName =>
      widget.highestTierTeam == 1 ? widget.captainOneName : widget.captainTwoName;
  
  String get lowerTierCaptainName =>
      widget.highestTierTeam == 1 ? widget.captainTwoName : widget.captainOneName;

  @override
  void initState() {
    super.initState();
    _setupFinalSelection();
  }

  void _setupFinalSelection() {
    // Use the lower of the two captains' tiers (instead of the global minimum) for final selection.
    int finalTier =
        widget.captainOneCharacter.tier < widget.captainTwoCharacter.tier
            ? widget.captainOneCharacter.tier
            : widget.captainTwoCharacter.tier;

    // Gather all characters of that tier.
    List<Character> pool =
        globalCharacters.where((c) => c.tier == finalTier).toList();
    // Exclude any captain's character from this pool.
    pool.removeWhere(
      (c) =>
          c.name == widget.captainOneCharacter.name ||
          c.name == widget.captainTwoCharacter.name ||
          c.name == widget.lowerTierSecondPick.name,
    );
    pool.shuffle();
    int poolSize = min(3, pool.length);
    finalBanPool = pool.sublist(0, poolSize);
  }

  void _showBanConfirmationDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$lowerTierCaptainName - Confirm Ban"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to ban:"),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  character.imagePath,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.error),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("Tier ${character.tier}"),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _banCharacter(character);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Confirm Ban"),
          ),
        ],
      ),
    );
  }

  void _banCharacter(Character character) {
    setState(() {
      bannedCharacter = character;
      finalBanPool.remove(character);
      selectionPhase = true;
    });
  }

  void _showSelectionConfirmationDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$highestTierCaptainName - Confirm Selection"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to select:"),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  character.imagePath,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.error),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("Tier ${character.tier}"),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _selectCharacter(character);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text("Confirm Selection"),
          ),
        ],
      ),
    );
  }

  void _selectCharacter(Character character) {
    setState(() {
      finalSelectionPick = character;
      finalBanPool.remove(character);
    });
    // Make sure finalSelectionPick is not null before showing final teams
    if (finalSelectionPick != null) {
      _showFinalTeamsDialog();
    }
  }

  void _showFinalTeamsDialog() {
    // Check if finalSelectionPick is null and handle accordingly
    if (finalSelectionPick == null) {
      // Show error or return early
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a character first")),
      );
      return;
    }

    // Compose final teams
    Map<String, List<Character>> finalTeams = {};
    if (widget.highestTierTeam == 1) {
      finalTeams[widget.captainOneName] = [widget.captainOneCharacter, finalSelectionPick!];
      finalTeams[widget.captainTwoName] = [
        widget.captainTwoCharacter,
        widget.lowerTierSecondPick,
      ];
    } else {
      finalTeams[widget.captainOneName] = [
        widget.captainOneCharacter,
        widget.lowerTierSecondPick,
      ];
      finalTeams[widget.captainTwoName] = [widget.captainTwoCharacter, finalSelectionPick!];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Teams Finalized"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Final Team Compositions:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Captain 1's Team
            Text(
              "${widget.captainOneName}'s Team:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCharacterSummary(finalTeams[widget.captainOneName]![0]),
                _buildCharacterSummary(finalTeams[widget.captainOneName]![1]),
              ],
            ),
            const SizedBox(height: 16),
            // Captain 2's Team
            Text(
              "${widget.captainTwoName}'s Team:", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCharacterSummary(finalTeams[widget.captainTwoName]![0]),
                _buildCharacterSummary(finalTeams[widget.captainTwoName]![1]),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to map selection
              _storeFinalTeamDetails();
            },
            child: const Text("Continue to Map Selection"),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterSummary(Character character) {
    return Column(
      children: [
        Image.asset(
          character.imagePath,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
        const SizedBox(height: 4),
        Text(
          character.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("Tier ${character.tier}"),
      ],
    );
  }

  void _storeFinalTeamDetails() {
    // Check if finalSelectionPick is null and handle accordingly
    if (finalSelectionPick == null) {
      // Show error or return early
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a character first")),
      );
      return;
    }

    // Compose final teams
    Map<String, List<Character>> finalTeams = {};
    if (widget.highestTierTeam == 1) {
      finalTeams[widget.captainOneName] = [widget.captainOneCharacter, finalSelectionPick!];
      finalTeams[widget.captainTwoName] = [
        widget.captainTwoCharacter,
        widget.lowerTierSecondPick,
      ];
    } else {
      finalTeams[widget.captainOneName] = [
        widget.captainOneCharacter,
        widget.lowerTierSecondPick,
      ];
      finalTeams[widget.captainTwoName] = [widget.captainTwoCharacter, finalSelectionPick!];
    }

    // Navigate to the map selection page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapSelectionPage(finalTeams: finalTeams),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Character Selection & Balancing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectionPhase ? _buildPickPhase() : _buildBanPhase(),
      ),
    );
  }

  Widget _buildBanPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Final Selection: Ban Phase",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "$lowerTierCaptainName - please ban one character from the pool:",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: finalBanPool.length,
            itemBuilder: (context, index) {
              final character = finalBanPool[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(
                    character.imagePath,
                    width: 40,
                    height: 40,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                  title: Text(character.name),
                  subtitle: Text("Tier ${character.tier}"),
                  onTap: () => _showBanConfirmationDialog(character),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPickPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$lowerTierCaptainName banned: ${bannedCharacter?.name ?? 'None'}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "$highestTierCaptainName - choose your second character from the remaining options:",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              finalBanPool.isNotEmpty
                  ? ListView.builder(
                    itemCount: finalBanPool.length,
                    itemBuilder: (context, index) {
                      final character = finalBanPool[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                            character.imagePath,
                            width: 40,
                            height: 40,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                          ),
                          title: Text(character.name),
                          subtitle: Text("Tier ${character.tier}"),
                          onTap: () => _showSelectionConfirmationDialog(character),
                        ),
                      );
                    },
                  )
                  : const Center(
                    child: Text("No characters available for selection."),
                  ),
        ),
      ],
    );
  }
}