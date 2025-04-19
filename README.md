# ⚙️ AlgoScheduler - Process Scheduling Simulation App

**AlgoScheduler** is a Flutter-based mobile application designed to simulate classical **CPU process scheduling algorithms**. It offers a user-friendly interface to visualize and understand how different algorithms schedule processes. Ideal for students, educators, and anyone interested in operating system concepts.

---

## 🔐 Authentication

- 🔒 **Firebase Authentication** is integrated to ensure secure access.
- Users must **log in or sign up** before accessing the simulation tools.

---

## 📚 Supported Scheduling Algorithms

AlgoScheduler currently supports the following **CPU scheduling algorithms**:

1. **First Come First Serve (FCFS)**
2. **Priority Scheduling**
   - Non-Preemptive
   - Preemptive
3. **Round Robin (RR)**

---

## 🧮 Input Parameters

Each algorithm takes the following process input fields:

- 🆔 **Process ID**
- 🕓 **Arrival Time**
- ⚡ **Burst Time**
- 🔢 **Priority** (for Priority Scheduling only)
- ⏲️ **Time Quantum** (for Round Robin only)

Users can dynamically **add multiple processes** by filling in the above fields and pressing **“Add”**.

---

## 🖥️ Simulation Output

Once all processes are added, tapping **“Start Simulation”** generates:

### 📊 Gantt Chart
- A dynamic, animated Gantt chart showing the execution order of processes.

### 📋 Process Table
- Each process's:
  - **Completion Time**
  - **Turnaround Time**
  - **Waiting Time**
  - **Response Time**

### 📈 Average Metrics
- Average:
  - **Turnaround Time**
  - **Waiting Time**
  - **Response Time**

---

## 💡 Key Features

- ✅ **Firebase Authentication** (Login/Signup)
- 📲 **Clean and Responsive UI** with Flutter
- 🚀 **Multiple Scheduling Algorithms**
- 🧠 **Smart Input System** with validations
- 📉 **Real-time Gantt Chart** Simulation
- 📋 **Process Metrics Table**
- 📐 **Average Performance Analysis**
- 🔁 **Supports Multiple Process Entries**

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend/Auth:** Firebase Authentication
- **State Management:** SetState / Provider (based on your implementation)
- **Simulation Logic:** Pure Dart-based custom logic for algorithms

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Flutter SDK
- Android Studio / VS Code
- Firebase Project setup with Authentication enabled

### 📥 Clone the repo

```bash
git clone https://github.com/your-username/AlgoScheduler.git
cd AlgoScheduler

