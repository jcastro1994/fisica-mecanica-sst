import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const FisicaSSTApp());
}

class FisicaSSTApp extends StatelessWidget {
  const FisicaSSTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Física Mecánica SST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  String modulo = 'MRU';
  String resultado = '';

  final Map<String, TextEditingController> campos = {
    'distancia': TextEditingController(text: '100'),
    'tiempo': TextEditingController(text: '5'),
    'vi': TextEditingController(text: '10'),
    'aceleracion': TextEditingController(text: '2'),
    'altura': TextEditingController(text: '20'),
    'gravedad': TextEditingController(text: '9.8'),
    'velocidad': TextEditingController(text: '36'),
    'reaccion': TextEditingController(text: '1.5'),
    'frenado': TextEditingController(text: '4'),
  };

  double numero(String clave) {
    final valor = double.tryParse(
      campos[clave]!.text.trim().replaceAll(',', '.'),
    );

    if (valor == null || !valor.isFinite) {
      throw const FormatException(
        'Introduce números válidos en todos los campos.',
      );
    }

    return valor;
  }

  String f(double valor) => valor.toStringAsFixed(2);

  void calcular() {
    try {
      late String texto;

      switch (modulo) {
        case 'MRU':
          final d = numero('distancia');
          final t = numero('tiempo');

          if (d < 0 || t <= 0) {
            throw const FormatException(
              'La distancia debe ser positiva o cero '
              'y el tiempo debe ser mayor que cero.',
            );
          }

          final v = d / t;

          texto = 'VELOCIDAD: ${f(v)} m/s\n'
              'VELOCIDAD: ${f(v * 3.6)} km/h\n\n'
              'Fórmula: v = d / t\n'
              'Operación: $d / $t = ${f(v)} m/s';
          break;

        case 'MRUA':
          final vi = numero('vi');
          final a = numero('aceleracion');
          final t = numero('tiempo');

          if (t < 0) {
            throw const FormatException(
              'El tiempo no puede ser negativo.',
            );
          }

          final vf = vi + a * t;
          final d = vi * t + 0.5 * a * t * t;

          texto = 'VELOCIDAD FINAL: ${f(vf)} m/s\n'
              'DESPLAZAMIENTO: ${f(d)} m\n\n'
              'Fórmula: vf = vi + a × t\n'
              'vf = $vi + ($a × $t) = ${f(vf)} m/s\n\n'
              'Fórmula: d = vi × t + ½ × a × t²\n'
              'Desplazamiento = ${f(d)} m';
          break;

        case 'Caída libre':
          final h = numero('altura');
          final g = numero('gravedad');

          if (h < 0 || g <= 0) {
            throw const FormatException(
              'La altura no puede ser negativa '
              'y la gravedad debe ser mayor que cero.',
            );
          }

          final t = math.sqrt(2 * h / g);
          final v = math.sqrt(2 * g * h);

          texto = 'TIEMPO DE CAÍDA: ${f(t)} s\n'
              'VELOCIDAD DE IMPACTO: ${f(v)} m/s\n'
              'VELOCIDAD DE IMPACTO: ${f(v * 3.6)} km/h\n\n'
              'Fórmula: t = √(2h / g)\n'
              'Fórmula: v = √(2gh)\n\n'
              'Se supone que el objeto parte del reposo '
              'y se desprecia la resistencia del aire.';
          break;

        case 'SST - Frenado':
          final kmh = numero('velocidad');
          final tr = numero('reaccion');
          final a = numero('frenado');

          if (kmh < 0 || tr < 0 || a <= 0) {
            throw const FormatException(
              'Revisa la velocidad, el tiempo de reacción '
              'y la desaceleración.',
            );
          }

          final v = kmh / 3.6;
          final dr = v * tr;
          final df = v * v / (2 * a);
          final total = dr + df;

          texto = 'VELOCIDAD: ${f(v)} m/s\n'
              'DISTANCIA DE REACCIÓN: ${f(dr)} m\n'
              'DISTANCIA DE FRENADO: ${f(df)} m\n'
              'DISTANCIA TOTAL: ${f(total)} m\n\n'
              'Reacción: d = v × t\n'
              'Frenado: d = v² / (2 × a)\n'
              'Total = reacción + frenado\n\n'
              'Resultado teórico: no contempla todas '
              'las condiciones reales de la vía.';
          break;
      }

      setState(() => resultado = texto);
    } on FormatException catch (e) {
      setState(() => resultado = e.message);
    }
  }

  List<Widget> camposActuales() {
    switch (modulo) {
      case 'MRU':
        return [
          campo('Distancia recorrida', 'distancia', 'metros'),
          campo('Tiempo empleado', 'tiempo', 'segundos'),
        ];

      case 'MRUA':
        return [
          campo('Velocidad inicial', 'vi', 'm/s'),
          campo('Aceleración', 'aceleracion', 'm/s²'),
          campo('Tiempo transcurrido', 'tiempo', 'segundos'),
        ];

      case 'Caída libre':
        return [
          campo('Altura de caída', 'altura', 'metros'),
          campo('Gravedad', 'gravedad', 'm/s²'),
        ];

      default:
        return [
          campo('Velocidad del vehículo', 'velocidad', 'km/h'),
          campo('Tiempo de reacción', 'reaccion', 'segundos'),
          campo('Desaceleración', 'frenado', 'm/s²'),
        ];
    }
  }

  Widget campo(String etiqueta, String clave, String unidad) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: campos[clave],
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(
          labelText: etiqueta,
          suffixText: unidad,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final controlador in campos.values) {
      controlador.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Física Mecánica SST'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(
                Icons.science,
                size: 60,
                color: Color(0xFF1565C0),
              ),
              const SizedBox(height: 12),
              const Text(
                'Calculadora de Física',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aprende, calcula y aplica la física '
                'a la prevención de riesgos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Selecciona un módulo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: modulo,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          'MRU',
                          'MRUA',
                          'Caída libre',
                          'SST - Frenado',
                        ].map((nombre) {
                          return DropdownMenuItem(
                            value: nombre,
                            child: Text(nombre),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          if (valor == null) return;
                          setState(() {
                            modulo = valor;
                            resultado = '';
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ...camposActuales(),
                      FilledButton.icon(
                        onPressed: calcular,
                        icon: const Icon(Icons.calculate),
                        label: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Calcular'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (resultado.isNotEmpty) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultado y procedimiento',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 28),
                        SelectableText(
                          resultado,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Herramienta educativa. Los cálculos de SST '
                'son teóricos y no sustituyen una evaluación '
                'profesional de riesgos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
