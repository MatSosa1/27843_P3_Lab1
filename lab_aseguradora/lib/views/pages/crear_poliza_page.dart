import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lab_aseguradora/models/automovil.dart';
import 'package:lab_aseguradora/models/propietario.dart';
import 'package:lab_aseguradora/models/seguro.dart';
import '../providers/poliza_provider.dart';

class CrearPolizaPage extends ConsumerStatefulWidget {
  const CrearPolizaPage({super.key});

  @override
  ConsumerState<CrearPolizaPage> createState() => _CrearPolizaPageState();
}

class _CrearPolizaPageState extends ConsumerState<CrearPolizaPage> {
  final _formKey = GlobalKey<FormState>();

  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final valorCtrl = TextEditingController();
  final accidentesCtrl = TextEditingController();

  String modeloAuto = 'Modelo C';
  String rangoEdad = '55';

  @override
  void dispose() {
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    edadCtrl.dispose();
    valorCtrl.dispose();
    accidentesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(polizaLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Póliza'),
        backgroundColor: const Color(0xFF009688),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _input(nombreCtrl, 'Nombre propietario'),
              const SizedBox(height: 12),

              _input(apellidoCtrl, 'Apellido propietario'),
              const SizedBox(height: 12),

              _input(edadCtrl, 'Edad propietario',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              _input(valorCtrl, 'Valor del automovil',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),

              const Text('Modelo de auto:',
                  style: TextStyle(fontWeight: FontWeight.w500)),

              _radioModelo('Modelo A'),
              _radioModelo('Modelo B'),
              _radioModelo('Modelo C'),

              const SizedBox(height: 20),

              _input(accidentesCtrl, 'Número de accidentes',
                  keyboardType: TextInputType.number),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009688),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('CREAR PÓLIZA'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) =>
          v == null || v.isEmpty ? 'Campo obligatorio' : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _radioModelo(String value) {
    return RadioListTile(
      title: Text(value),
      value: value,
      groupValue: modeloAuto,
      activeColor: const Color(0xFF009688),
      onChanged: (v) => setState(() => modeloAuto = v!),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      ref.read(polizaLoadingProvider.notifier).state = true;

      final controller = ref.read(polizaControllerProvider);

      await controller.crearPoliza(
        propietario: Propietario(
          nombre: nombreCtrl.text,
          apellido: apellidoCtrl.text,
          edad: int.parse(edadCtrl.text),
        ),
        automovil: Automovil(
          modelo: modeloAuto,
          valor: double.parse(valorCtrl.text),
          accidentes: int.parse(accidentesCtrl.text),
          propietarioId: '',
        ),
        seguro: Seguro(
          costoTotal: 1200,
          automovilId: '',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Póliza creada con éxito')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      ref.read(polizaLoadingProvider.notifier).state = false;
    }
  }
}
