import 'package:flutter/material.dart';
import 'dart:async';

class FCFSResult extends StatefulWidget {
  final List<Map<String, dynamic>> processList;
  const FCFSResult({required this.processList});

  @override
  State<FCFSResult> createState() => _FCFSResultState();
}

class _FCFSResultState extends State<FCFSResult> {
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
    runFCFS();
    _calculateAverages();
    _animatedGanttChart();
  }

  void runFCFS() {
    List<Map<String, dynamic>> queue = List.from(widget.processList);
    queue.sort((a, b) => a["Arrival"].compareTo(b["Arrival"]));

    int totalTurnaroundTime = 0;
    int totalWaitingTime = 0;
    int totalResponseTime = 0;

    for (var process in queue) {
      String pid = process["PID"];
      int arrival = process["Arrival"];
      int burst = process["Burst"];

      if (currentTime < arrival) {
        currentTime = arrival;
      }

      executionOrder.add({
        "PID": pid,
        "start": currentTime,
        "end": currentTime + burst,
      });

      int completionTime = currentTime + burst;
      int turnaroundTime = completionTime - arrival;
      int waitingTime = turnaroundTime - burst;
      int responseTime = currentTime - arrival;

      totalTurnaroundTime += turnaroundTime;
      totalWaitingTime += waitingTime;
      totalResponseTime += responseTime;

      results.add({
        "PID": pid,
        "Completion": completionTime,
        "Turnaround": turnaroundTime,
        "Waiting": waitingTime,
        "Response": responseTime,
      });

      currentTime += burst;
    }

    avgTurnaroundTime = totalTurnaroundTime / queue.length;
    avgWaitingTime = totalWaitingTime / queue.length;
    avgResponseTime = totalResponseTime / queue.length;
  }

  void _calculateAverages() {
    if (results.isNotEmpty) {
      setState(() {
        avgTurnaroundTime =
            results.map((p) => p["Turnaround"]).reduce((a, b) => a + b) /
                results.length;
        avgWaitingTime =
            results.map((p) => p["Waiting"]).reduce((a, b) => a + b) /
                results.length;
        avgResponseTime =
            results.map((p) => p["Response"]).reduce((a, b) => a + b) /
                results.length;
      });
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
      appBar: AppBar(title: Text("FCFS Simulation Result"), backgroundColor: Colors.purple),
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
              Text("Execution Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: executionOrder.map((p) {
                  return Chip(
                    label: Text(p["PID"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.purple[100],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text("Process Table",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  rows: results
                      .map(
                        (process) => DataRow(
                          cells: [
                            DataCell(Text(process["PID"])),
                            DataCell(Text(process["Completion"].toString())),
                            DataCell(Text(process["Turnaround"].toString())),
                            DataCell(Text(process["Waiting"].toString())),
                            DataCell(Text(process["Response"].toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              Text("Averages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Average Turnaround Time: ${avgTurnaroundTime.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("Average Waiting Time: ${avgWaitingTime.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("Average Response Time: ${avgResponseTime.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
