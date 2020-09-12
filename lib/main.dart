import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
enum mark {X , O , none}
const stroke_width = 6.0;
const half_stroke_width = stroke_width / 2.0;
const double_stroke_width = stroke_width * 2.0;
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness)=> ThemeData(
        primarySwatch: Colors.teal,
        brightness: brightness,

      ),
      themedWidgetBuilder: (context,theme){
        return MaterialApp(
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: Tictactoe(),
        );
      },
    );
  }
}

class Tictactoe extends StatefulWidget {
  @override
  _TictactoeState createState() => _TictactoeState();
}

class _TictactoeState extends State<Tictactoe> {
  Map<int ,mark> _gamemarks = Map();
  mark _currentmark = mark.O;
  bool isswitched = false;
  List<int> _winningline;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIC-TAC-TOE'),
        actions: [
          Switch(value: isswitched, onChanged: (value){
            Toggletheme();
            setState(() {
              isswitched = value;
            });
          }),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTapUp: (TapUpDetails details){
            setState(() {
              if(_gamemarks.length >= 9 || _winningline!=null){
                _gamemarks = Map<int,mark>();
                _currentmark = mark.O;
                _winningline = null;
              }else{
                _addmark(details.localPosition.dx,details.localPosition.dy);
                _winningline = Getwinningline();
              }
            });
          },
          child: AspectRatio(aspectRatio: 1.0,
            child: Container(
              child: CustomPaint(
                painter: Gamepainter(_gamemarks,_winningline),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addmark(double x,double y){
    double _dividedsize = Gamepainter.getdividedsize();
    bool isabsent = false;
    _gamemarks.putIfAbsent((x ~/ _dividedsize + (y ~/ _dividedsize)*3).toInt(), () { isabsent=true;return _currentmark;});
    if(isabsent) {_currentmark = _currentmark==mark.O ? mark.X: mark.O;}
  }

  void Toggletheme(){
    DynamicTheme.of(context).setBrightness(
      Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark
    );
  }

  List<int> Getwinningline(){
    final winninglines = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6]
    ];
    List<int> winninglinefound;
    winninglines.forEach((winningline) {
      int countnoughts =0;
      int countcrosses = 0;

      winningline.forEach((element) {
        if(_gamemarks[element] == mark.O){
          ++countnoughts;

        }
        else if(_gamemarks[element] == mark.X){
          ++countcrosses;
        }
      });
      if(countcrosses>=3 || countnoughts>=3){
        winninglinefound = winningline;
      }
    });
    return winninglinefound;
  }
}
class Gamepainter extends CustomPainter{
  Map<int,mark> _gamemarks;
  List<int> _winningline;
  static double _dividedsize;
  Gamepainter(this._gamemarks,this._winningline);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final blackpaint = Paint()..style=PaintingStyle.stroke..strokeWidth=stroke_width..color=Colors.black;
    final greenthickpaint = Paint()..style=PaintingStyle.stroke..strokeWidth=double_stroke_width..color=Colors.green;
    final redthickcolor = Paint()..style=PaintingStyle.stroke..strokeWidth=double_stroke_width..color=Colors.red;
    _dividedsize = size.width / 3.0;
    final orangethickpaint = Paint()..style=PaintingStyle.stroke..strokeWidth=(stroke_width)..color=Colors.orange;


    canvas.drawLine(Offset(stroke_width, _dividedsize-half_stroke_width), Offset(size.width-stroke_width, _dividedsize-half_stroke_width), blackpaint);
    canvas.drawLine(Offset(stroke_width, _dividedsize*2-half_stroke_width),Offset(size.width-stroke_width, _dividedsize*2-half_stroke_width), blackpaint);
    canvas.drawLine(Offset( _dividedsize-half_stroke_width, stroke_width), Offset(_dividedsize-half_stroke_width, size.height-stroke_width), blackpaint);
    canvas.drawLine(Offset( _dividedsize*2-half_stroke_width, stroke_width), Offset(_dividedsize*2-half_stroke_width, size.height-stroke_width), blackpaint);

    _gamemarks.forEach((index, Mark) {
      switch(Mark){
        case mark.O:
          Drawnought(canvas, index, greenthickpaint);
          break;
        case mark.X:
          Drawcross(canvas, index, redthickcolor);
          break;
        default:
          break;
      }
    });

    Drawwinningline(canvas,_winningline,orangethickpaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
  static getdividedsize() => _dividedsize;
  void Drawnought(Canvas canvas,int index,Paint paint){
    double left = (index%3) * _dividedsize + double_stroke_width*2;
    double top = (index ~/ 3) * _dividedsize + double_stroke_width*2;
    double noughtsize = _dividedsize - double_stroke_width*4;
    canvas.drawOval(Rect.fromLTWH(left,top,noughtsize,noughtsize), paint);
  }
  void Drawcross(Canvas canvas,int index,Paint paint){
    double x1,y1;
    double x2,y2;

    x1 = (index%3)*_dividedsize + double_stroke_width*2;
    y1 = (index ~/ 3)*_dividedsize + double_stroke_width*2;

    x2 = (index%3 +1)*_dividedsize - double_stroke_width*2;
    y2 = (index ~/ 3 +1)*_dividedsize - double_stroke_width*2;

    canvas.drawLine(Offset(x1,y1), Offset(x2,y2), paint);


    x1 = (index%3 +1)*_dividedsize - double_stroke_width*2;
    y1 = (index ~/ 3)*_dividedsize + double_stroke_width*2;

    x2 = (index%3)*_dividedsize + double_stroke_width*2;
    y2 = (index ~/ 3 +1)*_dividedsize - double_stroke_width*2;

    canvas.drawLine(Offset(x1,y1), Offset(x2,y2), paint);
  }

  void Drawwinningline(Canvas canvas,List<int> winline,Paint paint){
    if(winline == null){return;}
    double x1=0,y1=0;
    double x2=0,y2=0;
    int firstindex = winline.first;
    int lastindex = winline.last;

    if(firstindex%3 == lastindex%3){
      x1 = x2  = firstindex%3 *_dividedsize + _dividedsize/2;
      y1=stroke_width;
      y2=_dividedsize * 3-stroke_width;
    }else if(firstindex~/3 == lastindex~/3){
      x1=stroke_width;
      x2=_dividedsize * 3-stroke_width;
      y1 = y2 = firstindex~/3 *_dividedsize + _dividedsize/2;
    }else{
      if(firstindex==0){
        x1=y1=double_stroke_width;
        x2=y2=_dividedsize*3 - double_stroke_width;
      }else{
        x1 = y2 = _dividedsize*3 - double_stroke_width;
        x2=y1=double_stroke_width;
      }
    }
    canvas.drawLine(Offset(x1,y1), Offset(x2,y2), paint);
  }
}