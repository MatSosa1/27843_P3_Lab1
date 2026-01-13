import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lab_aseguradora/views/providers/poliza_provider.dart';
import 'package:lab_aseguradora/views/widgets/poliza_card.dart';

class ListarPolizasPage extends ConsumerWidget {
  const ListarPolizasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polizasAsync = ref.watch(polizasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pólizas'),
        backgroundColor: const Color(0xFF009688),
      ),
      body: polizasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('❌ Error: $e')),
        data: (polizas) => polizas.isEmpty
            ? const Center(child: Text('No hay pólizas registradas'))
            : ListView.builder(
                itemCount: polizas.length,
                itemBuilder: (_, i) => PolizaCard(polizas[i]),
              ),
      ),
    );
  }
}
