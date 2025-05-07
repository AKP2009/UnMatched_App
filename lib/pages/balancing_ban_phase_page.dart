import 'dart:math';
import 'package:flutter/material.dart';
import '../data/character.dart';
import '../data/character_list.dart';
import 'final_charcter_selection_page.dart';

class BalancingBanPhasePage extends StatefulWidget {
  final Character? captainOneCharacter;
  final Character? captainTwoCharacter;
  final List<String> teamOne;
  final List<String> teamTwo;

  const BalancingBanPhasePage({
    super.key,
    required this.captainOneCharacter,
    required this.captainTwoCharacter,
    required this.teamOne,
    required this.teamTwo,
  });

  @override
  State<BalancingBanPhasePage> createState() => _BalancingBanPhasePageState();
}

class _BalancingBanPhasePageState extends State<BalancingBanPhasePage> {
  List<Character> banPool = [];
  Character? selectedBanCharacter;
  Character? bannedCharacter;
  Character? selectedCharacter;
  late int highestTierTeam;
  bool selectionPhase = false;

  String get captainOneName => widget.teamOne.isNotEmpty ? widget.teamOne[0] : "Captain 1";
  String get captainTwoName => widget.teamTwo.isNotEmpty ? widget.teamTwo[0] : "Captain 2";
  
  String get highestTierCaptainName => highestTierTeam == 1 ? captainOneName : captainTwoName;
  String get lowerTierCaptainName => highestTierTeam == 1 ? captainTwoName : captainOneName;

  @override
  void initState() {
    super.initState();
    _setupBanPhase();
  }

  void _setupBanPhase() {
    final c1Tier = widget.captainOneCharacter?.tier ?? 0;
    final c2Tier = widget.captainTwoCharacter?.tier ?? 0;

    // Determine which captain has the higher-tier character.
    if (c1Tier > c2Tier) {
      highestTierTeam = 1;
    } else if (c2Tier > c1Tier) {
      highestTierTeam = 2;
    } else {
      highestTierTeam = 1; // Default in tie
    }

    final highestTier = highestTierTeam == 1 ? c1Tier : c2Tier;

    // Gather all characters of that tier from the global list.
    List<Character> sameTierCharacters =
        globalCharacters.where((c) => c.tier == highestTier).toList();

    // Exclude the captain's already assigned character.
    if (highestTierTeam == 1 && widget.captainOneCharacter != null) {
      sameTierCharacters.removeWhere(
          (c) => c.name == widget.captainOneCharacter!.name);
    } else if (highestTierTeam == 2 && widget.captainTwoCharacter != null) {
      sameTierCharacters.removeWhere(
          (c) => c.name == widget.captainTwoCharacter!.name);
    }

    sameTierCharacters.shuffle();
    final poolSize = min(3, sameTierCharacters.length);
    banPool = sameTierCharacters.sublist(0, poolSize);
  }

  void _confirmBan() {
    if (selectedBanCharacter != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("$highestTierCaptainName - Confirm Ban"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to ban:"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    selectedBanCharacter!.imagePath,
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
                        selectedBanCharacter!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text("Tier ${selectedBanCharacter!.tier}"),
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
                setState(() {
                  bannedCharacter = selectedBanCharacter;
                  banPool.remove(selectedBanCharacter);
                  selectionPhase = true;
                  selectedBanCharacter = null;
                });
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
  }

  void _selectCharacter(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$lowerTierCaptainName - Confirm Selection"),
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
              setState(() {
                selectedCharacter = character;
                banPool.remove(character);
              });
              _showResultDialog();
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

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ban Phase Complete"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Banned by $highestTierCaptainName: ${bannedCharacter?.name ?? 'None'}"),
            const SizedBox(height: 8),
            Text("Selected by $lowerTierCaptainName (Second Pick):"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  selectedCharacter!.imagePath,
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
                      selectedCharacter!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("Tier ${selectedCharacter!.tier}"),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to the final selection phase.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalCharacterSelectionPage(
                    highestTierTeam: highestTierTeam,
                    lowerTierSecondPick: selectedCharacter!,
                    captainOneCharacter: widget.captainOneCharacter!,
                    captainTwoCharacter: widget.captainTwoCharacter!,
                    captainOneName: captainOneName,
                    captainTwoName: captainTwoName,
                  ),
                ),
              );
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (banPool.isEmpty && !selectionPhase) {
      return Scaffold(
        appBar: AppBar(title: const Text("Balancing & Ban Phase")),
        body: const Center(child: Text("No characters available for ban!")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Balancing & Character Ban Phase"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectionPhase ? _buildPickStep() : _buildBanStep(),
      ),
    );
  }

  Widget _buildBanStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$highestTierCaptainName - Ban One Character",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: banPool.length,
            itemBuilder: (context, index) {
              final character = banPool[index];
              return Card(
                color: selectedBanCharacter == character
                    ? Colors.red.withOpacity(0.2)
                    : null,
                child: ListTile(
                  leading: Image.asset(
                    character.imagePath,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(character.name),
                  subtitle: Text("Tier ${character.tier}"),
                  onTap: () {
                    setState(() {
                      selectedBanCharacter = character;
                    });
                  },
                ),
              );
            },
          ),
        ),
        if (selectedBanCharacter != null) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _confirmBan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text("Ban: ${selectedBanCharacter?.name}"),
          ),
        ],
      ],
    );
  }

  Widget _buildPickStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$highestTierCaptainName banned: ${bannedCharacter?.name ?? 'None'}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "$lowerTierCaptainName - Choose Your Second Character",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: banPool.isNotEmpty
              ? ListView.builder(
                  itemCount: banPool.length,
                  itemBuilder: (context, index) {
                    final character = banPool[index];
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          character.imagePath,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(character.name),
                        subtitle: Text("Tier ${character.tier}"),
                        onTap: () => _selectCharacter(character),
                      ),
                    );
                  },
                )
              : const Center(child: Text("No characters left to pick!")),
        ),
      ],
    );
  }
}