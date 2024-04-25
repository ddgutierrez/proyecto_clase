import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CoordinatorDashboard extends StatefulWidget {
  const CoordinatorDashboard({super.key});
  @override
  State<CoordinatorDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<CoordinatorDashboard> {
  Widget layout({required int index}) {
    switch (index) {
      case 0:
        {
          return ClientManagement();
        }
      case 1:
        {
          return UserSupportManagement();
        }
      case 2:
        {
          return WorkReportEvaluation();
        }
      default:
        {
          return ClientManagement();
        }
    }
  }

  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Coordinador"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width > 500,
            backgroundColor: Colors.grey.withOpacity(0.5),
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.account_box),
                  label: Text('Aministrar Usuarios')),
              NavigationRailDestination(
                  icon: Icon(Icons.support_agent),
                  label: Text('Administrar Usuarios\nde Soporte')),
              NavigationRailDestination(
                  icon: Icon(Icons.rate_review),
                  label: Text('Evaluar Reportes'))
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) => setState(() {
              _selectedIndex = value;
            }),
          ),
          Expanded(child: layout(index: _selectedIndex))
        ],
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
            Text('Gestión de Soporte de Usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Text('Gestión de Clientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Text('Evaluación de Informes de Trabajo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Usuario 1'),
              subtitle: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
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
