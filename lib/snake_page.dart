import 'package:flutter/material.dart';

const _count = 50;

class SnakePage extends StatefulWidget {
  const SnakePage({super.key});

  @override
  State<SnakePage> createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  _Snake? _snake;
  bool _isRunning = false;

  void _start() {
    setState(() {
      _snake = _Snake();
      _isRunning = true;
    });
    _move();
  }

  // void _stop() {
  //   setState(() {
  //     _isRunning = false;
  //   });
  // }

  // void _resume() {
  //   setState(() {
  //     _isRunning = true;
  //   });
  //   _move();
  // }

  void _move() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _snake!.move();
        print('moving');
      });
      return _isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Big Snake")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _count,
                mainAxisSpacing: 0.0,
              ),
              itemCount: _count * _count,
              itemBuilder: (_, i) {
                final dx = i % _count;
                final dy = i ~/ _count;
                // print('x:$dx, y:$dy');
                final isActive =
                    _snake != null ? _snake!.isPartOfBody(dx, dy) : false;

                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.transparent,
                    // border: Border.all(
                    //   width: 1.0,
                    //   color: Colors.black,
                    // ),
                  ),
                );
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _start,
                  child: const Text('Start'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _snake!.turnUp();
              },
              child: const Text('^'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _snake!.turnLeft();
                  },
                  child: const Text('<'),
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () {
                    _snake!.turnRight();
                  },
                  child: const Text('>'),
                ),
                // ElevatedButton(
                //   onPressed: _stop,
                //   child: const Text('Stop'),
                // ),
                // ElevatedButton(
                //   onPressed: _resume,
                //   child: const Text('Resume'),
                // ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _snake!.turnDown();
              },
              child: const Text('v'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnakeBody {
  _SnakeBody(this.dx, this.dy);
  late int dx;
  late int dy;

  void updatePosition() {
    dx++;
  }
}

class _Snake {
  _Direction _direction = _Direction.down;
  List<_SnakeBody> _body = [
    _SnakeBody(0, 8),
    _SnakeBody(0, 7),
    _SnakeBody(0, 6),
    _SnakeBody(0, 5),
    _SnakeBody(0, 4),
    _SnakeBody(0, 3),
    _SnakeBody(0, 2),
    _SnakeBody(0, 1),
    _SnakeBody(0, 0),
  ];

  // void grow(_SnakeBody body) {
  //   _body.add(body);
  // }

  bool isPartOfBody(int dx, int dy) {
    for (final e in _body) {
      if (e.dx == dx && e.dy == dy) {
        return true;
      }
    }
    return false;
  }

  void move() {
    int dx = _body.first.dx;
    int dy = _body.first.dy;

    switch (_direction) {
      case _Direction.up:
        dy--;
        break;
      case _Direction.down:
        dy++;
        break;
      case _Direction.left:
        dx--;
        break;
      case _Direction.right:
        dx++;
        break;
    }

    if (dy >= _count) {
      dy = 0;
    } else if (dy < 0) {
      dy = _count - 1;
    } else if (dx >= _count) {
      dx = 0;
    } else if (dx < 0) {
      dx = _count - 1;
    }
    _body.insert(0, _SnakeBody(dx, dy));
    _body.removeLast();
  }

  void turnUp() {
    if (_direction == _Direction.left || _direction == _Direction.right) {
      _direction = _Direction.up;
    }
  }

  void turnDown() {
    if (_direction == _Direction.left || _direction == _Direction.right) {
      _direction = _Direction.down;
    }
  }

  void turnLeft() {
    if (_direction == _Direction.up || _direction == _Direction.down) {
      _direction = _Direction.left;
    }
  }

  void turnRight() {
    if (_direction == _Direction.up || _direction == _Direction.down) {
      _direction = _Direction.right;
    }
  }
}

enum _Direction {
  up,
  down,
  left,
  right;
}
