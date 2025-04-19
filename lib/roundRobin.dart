import 'package:flutter/material.dart';
import 'roundRobinScheduler.dart';
class RoundRobinPage extends StatefulWidget {
  const RoundRobinPage({super.key});

  @override
  State<RoundRobinPage> createState() => _RoundRobinPageState();
}

class _RoundRobinPageState extends State<RoundRobinPage> {
  List<Map<String, TextEditingController>> processes = [];
  final TextEditingController quantum = TextEditingController();
  @override
  void initState() {
    super.initState();
    addProcess();
  }

  void addProcess() {
    setState(() {
      processes.add({
        "PID": TextEditingController(),
        "Arrival": TextEditingController(),
        "Burst": TextEditingController(),
        "Priority": TextEditingController(),
      });
    });
  }

  void startsimulation() {
    int timeQuantum = int.tryParse(quantum.text) ?? 1;
    List<Map<String, dynamic>> processList = processes.map((process) {
      return {
        "PID": process["PID"]!.text,
        "Arrival": int.tryParse(process["Arrival"]!.text) ?? 0,
        "Burst": int.tryParse(process["Burst"]!.text) ?? 1,
      };
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimulationResult(
            processList: processList, timeQuantum: timeQuantum),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Round Robin"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Enter the Time Quantum : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 20, height: 20),
            SizedBox(
              width: 200,
              height: 30,
              child: TextField(
                controller: quantum,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Time Quantum",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Process ID")),
                      DataColumn(label: Text("Arrival Time")),
                      DataColumn(label: Text("Burst Time")),
                      DataColumn(label: Text("Priority")),
                    ],
                    rows: processes
                        .map(
                          (process) => DataRow(
                            cells: [
                              DataCell(
                                TextField(
                                  controller: process["PID"],
                                  decoration: InputDecoration(hintText: "P1"),
                                ),
                              ),
                              DataCell(TextField(
                                controller: process["Arrival"],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(hintText: "0"),
                              )),
                              DataCell(TextField(
                                controller: process["Burst"],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(hintText: "0"),
                              )),
                              DataCell(TextField(
                                controller: process["Priority"],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(hintText: "1"),
                              )),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: addProcess,
                  icon: Icon(Icons.add),
                  label: Text("Add Process"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                    foregroundColor: Colors.purple[900],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    startsimulation();
                  },
                  child: Text("Start Stimulation"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    
                  ),
                  
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
