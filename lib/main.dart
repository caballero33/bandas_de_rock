import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'new_user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Bandas de Rock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void deleteUser(String userId) async {
    await firestore.collection('bandasderock').doc(userId).delete();
  }

  void voteForBand(String bandId) async {
    await firestore.collection('bandasderock').doc(bandId).update({
      'votos': FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('bandasderock').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listaBandas = snapshot.data!.docs;

            return ListView.builder(
              itemCount: listaBandas.length,
              itemBuilder: (context, index) {
                final banda = listaBandas[index];
                return ListTile(
                  title: Text(banda['nombre']),
                  subtitle: Text(banda['Album']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${banda['Anio']}'),
                      SizedBox(width: 8), // Espacio entre el año y los votos
                      Text('Votos: ${banda['votos'] ?? 0}'), // Mostrar votos
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () => voteForBand(banda.id),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewUserPage()),
          );
        },
        tooltip: 'Nueva Banda',
        child: Icon(Icons.add),
      ),
    );
  }
}
