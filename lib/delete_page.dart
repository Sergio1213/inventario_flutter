import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import './util/ipconfig.dart';

class DeletePage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();

  Future<void> deleteItem(BuildContext context, String id) async {
    // Asegúrate de definir tu IP aquí
    final Uri url = Uri.parse("http://$ip:1337/api/products/$id");

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Si la eliminación es exitosa, procesa la respuesta
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto Eliminado exitosamente')),
        );
        print('Eliminación exitosa');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el producto')),
        );
        // Si la eliminación falla, lanza una excepción.
        throw Exception('Error al eliminar el producto');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID para eliminar',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String id = _idController.text;
                if (id.isNotEmpty) {
                  deleteItem(context, id);
                } else {
                  print('Por favor, introduce un ID válido');
                }
              },
              child: Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}
