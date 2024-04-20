import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewUserPage extends StatelessWidget {
  final nombreController = TextEditingController();
  final AlbumController = TextEditingController();
  final AnioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/barra.png'), // Ajusta la ruta de la imagen según la ubicación real
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Contenido de la página
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 200),
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de la banda',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: AlbumController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Álbum',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: AnioController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Año de publicación',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      'nombre': nombreController.text,
                      'Album': AlbumController.text,
                      'Anio': int.parse(AnioController.text),
                      'votos': 0, // Inicializamos votos en 0
                    };

                    final instance = FirebaseFirestore.instance;
                    await instance.collection('bandasderock').add(data);

                    Navigator.pop(context);
                  },
                  child: Text('Agregar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
