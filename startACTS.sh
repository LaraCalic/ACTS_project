# Export the directory where the compiled version of ACTS lives
export ACTSBUILD="/my-acts/build"
# Export the directory where the source version of ACTS checked out from GitHub lives
export ACTSSOURCE="/my-acts/source"
# Export the example python scripts directory
export ACTSPYSCRIPTS="/my-acts/source/Examples/Scripts/Python"
# Export the RUNDIR
export RUNDIR=$PWD

# Report that we've set these environment variables
echo "Environment variables set: ACTSBUILD, ACTSSOURCE, ACTSPYSCRIPTS"

# Download the missing detector maps
#cd $ACTSSOURCE/thirdparty/OpenDataDetector/data
#curl -O https://gitlab.cern.ch/acts/OpenDataDetector/-/raw/main/data/odd-material-maps.root
#curl -O https://gitlab.cern.ch/acts/OpenDataDetector/-/raw/main/data/odd-bfield.root
#cd $RUNDIR

# Download Geant4 data
#source /usr/local/bin/download_geant4_data.sh

#  Source the DD4HEP installation
echo "Setting up DD4hep"
source /usr/local/bin/thisdd4hep_only.sh

# Source the GEANT4 installation
#echo "Setting up GEANT (NB - current build is without Geant)"
#source /usr/local/bin/geant4.sh

# Set up the python bindings
# REF: https://acts.readthedocs.io/en/latest/examples/python_bindings.html
echo "Setting up Python bindings"
source $ACTSBUILD/python/setup.sh

# Source the ACTS installation
#source $ACTSBUILD/this_acts.sh

# Set up ODD detector
echo "Setting up ODD"
export LD_LIBRARY_PATH=$ACTSBUILD/thirdparty/OpenDataDetector/factory:$LD_LIBRARY_PATH

# Install the required python modules
#pip3 install -r $ACTSSOURCE/Examples/Python/tests/requirements.txt

# Get my jupyter notebook ingredients
#pip3 install jupyter notebook pandas scipy matplotlib

# Run the python unit tests
# REF: https://acts.readthedocs.io/en/latest/examples/python_bindings.html#python-based-unit-tests
echo "Running python bindings tests..."
cd $ACTSSOURCE/Examples/Python/tests/
pytest
echo "Hopefully lots of passed tests..."
cd $RUNDIR

# REF: https://stackoverflow.com/questions/38830610/access-jupyter-notebook-running-on-docker-container
alias docknb="echo -e To view jupyter notebook: localhost:8888/tree; jupyter notebook --ip 0.0.0.0 --no-browser --allow-root"

echo "Start jupyter notebooks with docknb"
