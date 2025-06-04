import 'package:flutter/material.dart';
import 'package:submit_button_group/submit_button_group.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  Future _incrementCounter() async {
    await Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        _counter++;
      });
    });
  }

  Future _decrementCounter() async {
    await Future.delayed(Duration(seconds: 1)).then((value) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SubmitButtonsGroup(
            isExpand: true,
            loading: _loading,
            primeButtonText: 'Increment',
            secondaryButtonText: 'Decrement',
            secondaryButtonColor: Colors.red,
            primeButtonColor: Colors.green,
            secondaryButtonTextStyle: const TextStyle(color: Colors.white),
            onCancel: _counter > 0
                ? () async {
                    _loading.value = true;
                    await _decrementCounter();
                    _loading.value = false;
                  }
                : () {},
            onSubmit: () async {
              _loading.value = true;
              await _incrementCounter();
              _loading.value = false;
            },
          )),
    );
  }
}
