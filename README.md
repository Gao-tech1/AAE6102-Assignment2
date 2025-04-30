# AAE6102-Assignment2
AAE6102-Assignment2

Task 1 prompt: [ChatGPT-4o prompt for Task 1](https://chatgpt.com/c/6811d7ca-af38-8004-a5f5-0c95805e29a6)

## Task 1 – Differential GNSS Positioning
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
