# **Project Summary**

# **Project Summary: Custom 8-Channel ESP32-S3 LED Controller PCB Design**

## **I. Project Goal**

Design two related PCBs for a miniature village LED lighting system, utilizing individually addressable SK6812 RGBW (Warm White) LEDs. The primary focus is on robust design (THT connectors for durability) and cost-effective manufacturing (JLCPCB Basic Parts).

## **II. Key Deliverables (Two Boards)**

### **A. Board A: Main Dock (Controller)**

| Feature | Specification | Rationale |
| :---- | :---- | :---- |
| **Microcontroller** | ESP32-S3 (WROOM-1 Module) | Runs WLED firmware; must include USB-C, Boot/Reset buttons. |
| **Power Input** | 5V DC Barrel Jack (5.5mm x 2.1mm) | High current, max 8A. Must include Reverse Polarity Protection (RPP) and a 10A fuse/PTC. |
| **Outputs** | 8x JST-PH 3-Pin Connectors (Vertical) | Supports 8 independent chains. Max \$\\sim\$2A per port. |
| **Data Integrity** | Level Shifting required (2x 74AHCT125) | To boost 3.3V logic to 5V for reliable long-chain operation. |

### **B. Board B: House LED Board (Pixel PCB)**

| Feature | Specification | Rationale |
| :---- | :---- | :---- |
| **Shape/Size** | **Circular, 20mm Diameter** | Critical for fitting into standard village house base holes. |
| **LEDs** | 3x SK6812 RGBW (Warm White) | Tightly clustered, 3535 size preferred, to act as a single point light source. |
| **Connectors** | 2x JST-PH 3-Pin (Input/Output) | **Through-Hole (THT)** required for mechanical durability during frequent plugging/unplugging. |
| **Layout** | **Component Split Mandatory** | LEDs on one side (Top), Connectors/Passives on the opposite side (Bottom). |
| **Pass-Through Current** | Max 1.0A through VCC/GND traces | Must support up to 5 downstream houses. |

## **III. Manufacturing Constraints (JLCPCB Focus)**

* **Cost Optimization:** Component selection **MUST** prioritize **JLCPCB Basic Parts** (especially for resistors, capacitors, and ICs) to minimize assembly costs.  
* **Deliverables:** Full set of fabrication files (Gerbers, BOM with LCSC P/Ns, CPL file) and source files (KiCad or EasyEDA).  
* **Goal:** Production-ready files that can be uploaded directly to the JLCPCB SMT assembly service.

# **Details**

# **Custom PCB Design for Miniature Collectible Village LED Lighting System**

## **1\. Project Overview**

I am building a custom lighting solution for miniature collectible village houses (such as those made by Department 56 or Lemax). The goal is to replace standard incandescent bulbs with individually addressable **SK6812 RGBW (Warm White)** LEDs.

I need a design for a **Main Docking Board** and a small **House LED Board**. I plan to have these manufactured and assembled by **JLCPCB**.

## **2\. System Architecture**

The system uses a **Main Dock** that drives 8 chains of houses.

* **Topology:** **Multi-Channel Daisy Chain**. The Dock provides 8 ports. The user connects multiple houses (daisy-chained) to each port.  
* **Voltage:** 5V DC System.  
* **LED Type:** SK6812 RGBW (Warm White).

## **3\. Scope of Work (Deliverables)**

### **Board A: The Main Dock (Controller Board)**

* **Function:** Main controller that powers the village and runs WLED software.  
* **Microcontroller:** **ESP32-S3 (WROOM-1 Module)**.  
  * Must include USB-C for programming/power and Boot/Reset buttons.  
  * **Note:** Designer may use the ESP32-S3 **Native USB** interface (direct USB D+/D- connection) to save BOM cost, or a standard USB-to-UART bridge.  
* **Power Input:** 5V DC via a DC Barrel Jack (5.5mm x 2.1mm DC Barrel Jack, High current, approx 8A max).  
  * Include **Reverse Polarity Protection** (e.g., P-Channel MOSFET).  
  * Include **Fuse** (10A SMD Fuse holder or resettable PTC (e.g., 10A rating).  
  * **Bulk Capacitance:** 1000uF or more to handle transients.  
* **Outputs:** 8x **JST-PH 3-Pin** Connectors (Vertical).  
  * *Logic:* These 8 ports are driven by 8 independent GPIOs from the ESP32.  
  * *Level Shifting:* Use **2x 74AHCT125** (Quad Level Shifter) to boost 3.3V logic to 5V for all 8 ports.  
  * *Power Distribution:* Each port must have a capable 5V/GND trace to handle \~2A per port.  
* **Extra Features:**  
  * 1x Power LED.

### **Board B: The House LED Board (Pixel PCB)**

* **Function:** A tiny PCB that sits inside the house, acting as the light source and pass-through.  
* **Components:**  
  1. **LEDs:** 3x **SK6812 RGBW** (Warm White) Surface Mount LEDs.  
     * *Size Preference:* **3535 size** is preferred to save space on the small board.  
     * *Arrangement:* **Tightly clustered in the center** (e.g., triangle formation) to act as a single point light source and ensure light projects up into the house cavity without being blocked by the base hole rim.  
     * *Logic:* Daisy-chained on-board (Input \-\> LED1 \-\> LED2 \-\> LED3 \-\> Output).  
  2. **Capacitor:** 100nF decoupling per LED.  
* **Connectors (Pass-through):**  
  * **Input:** 1x **JST-PH 3-Pin** (Male/Header) \- From Dock/Previous House.  
  * **Output:** 1x **JST-PH 3-Pin** (Male/Header) \- To Next House.  
  * *Connector Standard:* Use **Through-Hole (THT)** JST-PH 3-Pin Receptacles/Headers (Right Angle preferred if space allows, otherwise Vertical). THT is requested for mechanical durability.  
  * *Pinout:* VCC (Pin 1), Data (Pin 2), GND (Pin 3). Data trace connects Pin 2 Input to LED1 DIN. LED3 DOUT connects to Pin 2 Output. VCC/GND rails are shared.  
* **Physical:**  
  * **Shape/Size:** Circular, 20mm diameter. This shape ensures compatibility with standard circular holes found in the base of many village houses.  
  * **Component Placement:** **MANDATORY:** LEDs must be placed exclusively on one side (Top Layer), and Connectors must be placed exclusively on the opposite side (Bottom Layer).  
  * **Color:** White Soldermask (to reflect light).

## **4\. Manufacturing Requirements (JLCPCB Specifics)**

* **Parts Selection:** Component selection **MUST** prioritize "Basic Parts" from the **JLCPCB/LCSC library** (especially for resistors/capacitors) to minimize assembly costs.  
* **Deliverables:**  
  1. **KiCad or EasyEDA Source Files**.  
  2. **Gerber Files** (ready for production).  
  3. **BOM (Bill of Materials)** with LCSC Part Numbers.  
  4. **CPL (Centroid/Pick & Place File)**.

## **5\. Notes for the Designer**

* **Space Constraints:** Board B is very small (20mm). Please ensure the **Through-Hole pins** from the connectors on the bottom layer do not interfere with the LED footprints on the top layer. (The 3535 LEDs should be centered, allowing THT pins to occupy the outer rim).  
* **Current Traces:** Board A's power traces must be robust. Board B's VCC/GND traces must handle pass-through current for up to 5 downstream houses (Max 1.0A pass-through). Designer must size VCC/GND traces accordingly.  
* **LED Brightness:** The design uses 3 LEDs to ensure brightness matches/exceeds the original incandescent bulbs (approx 60 Lumens total).