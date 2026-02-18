import 'package:flutter/material.dart';

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

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  Color _getColor() {
    if (happinessLevel > 70) {
      return Colors.green;
    }
    if (30 <= happinessLevel && happinessLevel <= 70) {
      return Colors.yellow;
    }
    else {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getMood(happinessLevel),

            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage('assets/images/pet_image.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                          _getColor().withOpacity(0.5), BlendMode.darken),
                ),
              ),
            ),

            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
