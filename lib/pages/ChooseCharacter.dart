  // lib/pages/choosecharacter.dart
  import 'package:flutter/material.dart';
  import '../data/character.dart';
  import '../data/character_list.dart';
  import 'balancing_ban_phase_page.dart';

  class CaptainSelectionPage extends StatefulWidget {
    final List<String> teamOne;
    final List<String> teamTwo;
    final String captainOneName;
    final String captainTwoName;

    const CaptainSelectionPage({
      super.key,
      required this.teamOne,
      required this.teamTwo,
      required this.captainOneName,
      required this.captainTwoName,
    });

    @override
    State<CaptainSelectionPage> createState() => _CaptainSelectionPageState();
  }

  class _CaptainSelectionPageState extends State<CaptainSelectionPage> {
    Character? captainOneCharacter;
    Character? captainTwoCharacter;
    bool selectionComplete = false;

    @override
    void initState() {
      super.initState();
      _assignCaptains();
    }

    void _assignCaptains() {
      // Copy the global list so we can shuffle & filter
      List<Character> availableCharacters = List.from(globalCharacters);

      if (availableCharacters.isEmpty) {
        print('No available characters to assign!');
        return;
      }

      // Shuffle for randomness
      availableCharacters.shuffle();

      // Assign first captain's character
      captainOneCharacter = availableCharacters.removeAt(0);

      // Remove all characters of the same tier for second captain
      availableCharacters.removeWhere(
        (c) => c.tier == captainOneCharacter!.tier,
      );

      // Assign second captain if possible
      if (availableCharacters.isNotEmpty) {
        captainTwoCharacter = availableCharacters.removeAt(0);
      } else {
        print('No valid characters left for the second captain!');
      }

      setState(() {
        selectionComplete = true;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Captain Character Selection')),
        body: selectionComplete
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCaptainCard(widget.captainOneName, captainOneCharacter, Colors.blue),
                    const SizedBox(height: 24),
                    _buildCaptainCard(widget.captainTwoName, captainTwoCharacter, Colors.red),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Balancing & Ban Phase
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BalancingBanPhasePage(
                              captainOneCharacter: captainOneCharacter,
                              captainTwoCharacter: captainTwoCharacter,
                              teamOne: widget.teamOne,
                              teamTwo: widget.teamTwo,
                            ),
                          ),
                        );
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    }

    Widget _buildCaptainCard(String captainName, Character? character, Color color) {
      if (character == null) {
        return Card(
          elevation: 4,
          color: color.withOpacity(0.1),
          child: ListTile(
            title: Text('$captainName: No Character Assigned'),
          ),
        );
      }

      return Card(
        elevation: 4,
        color: color.withOpacity(0.1),
        child: ListTile(
          leading: Image.asset(
            character.imagePath,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
          title: Text('$captainName: ${character.name}'),
          subtitle: Text('Tier ${character.tier}'),
        ),
      );
    }
  }
