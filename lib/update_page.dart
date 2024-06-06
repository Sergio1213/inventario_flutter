import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './util/ipconfig.dart';

class UpdatePage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();

  Future<void> _actualizarProducto(BuildContext context) async {
    final String id = _idController.text;
    final String nuevoNombre = _nombreController.text;

    if (id.isEmpty || nuevoNombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse("http://$ip:1337/api/products/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": {"nombre": nuevoNombre}
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto actualizado exitosamente')),
        );
      } else {
        throw Exception('Error al actualizar el producto');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar producto: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Producto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID para actualizar',
              ),
            ),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Cambiar nombre',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _actualizarProducto(context);
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
