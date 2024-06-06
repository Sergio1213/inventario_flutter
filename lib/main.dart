import 'package:flutter/material.dart';
import 'package:flutter_application_1/buy_page.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'delete_page.dart';
import 'update_page.dart';
import 'record_page.dart';
import 'sell_page.dart';
import 'buy_page.dart';
import 'package:http/http.dart' as http; // Importa el paquete http

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter invetario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  final List<Widget> _drawerItems = [
    HomePage(),
    RegisterPage(),
    DeletePage(),
    UpdatePage(),
    RecordPage(),
    SellPage(),
    BuyPage()
  ];

  _getDrawerItemWidget(int pos) {
    return _drawerItems[pos];
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Registrar'),
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar'),
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('Actualizar'),
              onTap: () => _onSelectItem(3),
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Movimientos'),
              onTap: () => _onSelectItem(4),
            ),
            ListTile(
              leading: Icon(Icons.arrow_circle_right),
              title: Text('vender'),
              onTap: () => _onSelectItem(5),
            ),
            ListTile(
              leading: Icon(Icons.arrow_circle_left),
              title: Text('surtir'),
              onTap: () => _onSelectItem(6),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
