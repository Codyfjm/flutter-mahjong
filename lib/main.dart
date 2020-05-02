import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as Math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '麻雀得点計算App',
      home: Scaffold(
        appBar: AppBar(
          title: Text("麻雀得点計算App"),
          centerTitle: true,
        ),
        body: Card(
          child: MahjongScore(),
        ),
      ),
    );
  }
}

class MahjongScore extends StatefulWidget {
  @override
  MahjongScoreState createState() => MahjongScoreState();
}

class MahjongScoreState extends State<MahjongScore> {
  int _hu = 30;
  int _han = 1;
  var _parentScore = {"ron": 1500, "draw": 500};
  var _childScore = {"ron": 1000, "draw": 300};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _ScoreArea(),
        _DataArea(),
        _ButtonArea(),
      ],
    );
  }

  Widget _ScoreArea() {
    final tableTextStyle =
        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
    int basicScore = Math.pow(2, this._han + 2) * this._hu;
    List<int> parentScore = [(basicScore * 6 / 100).ceil() * 100, (basicScore * 2 / 100).ceil() * 100];
    List<int> childScore = [(basicScore * 4 / 100).ceil() * 100, (basicScore / 100).ceil() * 100, (basicScore * 2 / 100).ceil() * 100];

    return Column(
      children: [
        Container(
          child: Text("${this._hu}符${this._han}翻", style: tableTextStyle),
        ),
        Table(
          children: [
            TableRow(
              children: [
                Text(""),
                Text("ロン", style: tableTextStyle),
                Text("ツモ", style: tableTextStyle),
              ],
            ),
            TableRow(
              children: [
                Text("親", style: tableTextStyle),
                Text("${parentScore[0]}", style: tableTextStyle),
                Text("${parentScore[1]}" + "A",
                    style: tableTextStyle),
              ],
            ),
            TableRow(
              children: [
                Text("子", style: tableTextStyle),
                // Text("${this._childScore["ron"]}", style: tableTextStyle),
                Text("${childScore[0]}", style: tableTextStyle),
                Text("${childScore[1]}, ${childScore[2]}", style: tableTextStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }

  int _selectedHu = 30;
  int _selectedHan = 1;

  final List<int> _listHu = [
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120,
  ];

  final List<int> _listHan = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
  ];

  Widget _pickerItem(int h) {
    return Text(h.toString(), style: TextStyle(fontSize: 32));
  }

  Widget _onSelectedHuChanged(int index) {
    setState(() {
      _selectedHu = _listHu[index];
    });
  }

  Widget _onSelectedHanChanged(int index) {
    setState(() {
      _selectedHan = _listHan[index];
    });
  }

  void _showModalPickerHu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _listHu.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedHuChanged,
            ),
          ),
        );
      },
    );
  }

  void _showModalPickerHan(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _listHan.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedHanChanged,
            ),
          ),
        );
      },
    );
  }

  Widget _DataArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            _showModalPickerHu(context);
          },
          child: Text("${_selectedHu}"),
        ),
        RaisedButton(
          onPressed: () {
            _showModalPickerHan(context);
          },
          child: Text("${_selectedHan}"),
        ),
      ],
    );
  }

  void _handlePressed() {
    setState(() {
      this._hu = _selectedHu;
      this._han = _selectedHan;
    });
  }

  Widget _ButtonArea() {
    return Container(
      child: FlatButton(
        onPressed: _handlePressed,
        color: Colors.blue,
        child: Text(
          "点数を表示",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
