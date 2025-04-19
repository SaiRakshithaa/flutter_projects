import 'package:flutter/material.dart';
import 'dart:async';

class SimulationResult extends StatefulWidget {
  final List<Map<String, dynamic>> processList;
  const SimulationResult({required this.processList});

  @override
  State<SimulationResult> createState() => _SimulationResultState();
}

class _SimulationResultState extends State<SimulationResult> {
  List<Map<String, dynamic>> executionOrder = [];
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> displayedProcesses = [];
  int currentTime = 0;
  double avgTurnaroundTime = 0.0;
  double avgWaitingTime = 0.0;
  double avgResponseTime = 0.0;

  @override
  void initState() {
    super.initState();
    runPreemptivePriorityScheduling();
    _animatedGanttChart();
  }

  void runPreemptivePriorityScheduling() {
    List<Map<String, dynamic>> queue = List.from(widget.processList);
    queue.sort((a, b) => a["Arrival"].compareTo(b["Arrival"]));

    Map<String, int> remainingBurst = {};
    Map<String, int> startTime = {};
    Map<String, int> completionTime = {};
    Set<String> completed = {};

    for (var process in queue) {
      remainingBurst[process["PID"]] = process["Burst"];
      startTime[process["PID"]] = -1;
    }

    currentTime = queue.first["Arrival"];

    while (completed.length < queue.length) {
      var availableProcesses = queue
          .where((p) => p["Arrival"] <= currentTime && !completed.contains(p["PID"]))
          .toList();

      if (availableProcesses.isEmpty) {
        currentTime = queue
            .where((p) => !completed.contains(p["PID"]))
            .map((p) => p["Arrival"])
            .reduce((a, b) => a < b ? a : b);
        continue;
      }

      availableProcesses.sort((a, b) => a["Priority"].compareTo(b["Priority"]));
      var process = availableProcesses.first;
      String pid = process["PID"];

      if (startTime[pid] == -1) {
        startTime[pid] = currentTime;
      }

      executionOrder.add({"PID": pid, "start": currentTime, "end": currentTime + 1});
      remainingBurst[pid] = remainingBurst[pid]! - 1;
      currentTime++;

      if (remainingBurst[pid] == 0) {
        completed.add(pid);
        completionTime[pid] = currentTime;
      }
    }

    for (var process in queue) {
      String pid = process["PID"];
      int arrival = process["Arrival"];
      int burst = process["Burst"];
      int turnaroundTime = completionTime[pid]! - arrival;
      int waitingTime = turnaroundTime - burst;
      int responseTime = startTime[pid]! - arrival;

      results.add({
        "PID": pid,
        "Completion": completionTime[pid]!,
        "Turnaround": turnaroundTime,
        "Waiting": waitingTime,
        "Response": responseTime,
      });
    }

    computeAverages(); // ✅ Call computeAverages() here after results are populated
  }

  void computeAverages() {
    if (results.isNotEmpty) {
      avgTurnaroundTime = results.fold(0.0, (sum, item) => sum + item["Turnaround"]) / results.length;
      avgWaitingTime = results.fold(0.0, (sum, item) => sum + item["Waiting"]) / results.length;
      avgResponseTime = results.fold(0.0, (sum, item) => sum + item["Response"]) / results.length;
    }
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
              SizedBox(
                //height: 300, // ✅ Define a height to avoid `Expanded` issue
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Process")),
                      DataColumn(label: Text("Completion Time")),
                      DataColumn(label: Text("Turnaround Time")),
                      DataColumn(label: Text("Waiting Time")),
                      DataColumn(label: Text("Response Time")),
                    ],
                    rows: results.map(
                      (process) => DataRow(cells: [
                        DataCell(Text(process["PID"])),
                        DataCell(Text(process["Completion"].toString())),
                        DataCell(Text(process["Turnaround"].toString())),
                        DataCell(Text(process["Waiting"].toString())),
                        DataCell(Text(process["Response"].toString())),
                      ]),
                    ).toList(),
                  ),
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
