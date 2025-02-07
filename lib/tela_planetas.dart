import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart'; // Adicione esta linha
import 'tela_formulario.dart';

class PlanetListScreen extends StatefulWidget {
  const PlanetListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlanetListScreenState createState() {
    return _PlanetListScreenState();
  }
}

class _PlanetListScreenState extends State<PlanetListScreen> {
  late Future<List<Planet>> planets;

  @override
  void initState() {
    super.initState();
    planets = DatabaseHelper().getPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planetas'),
      ),
      body: FutureBuilder<List<Planet>>(
        future: planets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum planeta cadastrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Planet planet = snapshot.data![index];
                return ListTile(
                  title: Text(planet.name),
                  subtitle: Text(planet.nickname ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanetFormScreen(planet: planet),
                      ),
                    ).then((value) {
                      setState(() {
                        planets = DatabaseHelper().getPlanets();
                      });
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanetFormScreen(),
            ),
          ).then((value) {
            setState(() {
              planets = DatabaseHelper().getPlanets();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}