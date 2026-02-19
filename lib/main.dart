import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  Timer? _hungerTimer;
  bool playerWon = false;
  bool isGameOver = false;

  DateTime? _happinessAbove80Start;

  final TextEditingController _controller = TextEditingController();

  @override
    void initState() {
      super.initState();

      // Periodic timer that adds hunger every 30 seconds
      _hungerTimer = Timer.periodic(
        const Duration(seconds:30), 
        (_) => _updateHunger(),
      );
    }

  @override
    void dispose() {
      _controller.dispose();
      _hungerTimer?.cancel();
      super.dispose();
    }

  // Playing increases happiness and hunger and decreases energy
  void _playWithPet() {
    // All functions check if the game should be over
    if (isGameOver || playerWon) return;

    setState(() {
      happinessLevel += 10;
      energyLevel -= 5;
      _checkGame();
    });

      _updateHunger();
  }

  // Feeding decreases hunger and increases energy and happiness if possible
  void _feedPet() {
    if (isGameOver || playerWon) return;

    setState(() {
      hungerLevel -= 10;
      if (energyLevel < 100) {
        energyLevel += 10;
      }
      _checkGame();
    });

      _updateHappiness();
  }

  // 
  void _updateHappiness() {
    if (isGameOver || playerWon) return;

    setState(() {
      if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }

    _checkGame();
    });
  }

  void _updateHunger() {
    if (isGameOver || playerWon) return;

    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }

      _checkGame();
    });
  }

  void _checkGame() {
    if (isGameOver || playerWon) {
      return;
    }

    // Lose conditions
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        isGameOver = true;
      });
      return;
    }

    // Win conditions
    if (happinessLevel > 80) {
      // Start timer when happiness is above 80
      _happinessAbove80Start ??= DateTime.now();

      // Elapsed time between when the win timer started and now
      final elapsed = DateTime.now().difference(_happinessAbove80Start!);

      // If elapsed is 3 mins or longer, player won
      if (elapsed >= const Duration(minutes: 3)) {
        setState(() {
          playerWon = true;
        });
      }
    } else {
      _happinessAbove80Start = null;
    }
  }
  

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  Text _getMood(int happiness) {
    if (happinessLevel > 70) {
      return Text('Mood: Happy 😄', style: TextStyle(fontSize: 20.0));
    }
    if (30 <= happinessLevel && happinessLevel <= 70) {
      return Text('Mood: Neutral 😐', style: TextStyle(fontSize: 20.0));
    }
    else {
      return Text('Mood: Sad 😢', style: TextStyle(fontSize: 20.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the player won, change to a win screen
    if (playerWon) {
      return Scaffold(
      body: Center(
        child: Text(
          'You Win!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      );
    }

    // If the player lost, change to game over screen
    if (isGameOver) {
    return Scaffold(
      body: Center(
        child: Text(
          'Game Over :(',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
    }

    // Regular screen for when player has not won or lost
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getMood(happinessLevel),

            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset('assets/images/pet_image.png', 
                width: 150, 
                height: 150
              ),
            ),

            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),

            // Progress bar showing energy level
            Column(
              children: [
                Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: energyLevel / 100, // convert to 0-1
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 20,
                ),
                SizedBox(height: 16),
              ],
            ),

            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),

            SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  // Text field for changing pet name
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Change Pet name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Button for confirming Pet name change
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      petName = _controller.text.trim();
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            ),          
          ],
        ),
      ),
    );
  }
}
