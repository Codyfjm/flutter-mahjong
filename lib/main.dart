import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '点数確認App',
      home: Scaffold(
        appBar: AppBar(
          title: Text("点数確認App"),
          centerTitle: true,
        ),
        body: Container(
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
  int _selectedHu = 30;
  int _selectedHan = 2;

  int _hu;
  int _han;

  List<int> _childScore = List(3);
  List<int> _parentScore = List(2);

  final tableTextStyle = TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: _ScoreArea(),
        ),
        Expanded(
          flex: 1,
          child: _DataArea(),
        ),
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 1,
          child: _ButtonArea(),
        ),
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 1,
          child: Placeholder(),
        ),
      ],
    );
  }

  void fetchPosts(int hu, int han) {
    var url =
        'http://ec2-18-179-16-199.ap-northeast-1.compute.amazonaws.com:8000/score?hu=${hu}&han=${han}';
    http.get(url).then((response) {
      setState(() {
        var data = jsonDecode(response.body)[0];
        _childScore = [data['c_ron'], data['c_draw_c'], data['c_draw_p']];
        _parentScore = [data['p_ron'], data['p_draw']];
      });
    });
  }

  @override
  void initState() {
    super.initState();

    this._hu = this._selectedHu;
    this._han = this._selectedHan;
    fetchPosts(this._hu, this._han);
  }

  Widget _getScoreTableWidget(String str) {
    return Container(
      child: Center(child: Text(str, style: tableTextStyle)),
    );
  }

  Widget _getScoreTableRow(List<String> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 3,
          child: _getScoreTableWidget(list[0]),
        ),
        Expanded(
          flex: 3,
          child: _getScoreTableWidget(list[1]),
        ),
        Expanded(
          flex: 3,
          child: _getScoreTableWidget(list[2]),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }

  Widget _ScoreArea() {
    return Column(
      children: [
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 1,
          child: _getScoreTableRow(["${this._hu}符${this._han}翻", "ロン", "ツモ"]),
        ),
        Expanded(
          flex: 1,
          child: _getScoreTableRow(
              ["親", "${_parentScore[0]}", "${_parentScore[1]}"]),
        ),
        Expanded(
          flex: 1,
          child: _getScoreTableRow([
            "子",
            "${_childScore[0]}",
            "${_childScore[1]}, ${_childScore[2]}"
          ]),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }

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

  Widget _getDataRaisedButton(String str) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 50.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        onPressed: () {
          _showModalPickerHu(context);
        },
        child: Center(child: Text(str)),
      ),
    );
  }

  Widget _DataArea() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _getDataRaisedButton("${_selectedHu}符"),
          _getDataRaisedButton("${_selectedHan}翻"),
        ],
      ),
    );
  }

  void _handlePressed() {
    setState(() {
      this._hu = _selectedHu;
      this._han = _selectedHan;
      fetchPosts(this._hu, this._han);
    });
  }

  Widget _ButtonArea() {
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
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
      ),
    );
  }
}
