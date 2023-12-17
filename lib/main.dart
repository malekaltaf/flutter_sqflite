import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskmanager/sql_helper.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() {
  sqfliteFfiInit();
  // Change default factory on the web
  databaseFactory = databaseFactoryFfiWeb;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 141, 212)),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'User Management'),
      home: HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _refreshJournals();
    print('..number of item ${_journals.length}');
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
    print('..number of item ${_journals.length}');
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted a UserData!'),
    ));
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final exisitingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = exisitingJournal['title'];
      _descriptionController.text = exisitingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Name:'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: 'Email:'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addItem();
                    }
                    if (id != null) {
                      await _updateItem(id);
                    }

                    _titleController.text = "";
                    _descriptionController.text = "";

                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Create New' : 'Update'),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('User Management'),
      ),
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showForm(_journals[index]['id']),
                  ),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(_journals[index]['id'])),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _showForm(null)),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
