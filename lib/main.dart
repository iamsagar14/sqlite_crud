import 'package:flutter/material.dart';
import 'models/contact.dart';
import 'models/utilies/database_helper.dart';

const darkBlueColor = Color(0Xff486579);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqlite Crud',
      theme: ThemeData(
        primaryColor: darkBlueColor,
      ),
      home: const MyHomePage(title: 'Sqlite Crud'),
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
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  late DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlMobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Center(
            child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
            _list(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ctrlName,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'enter you name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onSaved: (val) => setState(() {
                  _contact.name = val;
                }),
                validator: (val) =>
                    (val!.isEmpty ? 'This field is required ' : null),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _ctrlMobile,
                decoration: InputDecoration(
                  hintText: 'Enter you phone number ',
                  labelText: 'Mobile Number ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onSaved: (val) => setState(() {
                  _contact.mobile = val;
                }),
                validator: (val) => (val!.length < 10
                    ? 'Atleast 10 character required '
                    : null),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.blue,
                  elevation: 5.0,
                  onPressed: () {
                    _onsubmit();
                  },
                  child: const Text(
                    'submit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  _refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContact();
    setState(() {
      _contacts = x;
    });
  }

  _onsubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form?.save();
      if (_contact.id == null) {
        await _dbHelper.insertContact(_contact);
      } else {
        await _dbHelper.updatetContact(_contact);
      }
      _refreshContactList();
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      _ctrlName.clear();
      _ctrlMobile.clear();
      _contact.id = null;
    });
  }

  _list() => Expanded(
          child: Card(
        margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: darkBlueColor,
                    size: 40.0,
                  ),
                  title: Text(
                    _contacts[index].name.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(_contacts[index].mobile!),
                  onTap: () {
                    setState(() {
                      _contact = _contacts[index];
                      _ctrlName.text = _contacts[index].name!;
                      _ctrlMobile.text = _contacts[index].mobile!;
                    });
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete_sweep),
                    color: Colors.red,
                    onPressed: () async {
                      await _dbHelper.deleteContact(_contacts[index].id!);
                      _resetForm();
                      _refreshContactList();
                    },
                  ),
                )
              ],
            );
          },
          itemCount: _contacts.length,
        ),
      ));
}
