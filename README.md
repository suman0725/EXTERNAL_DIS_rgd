# EXTERNALS for CLAS12 Run Group D (RG-D)

## Overview
This repository contains the `externals` radiative correction code, originally developed for the EG2 experiment (6 GeV era). It is currently being adapted for the **CLAS12 Run Group D (RG-D)** experiment at Jefferson Lab.

The code calculates radiative corrections for electron-nucleus scattering using the peaking approximation and equivalent radiator method.

## Migration Status
We are currently modifying the codebase to support the specific experimental configuration of RG-D:

* **Beam Energy:** Updating beam parameters to ~10.5 GeV (CLAS12 standard).
* **Target Materials:** Adding support for RG-D nuclear targets:
    * **Liquid:** Deuterium (LD2)
    * **Solid Foils:** Carbon (C), Copper (Cu), Tin (Sn)
* **Geometry:** * Adapting `target_info` to model the **Flag Assembly** used for solid targets.
    * Updating liquid target geometry to match the 5 cm cryotarget cell used in CLAS12.

---

## Directory Structure

1. **`INP/`** - Contains "master" input files (e.g., `clasd2.inp`) that point to other required inputs.
2. **`RUNPLAN/`** - Contains kinematic files (e.g., `clas_kin.inp`) defining where to calculate cross sections and RC. *Note: These files are sensitive to formatting.*
3. **`TARG/`** - Contains target definitions (e.g., `targ.D2tuna`). Defines Z, A, geometry, and materials.
   * *Note: The model choice is currently hardwired to use **F1F209** from Peter Bosted.*
4. **`OUT/`** - Destination for detailed output files (e.g., `clasd2_details.out`).
5. **`Coulomb/`** - Supplementary directory containing examples of modified `externals_all.f`.

---

## Usage on JLab ifarm

### 1. Environment Setup
Source the environment script to load CLAS12 and CERNLIB modules:
```bash
source set_env.sh

## Compilation
Use make to compile the program. This builds all necessary Fortran objects and links them with the CERN libraries.

   make

##Execution
Run the executable externals_all. You will be prompted to enter the input filename (located in the INP/ directory).

Example for Tin (Sn):

   ./externals_all
   # Enter: INP/rgd_sn.inp
## References

1. *L. W. Mo, Y. S. Tsai.* Radiative corrections to elastic and inelastic ep and µp scattering. Rev. of Mod. Phys. **41**, 1 (1969)

2. *Y. S. Tsai.* Radiative corrections to electron scatterings. **SLAC-PUB-848** (1971)

Also, there is an excellent lecture prepared by [**Taisiya Mineeva**](mailto:taya.mineeva@gmail.com) at `QED-RC.pdf`.
