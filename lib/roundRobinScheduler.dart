import 'package:flutter/material.dart';
import 'dart:async';

class SimulationResult extends StatefulWidget {
  final List<Map<String, dynamic>> processList;
  final int timeQuantum;
  const SimulationResult({required this.processList, required this.timeQuantum});

  @override
  State<SimulationResult> createState() => _SimulationResultState();
}

class _SimulationResultState extends State<SimulationResult> {
  List<Map<String, dynamic>> executionOrder = [];
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> displayedProcesses = [];
  int currentTime = 0;
  double avgTurnaroundTime = 0;
  double avgWaitingTime = 0;
  double avgResponseTime = 0;

  @override
  void initState() {
    super.initState();
    runRoundRobin();
    _animatedGanttChart();
  }

  void runRoundRobin() {
    List<Map<String, dynamic>> queue = List.from(widget.processList);
    queue.sort((a, b) => a["Arrival"].compareTo(b["Arrival"]));
    Map<String, int> remainingBurst = {};
    Map<String, int> startTime = {};
    for (var process in widget.processList) {
      remainingBurst[process["PID"]] = process["Burst"];
      startTime[process["PID"]] = -1;
    }
    while (queue.isNotEmpty) {
      var process = queue.removeAt(0);
      String pid = process["PID"];
      int arrival = process["Arrival"];
      int burst = remainingBurst[pid]!;

      if (currentTime < arrival) {
        currentTime = arrival;
      }

      if (startTime[pid] == -1) {
        startTime[pid] = currentTime;
      }

      int executionTime = burst > widget.timeQuantum ? widget.timeQuantum : burst;
      executionOrder.add({
        "PID": pid,
        "start": currentTime,
        "end": currentTime + executionTime
      });
      currentTime += executionTime;
      remainingBurst[pid] = burst - executionTime;

      if (remainingBurst[pid]! > 0) {
        queue.add(process);
      } else {
        int completionTime = currentTime;
        int turnaroundTime = completionTime - arrival;
        num waitingTime = turnaroundTime - process["Burst"];
        int responseTime = startTime[pid]! - arrival;

        results.add({
          "PID": pid,
          "Completion": completionTime,
          "Turnaround": turnaroundTime,
          "Waiting": waitingTime,
          "Response": responseTime,
        });
      }
    }

   avgTurnaroundTime = results.fold(0.0, (sum, item) => sum + item["Turnaround"]) / results.length;
  avgWaitingTime = results.fold(0.0, (sum, item) => sum + item["Waiting"]) / results.length;
  avgResponseTime = results.fold(0.0, (sum, item) => sum + item["Response"]) / results.length;
  }

  void _animatedGanttChart() async {
    const int delay = 300;
    for (int i = 0; i < executionOrder.length; i++) {
      await Future.delayed(const Duration(milliseconds: delay));
      setState(() {
        displayedProcesses.add(executionOrder[i]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Simulation Result"), backgroundColor: Colors.purple),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gantt Chart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: displayedProcesses.map((process) {
                    return Column(
                      children: [
                        Text(process["start"].toString(),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Text(process["PID"],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Text(process["end"].toString(),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Text("Process Table", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text("Process")),
                    DataColumn(label: Text("Completion Time")),
                    DataColumn(label: Text("Turnaround Time")),
                    DataColumn(label: Text("Waiting Time")),
                    DataColumn(label: Text("Response Time")),
                  ],
                  rows: results.map(
                    (process) => DataRow(
                      cells: [
                        DataCell(Text(process["PID"])),
                        DataCell(Text(process["Completion"].toString())),
                        DataCell(Text(process["Turnaround"].toString())),
                        DataCell(Text(process["Waiting"].toString())),
                        DataCell(Text(process["Response"].toString())),
                      ],
                    ),
                  ).toList(),
                ),
              ),
              SizedBox(height: 20),
              Text("Average Metrics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Average Turnaround Time: ${avgTurnaroundTime.toStringAsFixed(2)}"),
                    Text("Average Waiting Time: ${avgWaitingTime.toStringAsFixed(2)}"),
                    Text("Average Response Time: ${avgResponseTime.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
