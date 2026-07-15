# Results and Discussion

B.Tech Capstone Project — VIT-AP University, December 2024

PPA comparison of **proposed Booth multiplier** vs **baseline radix-4 Booth RTL**.

**Author:** Vishnu Vardhan Jammunaboyina  
**Co-author:** Raja Vardhan Mutchakala  
**Advisor:** Dr. Girish Kumar Mekala

---

## Test setup

| Item | Detail |
|------|--------|
| Synthesis tool | AMD Vivado 2024 |
| Target FPGA | Xilinx Kintex-7 (xc7k325tfbg676-3) |
| Power analysis | Cadence Genus |
| Operand widths | 8, 16, 32, 64 bits |

---

## Summary

Same radix-4 Booth algorithm. Improvement comes from **precomputed multiplicand multiples** (0, +/-1M, +/-2M computed once; encoder only selects via mux).

| Width | LUT reduction | Delay improvement | Power reduction |
|-------|---------------|-------------------|-----------------|
| 8-bit | ~22% | ~6% | ~1% |
| 16-bit | ~12% | ~11% | ~0.7% |
| 32-bit | ~15% | ~8% | ~31% |
| 64-bit | ~18% | ~4.5% | ~32% |

Best area gain at 8-bit. Best power gain at 32-bit and 64-bit.

---

## Delay comparison (ns)

| Multiplier | 8-bit | 16-bit | 32-bit | 64-bit |
|------------|-------|--------|--------|--------|
| Baseline Booth | 8.682 | 11.878 | 15.168 | 21.540 |
| Proposed Booth | 8.154 | 10.579 | 13.906 | 20.575 |
| Improvement | 6.06% | 10.94% | 8.32% | 4.48% |

---

## Area comparison (LUTs)

| Multiplier | 8-bit | 16-bit | 32-bit | 64-bit |
|------------|-------|--------|--------|--------|
| Baseline Booth | 81 | 395 | 1536 | 5699 |
| Proposed Booth | 63 | 349 | 1298 | 4662 |
| Improvement | 22.22% | 11.65% | 15.49% | 18.20% |

---

## Power comparison (uW)

| Multiplier | 8-bit | 16-bit | 32-bit | 64-bit |
|------------|-------|--------|--------|--------|
| Baseline Booth | 36.2 | 140 | 1185 | 5904 |
| Proposed Booth | 35.9 | 139 | 816 | 3994 |
| Improvement | 0.83% | 0.71% | 31.13% | 32.35% |

---

## Comparison with other multipliers (8-bit)

| Architecture | Delay | Power (uW) | Area (LUT) |
|--------------|-------|------------|------------|
| Booth multiplier | 8.682 ns | 36.2 | 81 |
| Array multiplier | 10.372 ns | 49.3 | 130 |
| Hybrid adder multiplier | 9.441 ns | 54.1 | 133 |
| Vedic RCA | 9.863 ns | 41.4 | 97 |
| Wallace multiplier | 10.191 ns | 48.6 | 142 |
| Dadda multiplier | 8.893 ns | 39.5 | 87 |
| Proposed multiplier | 8.194 ns | 35.9 | 63 |

Proposed design has lowest area and lowest power in this set at 8-bit.

Delay improvement vs other architectures (8-bit, from report):

- vs Booth: 5.62%
- vs Array: 21.00%
- vs Hybrid adder: 13.21%
- vs Vedic RCA: 16.92%
- vs Wallace: 19.59%
- vs Dadda: 8.00%

Area improvement vs other architectures (8-bit):

- vs Booth: 22.22%
- vs Array: 51.54%
- vs Hybrid adder: 52.63%
- vs Vedic RCA: 35.05%
- vs Wallace: 55.62%
- vs Dadda: 27.00%

Power improvement vs other architectures (8-bit):

- vs Booth: 0.83%
- vs Array: 27.19%
- vs Hybrid adder: 33.64%
- vs Vedic RCA: 13.29%
- vs Wallace: 26.13%
- vs Dadda: 9.11%

---

## Design diagrams

### Radix-4 Booth encoding

![Radix-4 encoding groups](images/radix4_booth_encoding.png)

Overlapping 3-bit Booth groups on the extended multiplier.

### Baseline Booth multiplier

![Baseline Booth block diagram](images/baseline_booth_block_diagram.png)

Reference radix-4 Booth design used for PPA comparison.

### Proposed Booth multiplier

![Proposed multiplier block diagram](images/proposed_multiplier_block_diagram.png)

Three-stage design: precomputed multiples, booth encode/select, shift and accumulate.

### Booth bits example

![Booth bits extraction](images/booth_bits_example_multiplier_14.png)

Example of partial product selection from Booth bit groups.

---

## Synthesis and simulation

### Vivado synthesized schematic

![Vivado synthesized design](images/proposed_multiplier_block_diagram.png)

Post-synthesis netlist showing multiplicand multiples, booth encoder stages, and add/shift path.

### Simulation waveform

![Simulation waveform](images/simulation_waveform_result.png)

Functional verification with multiple test vectors. Example: 12 x 14 = 168.

---

## PPA improvement graphs

Add these PNG files to `docs/images/` after exporting from your report:

![Delay improvement](images/delay_improvement_percent.png)

![Area improvement](images/area_improvement_percent.png)

![Power improvement](images/power_improvement_percent.png)

---

## Key takeaways

**What was optimized**

- RTL microarchitecture: precompute 0, +/-1M, +/-2M once per operation
- Encoder stage only selects the correct multiple (case/mux)
- Three modular blocks instead of merged logic

**What was not changed**

- Radix-4 Booth encoding rules and algorithm
- Signed multiplication math

**Why power improves at wide widths**

- Less repeated shift/negate logic in each booth stage
- Shared precomputed multiples reduce switching activity

**Why delay gain is modest**

- Partial products still accumulated with a linear shift-add chain
- Further delay improvement would need tree reduction (future work)

---

## Citation

Jammunaboyina V.V. and Mutchakala R.V., "Design and Implementation of an Optimized Booth Multiplier Using Modular Multiplicand Multiples for Efficient Signed Multiplication," B.Tech Capstone, VIT-AP University, December 2024.
