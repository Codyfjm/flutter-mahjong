import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
                Text("${this._parentScore["ron"]}", style: tableTextStyle),
                Text("${this._parentScore["draw"]}" + "A",
                    style: tableTextStyle),
              ],
            ),
            TableRow(
              children: [
                Text("子", style: tableTextStyle),
                Text("${this._childScore["ron"]}", style: tableTextStyle),
                Text("${this._childScore["draw"]}", style: tableTextStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }

  int _selectedItem = 30;

  final List<int> _items = [
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

  Widget _pickerItem(int h) {
    return Text(h.toString(), style: TextStyle(fontSize: 32));
  }

  Widget _onSelectedItemChanged(int index) {
    setState(() {
      _selectedItem = _items[index];
    });
  }

  void _showModalPicker(BuildContext context) {
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
              children: _items.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChanged,
            ),
          ),
        );
      },
    );
  }

  Widget _DataArea() {
    return RaisedButton(
      onPressed: () {
        _showModalPicker(context);
      },
      child: Text("${_selectedItem}"),
    );
  }

  void _handlePressed() {
    setState(() {
      this._hu = _selectedItem;
      // this._hu++;
      // this._han++;
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
