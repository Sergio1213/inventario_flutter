import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './util/ipconfig.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final response = await http.get(
        Uri.parse("http://$ip:1337/api/products"), // URL de tu API
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> productos = responseData['data'];
        setState(() {
          _productos = productos;
        });
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (error) {
      print('Error al cargar productos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: _productos.isEmpty
          ? Center(child: Text('No hay productos'))
          : ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final producto = _productos[index];
                final id = producto['id'].toString();
                final atributos = producto['attributes'];
                final nombre = atributos['nombre'];
                final stock = atributos['stock'].toString();

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedCard(
                    nombre: nombre,
                    stock: stock,
                    id: id,
                  ),
                );
              },
            ),
    );
  }
}

class ElevatedCard extends StatelessWidget {
  final String nombre;
  final String stock;
  final String id;

  ElevatedCard({required this.nombre, required this.stock, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Stock: $stock',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ID: $id',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
