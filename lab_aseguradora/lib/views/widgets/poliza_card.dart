import 'package:flutter/material.dart';
import 'package:lab_aseguradora/models/poliza.dart';

class PolizaCard extends StatelessWidget {
  final Poliza poliza;

  const PolizaCard(this.poliza, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poliza.propietario,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Modelo: ${poliza.modeloAuto}'),
            Text('Valor auto: \$${poliza.valorAuto}'),
            Text('Accidentes: ${poliza.accidentes}'),
            const Divider(),
            Text(
              'Costo total: \$${poliza.costoTotal}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
