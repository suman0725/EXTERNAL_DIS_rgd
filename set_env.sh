#!/bin/bash -f
echo ">>> Setting Environment Variables for EXTERNALS on ifarm <<<"

export ARCH="64bit"
export ARCHT="64bit"
export EXTERNDIR=${EXTERNDIR:-${HOME}/EXTERNALS}

echo ""
echo " > EXTERNDIR is set to $EXTERNDIR"
echo " > ARCH is set to $ARCH"
echo " > ARCHT is set to $ARCHT"

################
# module setup#!/bin/bash

# 1. Initialize module command (ensures script works in scripts/shells)
source /etc/profile.d/modules.sh

echo ">>> Setting up Environment for CLAS12 RG-D EXTERNALS <<<"

# 2. Use JLab standard module path
module use /scigroup/cvmfs/hallb/clas12/sw/modulefiles

# 3. Load required modules
# 'clas12' loads the compiler (gcc), ROOT, and build tools
# 'cernlib/2023' loads the specific math libraries needed by this Fortran code
module load clas12


# 4. Set Project Variables
export EXTERNDIR=$(pwd)

# 5. Fix for Makefile: Define CERN_ROOT
# The JLab module sets $CERN and $CERN_LEVEL, but your Makefile expects $CERN_ROOT.
# We construct it here so the Makefile can find the libraries.
if [ -n "$CERN" ] && [ -n "$CERN_LEVEL" ]; then
    export CERN_ROOT=${CERN}/${CERN_LEVEL}
else
    # Fallback if variables aren't set (though module load usually sets them)
    echo "WARNING: CERN variables not detected. Compilation might fail."
fi

echo ""
echo " > Environment Ready."
echo " > EXTERNDIR: $EXTERNDIR"
echo " > CERN_ROOT: $CERN_ROOT"
################

if command -v module >/dev/null 2>&1; then
  echo ""
  echo ">> Loading ifarm modules (clas12 bundle includes gcc, CERNLIB, ROOT, and dependencies)"
  echo ""
  module use /scigroup/cvmfs/hallb/clas12/sw/modulefiles
  module load clas12
else
  echo "Warning: environment-modules not available; ensure GCC, CERNLIB, and ROOT are configured manually."
fi

################
# cern settings
################
echo ""
echo ">> Checking Environment Variables for CERN"
echo ""

export CERNVER=${CERNVER:-2023}
export CERN_ROOT=${CERN_ROOT:-${CERN}/$CERNVER}
export CERN_LIB=${CERN_LIB:-${CERN_ROOT}/lib}
export CERN_BIN=${CERN_BIN:-${CERN_ROOT}/bin}
export CERN_INC=${CERN_INC:-${CERN_ROOT}/include}
export CERNLIBDIR=${CERNLIBDIR:-${CERN_LIB}}
export CERN_INCLUDEDIR=${CERN_INCLUDEDIR:-${CERN_INC}}

if [ ! -d "$CERN_LIB" ] || [ ! -d "$CERN_BIN" ] || [ ! -d "$CERN_INC" ]; then
  echo "CERN Error: CERNLIB module not available or CERN_ROOT missing; please load the clas12 module on ifarm."
  return -1
fi

echo "CERN_LEVEL is set to ${CERNVER}"
echo "CERN_ROOT is set to ${CERN_ROOT}"
echo "CERN_LIB is set to ${CERN_LIB}"
echo "CERN_BIN is set to ${CERN_BIN}"
echo "CERN_INC is set to ${CERN_INC}"

# Add to paths (only if not already there)
if [[ ":$PATH:" != *":$CERN_BIN:"* ]]; then PATH="${CERN_BIN}:$PATH"; fi
if [[ ":$LIBRARY_PATH:" != *":$CERN_LIB:"* ]]; then export LIBRARY_PATH="${CERN_LIB}:$LIBRARY_PATH"; fi
if [[ ":$LD_LIBRARY_PATH:" != *":$CERN_LIB:"* ]]; then export LD_LIBRARY_PATH="${CERN_LIB}:$LD_LIBRARY_PATH"; fi

################
# root settings
################
echo ""
echo ">> Checking Environment Variables for ROOT"
echo ""

export ROOTSYS=${ROOTSYS:-$ROOTSYS}
export ROOTLIB=${ROOTLIB:-${ROOTSYS}/lib}
export ROOTBIN=${ROOTBIN:-${ROOTSYS}/bin}
export ROOTINC=${ROOTINC:-${ROOTSYS}/include}

if [ ! -d "$ROOTLIB" ] || [ ! -d "$ROOTBIN" ] || [ ! -d "$ROOTINC" ]; then
  echo "ROOT Error: ROOT module not available or ROOTSYS missing; please load the clas12 module on ifarm."
  return -1
fi

echo "ROOTSYS is set to ${ROOTSYS}"
echo "ROOTLIB is set to ${ROOTLIB}"
echo "ROOTBIN is set to ${ROOTBIN}"
echo "ROOTINC is set to ${ROOTINC}"

if [[ ":$PATH:" != *":$ROOTBIN:"* ]]; then export PATH="$ROOTBIN:$PATH"; fi
if [[ ":$LIBRARY_PATH:" != *":$ROOTLIB:"* ]]; then export LIBRARY_PATH="$ROOTLIB:$LIBRARY_PATH"; fi
if [[ ":$LD_LIBRARY_PATH:" != *":$ROOTLIB:"* ]]; then export LD_LIBRARY_PATH="$ROOTLIB:$LD_LIBRARY_PATH"; fi
