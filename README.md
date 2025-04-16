# **Champ3d**

_Code for Computational Physics in Electrical Engineering_

**Champ3d** aims to 

### Supported models

**Champ3d** supports, when it's possible, all combinations of the models listed below:

+ [x] 2D
- [x] 3D

- [x] Electromagnetic
  
  - [x] Magneto-dynamic
  
  - [x] Magneto-static
  
  - [x] Electro-static
  
  - [x] Electro-kinetic
  
  - [ ] Wave

- [x] Thermic
  
  - [x] Diffusion
  
  - [x] Convection
  
  - [ ] Radiation

### Numerical methods

+ [x] FEM
  
  - [x] 2D on quadrilateral and triangle mesh
  
  - [x] 3D on hexahedral, prismatic and tetrahedral mesh

- [ ] FEM/DDM

- [ ] FEM/BEM

### Dependency

+ Standard MATLAB without needs of additional toolboxes.

### Optional dependency

* **FEMM**
  
  If you want to build 2D mesh with FEMM. On Windows, you should have FEMM installed with matlab/octave interface (*femm42\mfiles*).
  **Champ3d** provides also an interface to FEMM tools to build mesh much more conveniently.

**Champ3d** is copyright (C) 2023 H-K. Bui and distributed under the terms of the GNU GENERAL PUBLIC LICENSE Version 3. See LICENSE and CREDITS files for more information.
