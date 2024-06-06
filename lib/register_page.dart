import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './util/ipconfig.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Future<void> _registerProduct() async {
    final String nombre = _nombreController.text;
    final String stock = _stockController.text;

    if (nombre.isEmpty || stock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://${ip}:1337/api/products'), // URL de tu API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'data': {
            'nombre': nombre,
            'stock': int.parse(stock),
          },
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Producto registrado: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto registrado')),
        );
      } else {
        print('Error al registrar producto: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el producto')),
        );
      }
    } catch (error) {
      print('Error al registrar producto: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Producto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Stock',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerProduct,
              child: Text('Registrar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
