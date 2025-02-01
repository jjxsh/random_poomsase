import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(PoomsaeApp());
}

class PoomsaeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Poomsae Selector',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.black,
      ),
      home: PoomsaeScreen(),
    );
  }
}

class PoomsaeScreen extends StatefulWidget {
  @override
  _PoomsaeScreenState createState() => _PoomsaeScreenState();
}

class _PoomsaeScreenState extends State<PoomsaeScreen> {
  final List<String> poomsae = [
    "Taegeuk 4", "Taegeuk 5", "Taegeuk 6", "Taegeuk 7", "Taegeuk 8",
    "Koryo", "Keumgang", "Taeback", "Pyongwon", "Shipjin",
    "Jitae", "Chonkwon", "Hansu"
  ];

  late Map<String, List<String>> divisions;
  String selectedDivision = "Cadet";
  bool useCustomRange = false;
  int customStart = 0;
  int customEnd = 6;

  @override
  void initState() {
    super.initState();
    divisions = {
      "Cadet": poomsae.sublist(0, 7),
      "Junior": poomsae.sublist(1, 8),
      "U30/U40": poomsae.sublist(3, 10),
      "U50": poomsae.sublist(4, 11),
      "U60/U65/O65": poomsae.sublist(5, 12),
    };
  }

  void generatePoomsae() {
    List<String> selectedList = useCustomRange
        ? poomsae.sublist(customStart, customEnd + 1)
        : divisions[selectedDivision] ?? [];

    if (selectedList.length < 2) return;

    Random random = Random();
    String first = selectedList[random.nextInt(selectedList.length)];
    String second;
    do {
      second = selectedList[random.nextInt(selectedList.length)];
    } while (first == second);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          firstPoomsae: first,
          secondPoomsae: second,
          selectedList: selectedList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Poomsae Selector'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select Division:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedDivision,
                dropdownColor: Colors.grey[900],
                items: divisions.keys.map((division) {
                  return DropdownMenuItem(
                    value: division,
                    child: Text(division, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedDivision = value;
                      useCustomRange = false;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text("Use Custom Range", style: TextStyle(color: Colors.white)),
                value: useCustomRange,
                onChanged: (value) {
                  setState(() {
                    useCustomRange = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Select Custom Range:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("Start", style: TextStyle(color: Colors.white)),
                      DropdownButton<int>(
                        value: customStart,
                        dropdownColor: Colors.grey[900],
                        items: List.generate(poomsae.length, (index) => index).map((index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text(
                              poomsae[index],
                              style: TextStyle(color: useCustomRange ? Colors.white : Colors.grey),
                            ),
                          );
                        }).toList(),
                        onChanged: useCustomRange
                            ? (value) {
                                setState(() {
                                  if (value != null && value < customEnd) {
                                    customStart = value;
                                  }
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text("End", style: TextStyle(color: Colors.white)),
                      DropdownButton<int>(
                        value: customEnd,
                        dropdownColor: Colors.grey[900],
                        items: List.generate(poomsae.length, (index) => index).map((index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text(
                              poomsae[index],
                              style: TextStyle(color: useCustomRange ? Colors.white : Colors.grey),
                            ),
                          );
                        }).toList(),
                        onChanged: useCustomRange
                            ? (value) {
                                setState(() {
                                  if (value != null && value > customStart) {
                                    customEnd = value;
                                  }
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: generatePoomsae,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                  foregroundColor: Colors.white,
                ),
                child: Text("Generate Random Poomsae"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final String firstPoomsae;
  final String secondPoomsae;
  final List<String> selectedList;

  ResultScreen({required this.firstPoomsae, required this.secondPoomsae, required this.selectedList});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String firstPoomsae;
  late String secondPoomsae;

  @override
  void initState() {
    super.initState();
    firstPoomsae = widget.firstPoomsae;
    secondPoomsae = widget.secondPoomsae;
  }

  void rerollPoomsae() {
    Random random = Random();
    String newFirst = widget.selectedList[random.nextInt(widget.selectedList.length)];
    String newSecond;
    do {
      newSecond = widget.selectedList[random.nextInt(widget.selectedList.length)];
    } while (newFirst == newSecond);

    setState(() {
      firstPoomsae = newFirst;
      secondPoomsae = newSecond;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Selected Poomsae'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Column(
      children: [
        Text("Poomsae 1:", 
            style: TextStyle(fontSize: 20, color: Colors.white)),
        Text(firstPoomsae, 
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      ],
    ),
    SizedBox(height: 25), // Space between Poomsae 1 and Poomsae 2
    Column(
      children: [
        Text("Poomsae 2:", 
            style: TextStyle(fontSize: 20, color: Colors.white)),
        Text(secondPoomsae, 
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      ],
    ),
    SizedBox(height: 50), // Space before buttons
    ElevatedButton(onPressed: rerollPoomsae, child: Text("Re-roll Poomsae")),
    SizedBox(height: 20),
    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Go Back")),
  ],
)

        ),
      ),
    );
  }
}
