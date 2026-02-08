VHDL Thermostat Controller (FSM-based)

This project implements a thermostat controller in VHDL, designed to manage heating, cooling, and ventilation based on current and desired temperature values.
The system is modeled as a finite state machine (FSM) and fully verified using a self-checking VHDL testbench.

The design demonstrates structured RTL coding, synchronous logic, and simulation-driven verification.


Functional Overview

The thermostat:

Compares current temperature with a desired temperature
Controls:
  Furnace (heating)
  Air conditioner (cooling)
  Fan
Supports heating and cooling modes
Includes delayed shutdown behavior using an internal counter
Allows switching between current temperature display and desired temperature display

Finite State Machine (FSM)

The controller is implemented as a Moore-type FSM with the following states:
  IDLE – System inactive
  HEATON – Furnace enabled, waiting for heat
  FURNACENOWHOT – Furnace hot, fan running
  FURNACECOOL – Post-heating fan cooldown
  COOLON – Air conditioner enabled
  ACNOWREADY – AC ready, fan running
  ACDONE – Post-cooling fan cooldown

State transitions depend on:
  Temperature comparison
  External readiness signals (FURNACE_HOT, AC_READY)
  User control inputs (HEAT, COOL)
  Internal cooldown counters

Timing & Control Logic

Fully synchronous design using a single system clock
Asynchronous active-low reset
Internal countdown timers implemented via a register-based counter
Clean separation of:
  State register
  Next-state logic
  Output/data path logic

Testbench & Verification

A comprehensive VHDL testbench is included that:
  Generates a periodic clock
  Applies realistic temperature and control scenarios
  Synchronizes with the DUT using wait until and clock edges
  Verifies behavior using assert statements
  Tests both heating and cooling cycles end-to-end

The testbench ensures that:
  Outputs respond correctly to temperature changes
  FSM transitions occur as expected
  Post-heating and post-cooling delays are respected

Technologies Used

VHDL 
Finite State Machines (FSM)
Synchronous digital design
Simulation-based verification
Vivado Simulator

Deutsch:

VHDL-Projekt: Digitale Temperatursteuerung (Thermostat)
Projektbeschreibung

Dieses Projekt implementiert eine digitale Temperatursteuerung (Thermostat) in VHDL, bestehend aus einem synthesefähigen 
Design und einer ausführlichen Testbench. Ziel ist die Steuerung einer Heizung (Furnace), einer Klimaanlage (AC) sowie 
eines Ventilators (Fan) auf Basis von Ist- und Solltemperatur sowie externer Statussignale.

Das Design ist vollständig taktsynchron, resetfähig und verwendet eine Finite State Machine (FSM) zur sauberen Ablaufsteuerung. 
Das Projekt dient als praxisnahes Beispiel für strukturiertes VHDL-Design, FSM-Modellierung und verlässliche Simulation.

Funktionale Übersicht
Das Thermostat vergleicht kontinuierlich:
  Aktuelle Temperatur (CURRENT_TEMP)
  Gewünschte Temperatur (DESIRED_TEMP)
  
Abhängig von Benutzereingaben und Systemzuständen werden folgende Aktoren gesteuert:
  Heizung (FURNACE_ON)
  Klimaanlage (AC_ON)
  Ventilator (FAN_ON)
Zusätzlich kann zwischen Anzeige der aktuellen oder gewünschten Temperatur umgeschaltet werden.

Zustandsautomat (FSM)
Die Steuerlogik basiert auf einer endlichen Zustandsmaschine mit folgenden Zuständen:
  IDLE – Ruhezustand, alle Aktoren aus
  HEATON – Heizung wird eingeschaltet
  FURNACENOWHOT – Ofen ist heiß, Ventilator läuft
  FURNACECOOL – Nachlaufphase zur Abkühlung (mit Timer)
  COOLON – Klimaanlage wird eingeschaltet
  ACNOWREADY – AC bereit, Ventilator läuft
  ACDONE – Nachlaufphase der Klimaanlage (mit Timer)
Ein interner Zähler (counter) sorgt für definierte Nachlaufzeiten des Ventilators nach dem Abschalten von Heizung oder Klimaanlage.

Technische Details
Sprache: VHDL
Designstil: Synchrones Design
Klare Trennung von Registerprozessen
Kombinatorischer Next-State-Logik
Datenpfad
Reset: Asynchron, aktiv low
Zustandssteuerung: FSM mit case-Struktur
Simulation: Vollständig verifizierte Testbench

Testbench & Verifikation

Die Testbench simuliert realistische Szenarien, darunter:
  Umschaltung der Temperaturanzeige
  Heizbetrieb bis Erreichen der Solltemperatur
  Reaktion auf FURNACE_HOT
  Abkühlphase mit Ventilator-Nachlauf
  Kühlbetrieb mit AC_READY
  Überprüfung aller Ausgangssignale mittels assert und wait until
Die Simulation bestätigt das korrekte zeitliche und logische Verhalten des Systems.

Author: Dylann Kinfack
