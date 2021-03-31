import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flip_card/flip_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      defaultBrightness: Brightness.light,
      builder: (context, _brightness) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => RandomWords(),
            '/selected': (context) => Pictures(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Startup Name Generator',
          theme: ThemeData(primarySwatch: Colors.blue, brightness: _brightness),
        );
      },
    );
  }
}

class ThemeChanger extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;

  ThemeChanger({this.builder, this.defaultBrightness});
  @override
  _ThemeChangerState createState() => _ThemeChangerState();

  static _ThemeChangerState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_ThemeChangerState>());
  }
}

class _ThemeChangerState extends State<ThemeChanger> {
  Brightness _brightness;
  @override
  void initState() {
    super.initState();
    _brightness = widget.defaultBrightness;

    if (mounted) setState(() {});
  }

  void changeTheme() {
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  Brightness getCurrentTheme() {
    return _brightness;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}

final List<WordPair> _suggestions = <WordPair>[];
final _saved = Set<WordPair>();

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  void _changeTheme() {
    ThemeChanger.of(context).changeTheme();
    // setState(() {

    // });
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(children: <Widget>[
        Positioned(
          bottom: 10.0,
          right: 40.0,
          child: FloatingActionButton.extended(
            onPressed: _changeTheme,
            label: Text('Switch Theme'),
            icon: Icon(Icons.navigation),
            backgroundColor: Colors.blue,
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: 50.0,
          child: FloatingActionButton(
            heroTag: 'close',
            onPressed: () {
              if (_saved.length == 4)
                Navigator.pushNamed(context, '/selected');
              else {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                          child: Text('Warning'),
                        ),
                        content: Text("Select 4 favourites to go to next page"),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            child: Icon(Icons.forward),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ]),
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list_alt), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

class Pictures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = _saved;
    var a = _saved.elementAt(0);
    var b = _saved.elementAt(1);
    var c = _saved.elementAt(2);
    var d = _saved.elementAt(3);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your 4 Choices'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                //ROW 1
                children: [
                  FlipCard(
                    front: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('asset/1.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.all(25.0),
                    ),
                    back: Container(
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.all(25.0),
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          a.asPascalCase,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  FlipCard(
                    front: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('asset/2.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.all(25.0),
                    ),
                    back: Container(
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.all(25.0),
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          b.asPascalCase,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(//ROW 2
                  children: [
                FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('asset/5.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    height: 200,
                    width: 200,
                    margin: EdgeInsets.all(25.0),
                  ),
                  back: Container(
                    height: 200,
                    width: 200,
                    margin: EdgeInsets.all(25.0),
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        c.asPascalCase,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                FlipCard(
                  front: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('asset/4.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    height: 200,
                    width: 200,
                    margin: EdgeInsets.all(25.0),
                  ),
                  back: Container(
                    height: 200,
                    width: 200,
                    margin: EdgeInsets.all(25.0),
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        d.asPascalCase,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ]),
              FloatingActionButton.extended(
                label: Text('GoBack'),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
