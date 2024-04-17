import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CoordinatorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Coordinador"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Administrar Usuarios y Clientes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            UserSupportManagement(),
            ClientManagement(),
            WorkReportEvaluation(),
          ],
        ),
      ),
    );
  }
}

class UserSupportManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Gestión de Soporte de Usuario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(decoration: InputDecoration(labelText: 'ID')),
            TextFormField(decoration: InputDecoration(labelText: 'Nombre')),
            TextFormField(decoration: InputDecoration(labelText: 'Email')),
            TextFormField(decoration: InputDecoration(labelText: 'Contraseña')),
            ElevatedButton(onPressed: () {}, child: Text('Guardar Usuario'))
          ],
        ),
      ),
    );
  }
}

class ClientManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Gestión de Clientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(decoration: InputDecoration(labelText: 'ID')),
            TextFormField(decoration: InputDecoration(labelText: 'Nombre')),
            ElevatedButton(onPressed: () {}, child: Text('Guardar Cliente'))
          ],
        ),
      ),
    );
  }
}

class WorkReportEvaluation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Evaluación de Informes de Trabajo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Usuario 1'),
              subtitle: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
