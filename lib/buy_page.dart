import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './util/ipconfig.dart';

class BuyPage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  Future<void> _surtirProducto(BuildContext context) async {
    final String id = _idController.text;
    final String cantidad = _cantidadController.text;

    if (id.isEmpty || cantidad.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    try {
      print("Realizando solicitud GET...");
      final response = await http.get(
        Uri.parse("http://$ip:1337/api/products/$id"),
      );
      print("Respuesta recibida: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> productoData = jsonDecode(response.body);
        final producto = productoData['data'];
        final stockActual = int.parse(producto['attributes']['stock']);

        final int cantidadSurtir = int.parse(cantidad);
        final nuevoStock = stockActual + cantidadSurtir;

        final updateResponse = await http.put(
          Uri.parse("http://$ip:1337/api/products/$id"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "data": {"stock": nuevoStock.toString()}
          }),
        );

        if (updateResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Surtido realizado exitosamente')),
          );
        } else {
          throw Exception('Error al actualizar el stock del producto');
        }
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El producto con el ID dado no existe')),
        );
      } else {
        throw Exception('Error al obtener el producto');
      }
    } catch (error) {
      print('Error al surtir producto: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al surtir producto: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surtir Producto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID del producto',
              ),
            ),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad a surtir',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _surtirProducto(context);
              },
              child: Text('Surtir'),
            ),
          ],
        ),
      ),
    );
  }
}
