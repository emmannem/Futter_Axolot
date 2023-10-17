import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModelPage extends StatefulWidget {
  static const String id = "Model_Page";
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  final _formKey = GlobalKey<FormState>();
  String _respuesta = '';
  int? age,
      diabetes,
      bloodpressureproblems,
      anytransplants,
      anychronicdiseases,
      height,
      weight,
      knownallergies,
      historyofcancerinfamily,
      numberofmajorsurgeries;
  TextEditingController _urlController = TextEditingController();
  TextEditingController _shaController = TextEditingController();

  Future<void> _consultarModelo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse(
          'https://medical-service-emmannem.cloud.okteto.net/predict');
      final response = await http.post(url,
          body: json.encode({
            "age": age,
            "diabetes": diabetes,
            "bloodpressureproblems": bloodpressureproblems,
            "anytransplants": anytransplants,
            "anychronicdiseases": anychronicdiseases,
            "height": height,
            "weight": weight,
            "knownallergies": knownallergies,
            "historyofcancerinfamily": historyofcancerinfamily,
            "numberofmajorsurgeries": numberofmajorsurgeries
          }),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        double? price = jsonResponse['premiumPrice'];
        setState(() {
          _respuesta =
              ' ${price?.toStringAsFixed(2)}'; // Convertimos el número a String con dos decimales
        });
      } else {
        setState(() {
          _respuesta =
              'Error al obtener respuesta, revisa que todos los campos sean validos';
        });
      }
    }
  }

  Future<void> _llamadoAPI() async {
    final url =
        Uri.parse('https://api.github.com/repos/emmannem/medical_premium/dispatches');

    final body = json.encode({
      "event_type": "ml_ci_cd",
      "client_payload": {
        "dataseturl":
            _urlController.text, // Obtén el valor desde el controlador
        "sha": _shaController.text, // Obtén el valor desde el controlador
      }
    });

    final headers = {
      'Authorization': dotenv.env['tokenGit']!,
      'Accept': 'application/vnd.github.v3+json',
      'Content-type': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 204) {
      setState(() {
        _respuesta = 'Llamado a API exitoso';
      });
    } else {
      setState(() {
        _respuesta = 'Error al hacer el llamado a la API';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Axolot Machine Learning"),
        backgroundColor: Color(0xFF6739FF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Edad'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => age = int.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Altura'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => height = int.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Peso'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => weight = int.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Número de cirugías mayores'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        numberofmajorsurgeries = int.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'Diabetes'),
                    items: [
                      DropdownMenuItem(value: 0, child: Text("No")),
                      DropdownMenuItem(value: 1, child: Text("Sí")),
                    ],
                    onChanged: (value) => diabetes = value,
                    onSaved: (value) => diabetes = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                        labelText: 'Problemas de presión arterial'),
                    items: [
                      DropdownMenuItem(value: 0, child: Text("No")),
                      DropdownMenuItem(value: 1, child: Text("Sí")),
                    ],
                    onChanged: (value) => bloodpressureproblems = value,
                    onSaved: (value) => bloodpressureproblems = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<int>(
                    decoration:
                        InputDecoration(labelText: 'Alergias conocidas'),
                    items: [
                      DropdownMenuItem(value: 0, child: Text("No")),
                      DropdownMenuItem(value: 1, child: Text("Sí")),
                    ],
                    onChanged: (value) => knownallergies = value,
                    onSaved: (value) => knownallergies = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<int>(
                    decoration:
                        InputDecoration(labelText: 'Cualquier trasplante'),
                    items: [
                      DropdownMenuItem(value: 0, child: Text("No")),
                      DropdownMenuItem(value: 1, child: Text("Sí")),
                    ],
                    onChanged: (value) => anytransplants = value,
                    onSaved: (value) => anytransplants = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                        labelText: 'Cualquier enfermedad crónica'),
                    items: [
                      DropdownMenuItem(value: 0, child: Text("No")),
                      DropdownMenuItem(value: 1, child: Text("Sí")),
                    ],
                    onChanged: (value) => anychronicdiseases = value,
                    onSaved: (value) => anychronicdiseases = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                        labelText: 'Historia del cáncer en la familia'),
                    items: [
                      DropdownMenuItem(value: 0, child: Text("No")),
                      DropdownMenuItem(value: 1, child: Text("Sí")),
                    ],
                    onChanged: (value) => historyofcancerinfamily = value,
                    onSaved: (value) => historyofcancerinfamily = value,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _consultarModelo,
                  child: const Text('Consultar Modelo'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6739FF),
                    padding:
                        EdgeInsets.symmetric(horizontal: 125, vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF6739FF),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Predicción: $_respuesta',
                    style: TextStyle(
                      color:
                          Colors.white, // Texto en blanco para mejor contraste
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller:
                        _shaController, // Asociar el controlador al campo
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) {
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller:
                        _urlController, // Asociar el controlador al campo
                    decoration: InputDecoration(labelText: 'URL'),
                    // No establecer el keyboardType, ya que es un campo de URL
                    onSaved: (value) {
                    },
                  ),
                ),
                  ElevatedButton(
                  onPressed: _llamadoAPI,
                  child: const Text('Reentrenar Modelo'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6739FF),
                    padding:
                        EdgeInsets.symmetric(horizontal: 125, vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(_respuesta),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
