import 'package:flutter/material.dart';
import 'models/contact.dart';

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
  final _formKey = GlobalKey<FormState>();

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
  _onsubmit() {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form?.save();
      setState(() {
        _contacts.add(
          Contact(id: null, name: _contact.name, mobile: _contact.mobile),
        );
      });
      form?.reset();
    }
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
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {},
                )
              ],
            );
          },
          itemCount: _contacts.length,
        ),
      ));
}
