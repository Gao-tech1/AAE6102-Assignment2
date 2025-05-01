# AAE6102-Assignment2
AAE6102-Assignment2

Task 1 prompt: [ChatGPT-4o prompt for Task 1](https://chatgpt.com/c/6811d7ca-af38-8004-a5f5-0c95805e29a6) </br>
Task 4 prompt: [ChatGPT-4o prompt for Task 4](https://chatgpt.com/share/6811eaf4-f9c0-8004-b3a4-0a24a889b825) </br>
Task 5 prompt: [ChatGPT-4o prompt for Task 5](https://chatgpt.com/share/6811f1d8-d1ec-8004-8ce2-fb8980c1bc09)

- [AAE6102-Assignment2](#aae6102-assignment2)
  * [Task 1 – Differential GNSS Positioning](#task1--differential-gnss-positioning)
    + [1.1 Principles of Each GNSS Technique](#11-principles-of-each-gnss-technique)
    + [1.2 Comparative Analysis](#12-comparative-analysis)
    + [1.3 Conclusion](#13-conclusion)
  * [Task 4 – LEO Satellites for Navigation](#task4--leo-satellites-for-navigation)
    + [4.1 Orbital Mechanics](#41-orbital-mechanics)
    + [4.2 Signal Capture](#42-signal-capture)
    + [4.3 System Integration](#43-system-integration)
  * [Task 5 – GNSS Remote Sensing](#task5--gnss-remote-sensing)
    + [5.1 Introduction](#51-introduction)
    + [5.2 Physics of GNSS-R Signal Scattering](#52-physics-of-gnss-r-signal-scattering)
    + [5.3 Key Observables and Applications](#53-key-observables-and-applications)
    + [5.4 Emerging Trends and Technology](#54-emerging-trends-and-technology)
    + [5.5 Challenges and Comparisons](#55-challenges-and-comparisons)
    + [5.6 Conclusion](#56-conclusion)    
    
## Task1 – Differential GNSS Positioning
A **comprehensive summary** of each method:

- **Differential GNSS (DGNSS)** leverages a nearby reference station to broadcast pseudorange corrections, achieving sub-meter accuracy almost instantly, but its performance degrades with distance from the station and it offers only modest improvement over standalone GNSS.  
- **Real-Time Kinematic (RTK)** uses carrier-phase corrections from a base station or network to deliver centimeter-level accuracy within seconds, yet requires reliable low-latency links and careful ambiguity resolution, which can be challenging on smartphones .  
- **Precise Point Positioning (PPP)** dispenses with a local base by applying globally sourced precise orbit and clock products to a single receiver, offering decimeter-to-centimeter accuracy but often requiring 10–30 minutes to converge and a data link for correction streaming.  
- **PPP-RTK** (a.k.a. SSR) hybridizes PPP and RTK corrections to approach RTK-level accuracy with much faster initialization (seconds to a minute), at the cost of subscription-based services and regional correction networks.
  
### 1.1 Principles of Each GNSS Technique

  #### Differential GNSS (DGNSS)
  DGNSS relies on one or more reference stations at known locations to compute pseudorange correction messages and broadcast them to user receivers, thus canceling common satellite and atmospheric errors  . Corrections are relatively simple code adjustments, typically improving standalone GNSS accuracy from several meters down to about one meter within a few tens of kilometers of the reference station.

  #### Real-Time Kinematic (RTK)
  RTK enhances positioning by using carrier-phase measurements and integer ambiguity resolution. A reference station (or network of stations) sends real-time corrections in RTCM format, allowing the rover receiver to resolve phase ambiguities and compute positions at the centimeter level. This sophisticated technique depends on maintaining a steady low-latency link and high-quality signal tracking.

  #### Precise Point Positioning (PPP)
  PPP applies precise satellite orbit and clock products—derived from a global network of monitoring stations—and models for atmospheric delays and receiver biases directly to a single receiver’s measurements  . Without requiring a local reference, PPP can achieve decimeter-level accuracy once the solution converges, making it appealing where base stations are unavailable.

  #### PPP-RTK
  Also known as State-Space Representation (SSR), PPP-RTK combines the global corrections of PPP with regional or network-based atmospheric and bias modeling to significantly shorten convergence times while maintaining near-RTK accuracy. Corrections are broadcast over L-band or IP, demanding access to a correction service and compatible receivers.

### 1.2 Comparative Analysis

  #### Accuracy
  - **DGNSS**: Typically around 1 m (1 σ) within tens of kilometers of the reference station, degrading roughly 1 m per 150 km of baseline.  
  - **RTK**: Centimeter-level horizontal accuracy (1–2 cm RMS) under ideal conditions when ambiguities are fixed.  
  - **PPP**: Down to a few centimeters (≈2.5 cm) after full convergence; early solutions may be at the decimeter level or worse.  
  - **PPP-RTK**: Near-RTK performance, typically within 2–5 cm horizontally, by leveraging regional corrections.

  #### Convergence Time
  - **DGNSS**: Virtually instantaneous, as pseudorange corrections apply directly to code measurements .  
  - **RTK**: From a few seconds to tens of seconds to resolve carrier-phase ambiguities, depending on satellite geometry and link quality; smartphones may experience modestly longer times due to antenna and processing limitations.  
  - **PPP**: Often requires 10–30 minutes to reach centimeter accuracy, though “fast-PPP” methods on Android have demonstrated sub-meter accuracy within seconds and meter-level in under a minute.  
  - **PPP-RTK**: Convergence typically in seconds to under a minute, as regional corrections accelerate ambiguity convergence.

  #### Ease of Use for Smartphone Navigation
  - **DGNSS**: Supported via Satellite-Based Augmentation Systems (e.g., WAAS, EGNOS) or Internet-delivered RTCM; requires raw measurement access on Android (available since Android 7), but integration is relatively straightforward .  
  - **RTK**: Demands continuous RTCM streams (e.g., NTRIP over cellular), specialized software, and high-quality antennas; smartphones can now leverage raw GNSS APIs but still face hardware and connectivity challenges.  
  - **PPP**: Needs precise orbit/clock streams via NTRIP or L-band, and more computational resources; some Android PPP apps exist, but performance depends on dual-frequency, raw-data access, and link stability. 
  - **PPP-RTK**: Similar infrastructure demands as PPP plus subscription to a correction service; emerging smartphone support promises significant accuracy gains but adds complexity in configuration and cost.

### 1.3 Conclusion
| Technique   | Pros                                                         | Cons                                                                  |
|-------------|--------------------------------------------------------------|-----------------------------------------------------------------------|
| **DGNSS**   | - Sub-meter accuracy almost instantly<br>- Wide SBAS coverage (e.g. WAAS/EGNOS)<br>- Low computation & data requirements | - Accuracy degrades with distance from reference station<br>- Typically only ~1 m improvement over standalone GNSS |
| **RTK**     | - Centimeter-level accuracy (< 2 cm RMS)<br>- Rapid convergence (seconds) when links are good | - Requires continuous low-latency correction stream (e.g. NTRIP)<br>- Needs robust antenna & reliable cellular/data link<br>- More complex setup on smartphones  |
| **PPP**     | - Global coverage; no local base needed<br>- Decimeter-to-centimeter accuracy after convergence | - Long convergence time (10–30 min) for full accuracy<br>- Dependence on precise orbit/clock streams<br>- Higher CPU/memory use on device |
| **PPP-RTK** | - Near-RTK accuracy (2–5 cm) with much faster initialization (secs–1 min)<br>- Leverages both global and regional corrections | - Subscription or access to SSR correction service required<br>- Added data/link complexity and potential cost |

  For smartphone navigation, the choice hinges on application needs and available infrastructure. **DGNSS** offers rapid sub-meter accuracy with minimal setup, making it ideal for broad coverage and low cost. **RTK** is unmatched for real-time centimeter precision but requires a robust correction link. **PPP** provides global coverage without a local base station, albeit with longer convergence. **PPP-RTK** strikes a balance by marrying PPP’s ubiquity with RTK’s speed, delivering high accuracy quickly, at the expense of specialized correction services and subscription fees. Choose the method that best aligns with your accuracy targets, latency tolerance, and system complexity.

---
## Task 2 – LEO Satellites for Navigation
**Solution to Task 2 – GNSS in Urban Areas**  

Based on the analysis of the "Urban" dataset and the skymask provided, the following approach was developed to address GNSS positioning challenges:  

1. **Problem Identification**:  
   - Only **4 satellites** (SV1, SV3, SV11, SV18) were tracked in the urban environment.  
   - The skymask analysis revealed that **SV3 and SV18** were likely **blocked** due to their elevation angles falling below the skymask-defined visibility threshold. However, with only 4 satellites available, excluding these satellites would leave insufficient measurements for positioning, making traditional exclusion methods impractical.  

2. **Weighted Least Squares (WLS) Approach**:  
   - To mitigate multipath/NLOS effects from potentially blocked satellites, **elevation-angle-based weighting** was applied during the position solution. Satellites at lower elevation angles (e.g., SV3, SV18) were assigned lower weights, while higher-elevation satellites (e.g., SV1, SV11) were given higher weights.  
   - **Result**: This method slightly improved positioning accuracy compared to an unweighted solution but showed limited effectiveness due to the small number of satellites and persistent NLOS errors.  

3. **Potential Enhancement: Path Simulation with Skymask**:  
   - To further reduce NLOS errors, a **3D path simulation** based on the skymask and urban geometry is recommended. The steps include:  
     - **Satellite Visibility Check**: Use the skymask to determine blocked azimuth-elevation regions. For each satellite, compare its azimuth/elevation with the skymask to flag potential NLOS conditions.  
     - **NLOS Detection**: For satellites flagged as blocked (e.g., SV3, SV18), simulate signal reflection paths using a simplified urban canyon model (e.g., building heights and locations near the ground truth). Adjust pseudorange measurements by estimating additional path delays caused by reflections.  
     - **Residual Analysis**: Iteratively refine the position solution by minimizing residuals between corrected pseudoranges and the geometric range calculated from the receiver’s estimated position.  
<div style="display: flex; justify-content: space-between;">
  <img src="image1.jpg" alt="Image 1" style="width:33%;"/>
  <img src="image2.jpg" alt="Image 2" style="width:33%;"/>
  <img src="image3.jpg" alt="Image 3" style="width:33%;"/>
</div>



---
## Task 4 – LEO Satellites for Navigation
The deployment of Low Earth Orbit (LEO) communications constellations for positioning promises ultra-low latency and improved geometry diversity compared to Medium Earth Orbit (MEO) GNSS systems, yet is constrained by three fundamental challenges: orbital mechanics, signal capture, and system integration.  Each dimension critically influences the attainable accuracy, reliability, and continuity of opportunistic positioning services using non-dedicated LEO platforms.  Orbital mechanics determines how precisely a satellite’s trajectory can be known in real time; signal capture governs the recoverable observables from proprietary communication links; and system integration dictates how rapidly and robustly these novel measurements can be assimilated into established GNSS processing frameworks.  

### 4.1 Orbital Mechanics  
Precision in orbit determination underpins any satellite-based navigation service.  LEO’s proximity to Earth accentuates perturbative forces and dynamics not encountered at GNSS altitudes, necessitating advanced modeling and high-rate estimation.  

- **Differential Gravitational Perturbations**
The Earth’s gravitational potential exhibits high spatial frequency content that induces periodic variations in LEO orbital elements.  To constrain orbit errors below the decimeter level, gravity field models of degree and order ≥ 10 must be coupled with recursive estimation of time-varying spherical harmonics.  Inadequate modeling leads to meter-scale along- and cross-track deviations within hours, severely degrading navigation solutions.  

- **Atmospheric Drag**
Atmospheric drag is the dominant non-gravitational perturbation in LEO, driven by thermospheric density fluctuations that respond rapidly to solar and geomagnetic forcing.  Empirical models such as JB2008 reduce along-track dispersion but leave residual uncertainties of several centimeters per minute of propagation.  Incorporating on-board accelerometer measurements can partially mitigate drag mis-modeling but entails added mass and power consumption constraints.  

- **Rapid Orbital Variation and High Velocity**
LEO platforms orbit with velocities of 7.1–7.8 km/s and complete a revolution in 90–110 minutes, resulting in line-of-sight geometry changes of several degrees per second.  Such rapid dynamics shorten the coherence time for batch orbit fits and amplify Doppler estimation errors, necessitating sub-second update rates in navigation filters to preserve measurement integrity.  

### 4.2 Signal Capture  
Recovering navigational observables from LEO communications links requires overcoming the absence of dedicated ranging pilots and the brevity of visibility windows.  

- **Non-Cooperative Satellite Signals**
Commercial LEO constellations do not broadcast ephemeris or clock corrections; instead, ground-recovered Two-Line Elements (TLEs) and SGP4 propagators supply coarse orbital estimates valid for ~24 hours, but with residual errors exceeding one kilometer.  Reliance on third-party ephemerides introduces latency and model-mismatch biases that must be accounted for in real-time positioning.  

- **Lack of Precise Positioning Measurements**
Communication waveforms are optimized for throughput, lacking alignment sequences required for code pseudorange extraction.  Consequently, positioning must rely predominantly on Doppler observables and carrier phase, which degrade geometric dilution of precision (GDOP) and introduce integer ambiguity challenges in standalone solutions.  

- **Short Observation Period**
Individual LEO passes afford only 3–10 minutes of visibility per satellite, constraining the temporal span over which independent measurements can be collected.  Rapid handovers between satellites demand agile acquisition and reacquisition loops capable of sub-second synchronization to maintain continuous tracking.  

### 4.3 System Integration  
Assimilating LEO-derived observables into GNSS workflows requires adapting algorithms for high dynamics, ensuring time coherence, and fusing heterogeneous data streams.  

- **Algorithmic Adaptation for Fast Dynamics**
Standard Precise Point Positioning (PPP) and Real-Time Kinematic (RTK) filters assume orbit and clock dynamics orders of magnitude slower than those of LEO platforms.  High-rate Extended Kalman Filters (EKF) or particle filters must augment state vectors with drag coefficients and oscillator drift terms to accurately track LEO behavior in real time.  

- **Synchronization and Time Transfer Issues**
Unlike GNSS satellites equipped with rubidium or cesium clocks, LEO communications satellites use less stable oscillators without broadcast clock corrections.  Real-time onboard synchronization via embedded GNSS receivers or inter-satellite links (ISLs) is essential to constrain clock offsets below 1 ns, a requirement for sub-decimeter positioning.

- **Multi-Sensor and Multi-Constellation Fusion Challenges**
To achieve robust coverage and mitigate individual measurement shortcomings, LEO observables must be fused with terrestrial GNSS, inertial sensors, and potentially geostationary “augmentation” signals.  This fusion entails harmonizing disparate update rates, noise characteristics, and error correlations.  Cooperative architectures—whereby LEO operators share precise ephemerides and clock corrections—can alleviate receiver burden but face interoperability and standardization hurdles.  
---

## Task 5 – GNSS Remote Sensing
 
Global Navigation Satellite System Reflectometry (GNSS-R) has emerged as a powerful tool in Earth observation, enabling passive, bistatic radar sensing for geophysical monitoring over land, ocean, and cryosphere. By exploiting reflected GNSS signals, particularly at L-band frequencies, GNSS-R enables continuous, all-weather monitoring of soil moisture, sea surface height, and ice dynamics. This essay discusses the underlying physics of GNSS-R, including scattering models, key observables, and the impact of signal characteristics on retrieval performance. Emerging trends such as AI-driven inversion techniques and small-satellite constellations are examined, along with challenges arising from error sources and retrieval ambiguities. Comparisons with traditional remote sensing methods are also provided.


### 5.1 Introduction  

GNSS Reflectometry (GNSS-R) leverages opportunistic reflections of GNSS signals off the Earth's surface to infer environmental parameters. As a bistatic radar technique, GNSS-R repurposes existing satellite infrastructure—such as GPS, Galileo, and BeiDou—for passive sensing. The reflected signals, captured by a low-cost receiver aboard an aircraft or low-Earth orbit (LEO) satellite, carry signatures of the surface’s dielectric and geometric properties. Unlike traditional radiometers and active scatterometers, GNSS-R offers high temporal resolution, low power requirements, and resilience under cloudy or rainy conditions.

Recent missions, notably NASA's CYGNSS and ESA’s PARIS (Passive Reflectometry and Interferometry System), have expanded the spatial and scientific reach of GNSS-R, validating its potential for operational Earth monitoring. However, the technique is not without limitations: signal ambiguity, sensitivity to surface roughness, and ionospheric distortion complicate data interpretation. This essay delves into the physics, observables, applications, and evolving landscape of GNSS-R, highlighting both its strengths and outstanding challenges.

### 5.2 Physics of GNSS-R Signal Scattering  

GNSS-R fundamentally relies on bistatic radar principles, where a signal transmitted from a GNSS satellite is scattered by the Earth's surface and received by an off-nadir antenna. The received power $\(P_r\)$ is modeled by the bistatic radar equation:  
```math
P_r = P_tG_tG_r\frac{\lambda^2}{(4\pi)^3}\,\frac{\sigma^0}{R_t^2\,R_r^2}
```
where **$P_t$** is the transmitted power, **$G_t$** and **$G_r$** are antenna gains, **$\lambda$** the signal wavelength, and **$R_t$**, **$R_r$** the ranges from the transmitter and receiver to the scattering point. The bistatic radar cross-section **$\sigma^0$** quantifies the reflectivity of the surface and is decomposed into coherent (specular) and incoherent (diffuse) terms using the Kirchhoff approximation. The specular reflection dominates over smooth surfaces, while rough or dynamic surfaces (e.g., oceans) produce Doppler-spread diffuse returns.

The Fresnel reflection coefficients further refine the scattering model, especially for soil and ice surfaces. These depend on polarization and the complex dielectric constant of the surface. At L-band (1.2–1.5 GHz), soil permittivity increases from 2–5 (dry) to 20–30 (wet), dramatically altering reflection strength. The reflection coefficients for perpendicular and parallel polarizations are:
```math
r_\perp = \frac{\cos\theta_i - \sqrt{\varepsilon_2 - \sin^2\theta_i}}{\cos\theta_i + \sqrt{\varepsilon_2 - \sin^2\theta_i}}, \quad
r_\parallel = \frac{\varepsilon_2\cos\theta_i - \sqrt{\varepsilon_2 - \sin^2\theta_i}}{\varepsilon_2\cos\theta_i + \sqrt{\varepsilon_2 - \sin^2\theta_i}}.
```
These are sensitive to the volumetric soil moisture, enabling retrieval using semi-empirical dielectric models like Dobson and Mironov.

The Doppler and time-delay characteristics of the reflected signals are captured via the Delay-Doppler Map (DDM), which is the convolution of the surface scattering function \(S(\tau,f)\) with the Woodward Ambiguity Function (WAF):
```math
\chi(\tau, f) = \int s(t)\,s^*(t+\tau)\,e^{-j2\pi f t}\,\mathrm{d}t.
```
The DDM shows a bright specular peak and a horseshoe-shaped diffuse tail whose extent relates to surface roughness and motion. These features are central to retrieving parameters such as wind speed and wave height.


### 5.3 Key Observables and Applications  

The primary GNSS-R observables include:

- **Delay-Doppler Maps (DDMs):** 2D distributions of reflected power in delay and Doppler, sensitive to surface geometry and roughness.
- **Signal-to-Noise Ratio (SNR):** Varies with reflection strength and coherence.
- **Polarization Ratio:** Indicates surface moisture or dielectric discontinuity.

GNSS-R has proven effective across multiple domains:
- **Soil Moisture:** Fresnel amplitude variations from specular reflections enable retrieval of volumetric moisture with ~0.04–0.06 m³/m³ RMSE.
- **Sea Surface Altimetry:** DDM leading edge timing allows sub-decimeter precision in calm waters.
- **Cryosphere Monitoring:** Signal attenuation and scattering off snow/ice inform freeze–thaw transitions and ice sheet dynamics.


### 5.4 Emerging Trends and Technology  

The launch of NASA's CYGNSS constellation—a network of 8 LEO microsatellites using GPS reflections—has demonstrated GNSS-R’s scalability and resilience under intense weather. The ESA PARIS concept aims to leverage Galileo's higher bandwidth signals (e.g., E6) for finer resolution.

The contrast between GNSS signals is notable. For example, Galileo E6 (10.23 MHz chip rate) offers:
- 10× better range resolution (~15 m vs. 150 m for GPS L1 C/A).
- Improved Doppler discrimination (~50 Hz vs. ~500 Hz), enhancing wind retrieval.

Machine learning and AI are increasingly applied to invert DDMs into geophysical variables. Neural networks trained on synthetic DDMs and in-situ measurements have shown promise in reducing bias and enhancing retrieval accuracy across heterogeneous terrains.


### 5.5 Challenges and Comparisons  

Despite its advantages, GNSS-R faces notable challenges:
- **Ionospheric Distortion:** Can shift phase/delay, particularly at low elevation angles.
- **Surface Roughness:** Increases diffuse scattering, complicating coherent retrieval.
- **Geometric Dilution of Precision (GDOP):** Limits spatial accuracy in sparse configurations.

Compared with traditional **scatterometers**, GNSS-R has lower power and cost, but less control over illumination geometry. Compared with **radiometers**, GNSS-R provides better spatial resolution and sensitivity to surface geometry but lacks direct emission measurements.


### 5.6 Conclusion  

GNSS Reflectometry has transitioned from an experimental technique to a viable operational tool in Earth observation. By exploiting L-band reflections and delay-Doppler signal processing, it enables continuous, all-weather monitoring of critical environmental variables. As missions like CYGNSS and PARIS mature, and as AI-driven retrieval algorithms improve, GNSS-R stands poised to complement and enhance traditional remote sensing systems—offering a low-cost, high-frequency, and globally scalable approach to observing a changing Earth.




