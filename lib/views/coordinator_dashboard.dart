import 'dart:html';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Coordinador"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
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
  const UserSupportManagement({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ExpansionTile(
        title: const Text('Añadir Usuario'),
        childrenPadding: const EdgeInsets.all(8),
        children: [
          TextFormField(decoration: const InputDecoration(labelText: 'ID')),
          TextFormField(decoration: const InputDecoration(labelText: 'Nombre')),
          TextFormField(decoration: const InputDecoration(labelText: 'Email')),
          TextFormField(
              decoration: const InputDecoration(labelText: 'Contraseña')),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Guardar Usuario'))
        ],
      ),
      ExpansionTile(
          title: const Text('Editar Usuario'),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'ID')),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre')),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('Guardar Cambios'))
          ]),
      ExpansionTile(
          title: const Text('Eliminar Usuario'),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'ID')),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('Eliminar Usuario'))
          ])
    ]);
  }
}

class ClientManagement extends StatelessWidget {
  const ClientManagement({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ExpansionTile(
        title: const Text('Añadir Cliente'),
        childrenPadding: const EdgeInsets.all(8),
        children: [
          TextFormField(decoration: const InputDecoration(labelText: 'ID')),
          TextFormField(decoration: const InputDecoration(labelText: 'Nombre')),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Guardar Cliente'))
        ],
      ),
      ExpansionTile(
          title: const Text('Editar Cliente'),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'ID')),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('Guardar Cambios'))
          ]),
      ExpansionTile(
          title: const Text('Eliminar Cliente'),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'ID')),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('Eliminar Cliente'))
          ])
    ]);
  }
}

class WorkReportEvaluation extends StatelessWidget {
  const WorkReportEvaluation({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const Text('Evaluación de Informes de Trabajo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Id del Informe')),
        Container(
          alignment: Alignment.center,
          child: const Text('Preview del Informe'),
        ),
        const Text('Evaluación',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Center(
            child: RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {},
        ))
      ],
    );
  }
}
