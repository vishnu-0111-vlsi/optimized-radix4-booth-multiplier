# Radix-4 Booth Multiplier with Precomputed Multiples
B.Tech Capstone Project — VIT-AP University, December 2024

Parameterized signed radix-4 Booth multiplier in Verilog using precomputed multiplicand multiples for efficient signed multiplication.
**Author:** Vishnu Vardhan Jammunaboyina
---
## Overview
This project implements standard modified radix-4 Booth encoding for signed multiplication.
The design precomputes all Booth multiples (0, +1M, +2M, -1M, -2M) once in hardware. Each booth encoder stage only selects the correct multiple instead of dynamically shifting or negating the multiplicand during encoding.
This is an RTL microarchitecture optimization. The Booth multiplication algorithm is unchanged.
---
## Architecture
**Data flow:**
1. Multiplicand goes to `multiplicand_multiples` (precompute 0, +/-1M, +/-2M)
2. Multiplier goes to `booth_encoder_stage` blocks (radix-4 decode, N/2 stages)
3. Each stage selects one precomputed multiple
4. Partial products are shifted and added in `booth_multiplier_selector`
5. Final 2N-bit signed product is produced
**Block diagram:**
    multiplicand --> [multiplicand_multiples] --> multiples (0, +/-1M, +/-2M)
                                                          |
    multiplier -----> [booth_encoder_stage] x (N/2) ----+
                              |
                              v
                    [shift and accumulate]
                              |
                              v
                          product (2N bits)
---
## Modules
| File | Description |
|------|-------------|
| multiplicand_multiples.v | Precompute Booth multiples with sign extension |
| booth_encoder_stage.v | Radix-4 booth bit decode and multiple selection |
| booth_multiplier_selector.v | Top-level parameterized multiplier |
**Top module parameter:** `WIDTH` = 8, 16, 32, or 64
---
## Difference from basic Booth RTL
| Basic Booth RTL | This capstone design |
|-----------------|----------------------|
| Partial products computed on the fly | Multiples precomputed once |
| Encoder shifts/negates M each stage | Encoder only selects via case/mux |
| Logic often merged | Three separate modular blocks |
---
## Results vs baseline radix-4 Booth
Synthesized on Xilinx Kintex-7 using AMD Vivado 2024.  
Power analyzed using Cadence Genus.
| Width | LUT reduction | Delay improvement | Power reduction |
|-------|---------------|-------------------|-----------------|
| 8-bit | ~22%          | ~6%               | ~1%             |
| 16-bit | ~12%         | ~11%              | ~0.7%           |
| 32-bit | ~15%         | ~8%               | ~31%            |
| 64-bit | ~18%         | ~4.5%             | ~32%            |


