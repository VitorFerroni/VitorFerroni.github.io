import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart'; // Adicione esta linha

class PlanetFormScreen extends StatefulWidget {
  final Planet? planet;

  const PlanetFormScreen({super.key, this.planet});

  @override
  // ignore: library_private_types_in_public_api
  _PlanetFormScreenState createState() => _PlanetFormScreenState();
}

class _PlanetFormScreenState extends State<PlanetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _distance;
  late double _size;
  String? _nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planet == null ? 'Adicionar Planeta' : 'Editar Planeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.planet?.name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do planeta';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: widget.planet?.distance.toString(),
                decoration: InputDecoration(labelText: 'Distância do Sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Por favor, insira uma distância válida';
                  }
                  return null;
                },
                onSaved: (value) {
                  _distance = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: widget.planet?.size.toString(),
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Por favor, insira um tamanho válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _size = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: widget.planet?.nickname,
                decoration: InputDecoration(labelText: 'Apelido'),
                onSaved: (value) {
                  _nickname = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.planet == null) {
                      DatabaseHelper().insertPlanet(Planet(name: _name, distance: _distance, size: _size, nickname: _nickname));
                    } else {
                      DatabaseHelper().updatePlanet(Planet(id: widget.planet!.id, name: _name, distance: _distance, size: _size, nickname: _nickname));
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.planet == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}