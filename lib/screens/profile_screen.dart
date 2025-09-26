import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, String>> activeHabits = [
    {"title": "Hacer ejercicio", "frequency": "Diario"},
    {"title": "Leer 20 minutos", "frequency": "Diario"},
    {"title": "Beber agua", "frequency": "Cada 3 horas"},
  ];

  // Guardamos qué días se han marcado por hábito
  final Map<String, Set<DateTime>> habitCompletion = {};

  @override
  void initState() {
    super.initState();
    for (var habit in activeHabits) {
      habitCompletion[habit["title"]!] = {};
    }
  }

  // Función para abrir el calendario
  void _showHabitCalendar(String habitTitle) {
    DateTime focusedDay = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Calendario - $habitTitle"),
              content: SizedBox(
                width: double.maxFinite, // 👈 asegura ancho
                height: 400,             // 👈 asegura alto
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) {
                    return habitCompletion[habitTitle]!
                        .any((d) => isSameDay(d, day));
                  },
                  onDaySelected: (selected, focused) {
                    setStateDialog(() {
                      if (habitCompletion[habitTitle]!
                          .any((d) => isSameDay(d, selected))) {
                        habitCompletion[habitTitle]!
                            .removeWhere((d) => isSameDay(d, selected));
                      } else {
                        habitCompletion[habitTitle]!.add(selected);
                      }
                      focusedDay = focused;
                    });
                    setState(() {}); // refrescar pantalla principal
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurple.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar",
                      style: TextStyle(color: Colors.deepPurple)),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Colors.deepPurple.shade900,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFBA68C8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Datos del usuario
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 70, color: Colors.deepPurple),
                ),
                const SizedBox(height: 20),
                const Text("Nombre de Usuario",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("Correo: usuario@ejemplo.com",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: const Icon(Icons.settings, color: Colors.white),
                  label: const Text("Configuración",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Lista de hábitos
            const Text("Hábitos Activos",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ...activeHabits.map((habit) {
              return Card(
                color: Colors.deepPurple.shade100.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.check_circle,
                      color: Colors.deepPurple),
                  title: Text(habit["title"]!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text("Frecuencia: ${habit["frequency"]}"),
                  trailing: const Icon(Icons.calendar_month,
                      color: Colors.deepPurple),
                  onTap: () => _showHabitCalendar(habit["title"]!),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
