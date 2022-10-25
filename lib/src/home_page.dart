import 'package:dont_risk_it/src/results_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// That's it for now, things I plan to do
//  - make a background image of little tanks at 45 degrees with different soft colors
//  - wrap this bitch up in a stack but I think that will fuck up the keyboard interaction and what not, fucking flutter lots of work
//  - fix the button to look better
//  - change the theme

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int atkVal;
  late int defVal;
  late int surVal;

  // ignore: todo
  //TODO: maybe add instead of a submit button there is a -> to go to the next field in the form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const Drawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildAtkField(),
                  const SizedBox(height: 30),
                  _buildSurField(),
                  const SizedBox(height: 30),
                  _buildDefField(),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    child: const Text("Action!"),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsPage(
                              atk: atkVal,
                              def: defVal,
                              sur: surVal,
                            ),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
    ovo moraju da budu 3 funkcije
    - ne moze jedna jer onda pravi istu instancu za sva 3 polja i ne moze da se zaobidje sa new
    - ako ih odvojis u klasu, ne mozes da vratis vrednost atkVal ili koja vec se updateuje jer nemas pass by ref
    The solution is to learn BLOC, I am defieneatly not doing another app in flutter without it
  */

  // ignore: todo
  // TODO: limit atk tanks number (maxLength: 3) or change the algorithm or add simulations (I don't even know how that's done)
  Widget _buildAtkField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        labelText: "Attack tanks",
      ),
      validator: (String? value) {
        int? intVal = int.tryParse(value!);
        if (intVal == null) return 'Number of attack tanks is required';
        if (intVal < 2) return 'You must have at least 2 tanks to attack';
        return null;
      },
      onSaved: (String? value) {
        atkVal = int.parse(value!);
      },
    );
  }

  Widget _buildDefField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        labelText: "Defence tanks",
      ),
      validator: (String? value) {
        int? intVal = int.tryParse(value!);
        if (intVal == null) return 'Number of defence tanks is required';
        if (intVal < 1) return 'You must have at least 1 tank to defend';
        return null;
      },
      onSaved: (String? value) {
        defVal = int.parse(value!);
      },
    );
  }

  Widget _buildSurField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        labelText: "Tanks you would like to have left after the battle",
      ),
      validator: (String? value) {
        int? intVal = int.tryParse(value!);
        if (intVal == null || intVal < 2) {
          return 'You must have at least 2 tanks left';
        }
        return null;
      },
      onSaved: (String? value) {
        surVal = int.parse(value!);
      },
    );
  }
}
