import 'package:flutter/material.dart';

import 'negative_number_exception.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter String Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter String Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController input = TextEditingController();
  int sumOfString = 0;

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  int add(String numbers) {
    if (numbers.isEmpty) {
      return 0;
    }

    // Check for custom delimiter
    if (numbers.startsWith("//")) {
      var delimiterLineEnd = numbers.indexOf('\n');
      var delimiter = numbers.substring(2, delimiterLineEnd);
      var numbersPart = numbers.substring(delimiterLineEnd + 1);

      // Split numbers based on the custom delimiter and newlines
      var numbersList = numbersPart.split(RegExp('[${delimiter}\n]'));

      return _sum(numbersList);
    }

    // Default case for comma and newline as delimiters
    var numbersList = numbers.split(RegExp('[,\n]'));

    return _sum(numbersList);
  }


  int _sum(List<String> numbersList) {
    List<int> numbers = [];
    List<int> negativeNumbers = [];

    for (var number in numbersList) {
      var value = int.tryParse(number.trim());

      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid number: '$number'"),
            duration: Duration(seconds: 2),
          ),
        );
        throw FormatException("Invalid number: '$number'");
      }

      if (value < 0) {
        negativeNumbers.add(value);
      } else if (value <= 1000) { // Ignore numbers greater than 1000
        numbers.add(value);
      }
    }

    if (negativeNumbers.isNotEmpty) {
       SnackBar(
        content: Text("Negative numbers not allowed: ${negativeNumbers.join(',')}"),
        duration: Duration(seconds: 2),
      );
      throw NegativeNumberException("Negative numbers not allowed: ${negativeNumbers.join(',')}");
    }

    return numbers.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please enter the string that you want to evaluate:\t',
            ),
            const SizedBox(height: 20),
            TextField(
              controller: input,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  contentPadding: EdgeInsets.all(5),
                  hintText: "Please enter the input"),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  setState(() {
                    sumOfString = (input.text.isNotEmpty) ? add("${input.text}") : 0;
                  });
                },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)
              ),
                child: Text("Validate",style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 50),
            Text(
              'Sum of given numbers from the string is: \t$sumOfString',
            ),
          ],
        ),
      ),
    );
  }
}