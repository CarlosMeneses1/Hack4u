# Bash Scripting: Practical Projects (Hack4u)

This repository contains scripts developed in **Bash** as part of my training at the **Hack4u** academy. These programs were designed to strengthen Linux terminal proficiency, control flow, data processing, and task automation.

## 🛠 Included Projects

### 1. HTB Machine Searcher (`htbmachines.sh`)
A command-line search tool designed to streamline querying **HackTheBox** machine data. The script interacts with a local dataset and allows for information filtering similar to the `grep` command.

* **Key Features:**
    * Search machines by name, OS, or difficulty level.
    * Extract IP addresses and required skills for resolution.
    * Utilizes parameters and flags for an efficient user experience.
    * Terminal color integration for improved readability.

### 2. Casino Simulator: Roulette (`ruleta.sh`)
A gambling simulation tool based on the game of roulette. This project focuses on mathematical logic and complex variable management within Bash.

* **Implemented Strategies:**
    * **Martingale:** Simulating the system of doubling the bet after every loss.
    * **Inverse Labrouchere:** Implementing a numerical sequence to manage bets dynamically.
* **Features:**
    * Initial bankroll management.
    * Final statistics: total plays, maximum money reached, and bankruptcy point.
    * Array management

---

## 🚀 Getting Started

### Prerequisites
* A Linux environment (Ubuntu, Kali Linux, Parrot OS, WSL, etc.)
* Execution permissions for the files.

### Installation and Usage
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/CarlosMeneses1/Hack4u](https://github.com/CarlosMeneses1/Hack4u)
    ```
2.  **Navigate to the directory:**
    ```bash
    cd your-repo-name
    ```
3.  **Assign execution permissions:**
    ```bash
    chmod +x *.sh
    ```
4.  **Run the scripts:**
    ```bash
    ./htbmachines.sh -m "MachineName"
    # or
    ./ruleta.sh -m 100 -t martingala
    ```
### Additionally, in each program you can use the `-h` parameter to display the help panel and learn in detail what the program offers and how to use it.
---

## 📚 Credits
These exercises were completed following the methodology of **S4vitar** in the "Introduction to Linux" course at **Hack4u**.
