import 'package:dont_risk_it/src/engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ResultsPage extends StatefulWidget {
  final int atk, def, sur;
  const ResultsPage(
      {Key? key, required this.atk, required this.def, required this.sur})
      : super(key: key);
  final int decimalPoint = 2;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late ClassicEngine standardEngine;
  late ClassicEngine tanksLeftEngine;

  late int atk, def;
  late double winChance, winChanceWithSur;

  late int maxTanksToDieInDiceRoll;
  late int maxTanksToDieInDiceRollWithSur;

  @override
  void initState() {
    super.initState();

    atk = widget.atk;
    def = widget.def;

    if (widget.sur == 1) {
      standardEngine = ClassicEngine(atk: atk, def: def, sur: 1);
      tanksLeftEngine = standardEngine;
    } else {
      standardEngine = ClassicEngine(atk: atk, def: def, sur: 1);
      tanksLeftEngine = ClassicEngine(atk: atk, def: def, sur: widget.sur);
    }

    winChance = standardEngine.getResult();
    winChanceWithSur = tanksLeftEngine.getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 10.0),
                    _getText("Your chances to win"),
                    _getNumberText(
                        "${winChance.toStringAsFixed(widget.decimalPoint)}%"),
                    const SizedBox(height: 20.0),
                    _getText("Your chances to win with ${widget.sur} left"),
                    _getNumberText(
                        "${winChanceWithSur.toStringAsFixed(widget.decimalPoint)}%"),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                margin: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _getNumberText("$atk"),
                        _getNumberText("vs"),
                        _getNumberText("$def"),
                      ],
                    ),
                    _getText("Update your chances!"),
                    _getText("How many tanks did you lose on this dice roll?"),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.5),
                      child: ButtonBar(
                        buttonPadding: const EdgeInsets.all(0.0),
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: standardEngine.isValidUpdate(0)
                                  ? () => btnUpdateFunction(0)
                                  : null,
                              child: const Text("0")),
                          ElevatedButton(
                              onPressed: standardEngine.isValidUpdate(1)
                                  ? () => btnUpdateFunction(1)
                                  : null,
                              child: const Text("1")),
                          ElevatedButton(
                              onPressed: standardEngine.isValidUpdate(2)
                                  ? () => btnUpdateFunction(2)
                                  : null,
                              child: const Text("2")),
                          ElevatedButton(
                              onPressed: standardEngine.isValidUpdate(3)
                                  ? () => btnUpdateFunction(3)
                                  : null,
                              child: const Text("3")),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Reset"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: AutoSizeText(
        text,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  Widget _getNumberText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: AutoSizeText(
        text,
        style: const TextStyle(fontSize: 30),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  void updateDisplayValues() {
    setState(() {
      atk = standardEngine.getAtk();
      def = standardEngine.getDef();
      winChance = standardEngine.getResult();
      winChanceWithSur = tanksLeftEngine.getResult();
    });
  }

  void btnUpdateFunction(int btnVal) {
    standardEngine.updateValues(btnVal);
    tanksLeftEngine.updateValues(btnVal);
    updateDisplayValues();
  }
}
