// lib/data/character_list.dart
import 'package:flutter/material.dart';
import 'character.dart';

/// A global list of characters accessible throughout the app.
/// If you need persistence across app restarts, consider shared_preferences, Hive, etc.
List<Character> globalCharacters = [
  Character(name: 'Achille', tier: 7, imagePath: 'assets/images/achille_image.PNG'),
  Character(name: 'Wukong', tier: 7, imagePath: 'assets/images/wukong_image.PNG'),
  Character(name: 'Big Foot', tier: 7, imagePath: 'assets/images/bigfoot_image.PNG'),
  Character(name: 'Medusa', tier: 6, imagePath: 'assets/images/medusa_image.PNG'),
  Character(name: 'Yannenga', tier: 6, imagePath: 'assets/images/yannenga_image.PNG'),
  Character(name: 'Luke Cage', tier: 6, imagePath: 'assets/images/luke_image.PNG'),
  Character(name: 'Tomoe Gozen', tier: 6, imagePath: 'assets/images/tomoe_image.PNG'),
  Character(name: 'Winter Soldier', tier: 6, imagePath: 'assets/images/winter_image.PNG'),
  Character(name: 'Moldun', tier: 5, imagePath: 'assets/images/muldoon_image.PNG'),
  Character(name: 'Sinbad', tier: 5, imagePath: 'assets/images/sinbad_image.PNG'),
  Character(name: 'Moon Knight', tier: 5, imagePath: 'assets/images/moon_image.PNG'),
  Character(name: 'She Hulk', tier: 5, imagePath: 'assets/images/hulk_image.PNG'),
  Character(name: 'Elektra', tier: 5, imagePath: 'assets/images/elektra_image.PNG'),
  Character(name: 'Tesla', tier: 5, imagePath: 'assets/images/tesla_image.PNG'),
  Character(name: 'Golden Bat', tier: 5, imagePath: 'assets/images/goldenbat_image.PNG'),
  Character(name: 'Spider-Man', tier: 4, imagePath: 'assets/images/spiderman_image.PNG'),
  Character(name: 'Robin Hood', tier: 4, imagePath: 'assets/images/robin_image.PNG'),
  Character(name: 'Beowulf', tier: 4, imagePath: 'assets/images/beowulf_image.PNG'),
  Character(name: 'Ghost Rider', tier: 4, imagePath: 'assets/images/ghost_image.PNG'),
  Character(name: 'Squirrel Girl', tier: 4, imagePath: 'assets/images/squirrel_image.PNG'),
  Character(name: 'Il Genio', tier: 4, imagePath: 'assets/images/genio_image.PNG'),
  Character(name: 'Houdini', tier: 4, imagePath: 'assets/images/houdini_image.PNG'),
  Character(name: 'Black Panther', tier: 3, imagePath: 'assets/images/panther_image.PNG'),
  Character(name: 'Alice', tier: 3, imagePath: 'assets/images/alice_image.PNG'),
  Character(name: 'Cappuccetto Rosso', tier: 3, imagePath: 'assets/images/cappuccetto_image.PNG'),
  Character(name: 'Sherlock', tier: 3, imagePath: 'assets/images/holmes_image.PNG'),
  Character(name: 'Oda Nobunaga', tier: 3, imagePath: 'assets/images/oda_image.PNG'),
  Character(name: 'Bloody Mary', tier: 3, imagePath: 'assets/images/bloody_image.PNG'),
  Character(name: 'Annie Christmas', tier: 3, imagePath: 'assets/images/annie_image.PNG'),
  Character(name: 'Ms. Marvel', tier: 3, imagePath: 'assets/images/marvel_image.PNG'),
  Character(name: 'Jill Trent', tier: 2, imagePath: 'assets/images/trent_image.PNG'),
  Character(name: 'Bullseye', tier: 2, imagePath: 'assets/images/bullseye_image.PNG'),
  Character(name: 'Cloak and Dagger', tier: 2, imagePath: 'assets/images/cloak_image.PNG'),
  Character(name: 'Raptors', tier: 2, imagePath: 'assets/images/raptor_image.PNG'),
  Character(name: 'Daredevil', tier: 2, imagePath: 'assets/images/daredevil_image.PNG'),
  Character(name: 'Black Widow', tier: 2, imagePath: 'assets/images/widow_image.PNG'),
  Character(name: 'Doctor Strange', tier: 2, imagePath: 'assets/images/strange_image.PNG'),
  Character(name: 'Re Artu', tier: 1, imagePath: 'assets/images/artu_image.PNG'),
  Character(name: 'Invisible Man', tier: 1, imagePath: 'assets/images/invisible_image.PNG'),
  Character(name: 'Dracula', tier: 1, imagePath: 'assets/images/dracula_image.PNG'),
  Character(name: 'Dr. Jekyll', tier: 1, imagePath: 'assets/images/jekill_image.PNG'),
];

class CharacterList extends StatefulWidget {
  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  // Function to update tier
  void updateTier(int index, int newTier) {
    setState(() {
      globalCharacters[index].tier = newTier;
    });
  }

  // Function to remove character
  void removeCharacter(int index) {
    setState(() {
      globalCharacters.removeAt(index);
    });
  }

  // Function to add a new character ensuring uniqueness by name
  void addNewCharacter(String name, int tier, String imagePath) {
    // Check if character with the same name exists (case-insensitive)
    if (globalCharacters.any((c) => c.name.toLowerCase() == name.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Character already exists!')),
      );
      return;
    }

    setState(() {
      globalCharacters.add(
        Character(
          name: name,
          tier: tier,
          imagePath: imagePath.isNotEmpty
              ? imagePath
              : 'assets/images/default_image.png',
        ),
      );
    });
  }

  // Show dialog to add a new character
  void _showAddCharacterDialog(BuildContext context) {
    final nameController = TextEditingController();
    final imagePathController = TextEditingController(text: 'assets/images/');
    int selectedTier = 3; // Default tier

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Character'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Character Name',
                  hintText: 'Enter character name',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedTier,
                decoration: const InputDecoration(
                  labelText: 'Tier',
                ),
                items: List.generate(7, (index) => index + 1)
                    .map((tier) => DropdownMenuItem(
                          value: tier,
                          child: Text('Tier $tier'),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedTier = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Image Path',
                  hintText: 'assets/images/character_image.PNG',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                addNewCharacter(
                  nameController.text,
                  selectedTier,
                  imagePathController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character Tier List')),
      body: ListView.builder(
        itemCount: globalCharacters.length,
        itemBuilder: (context, index) {
          final character = globalCharacters[index];
          return ListTile(
            leading: Image.asset(
              character.imagePath,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            title: Text(character.name),
            subtitle: Text('Tier ${character.tier}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => removeCharacter(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCharacterDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
