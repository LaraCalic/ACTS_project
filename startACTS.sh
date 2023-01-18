#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Script functions:"
   echo
   echo "Syntax: startACTS [-d|h|p|t]"
   echo "options:"
   echo "d     Download ODD and GEANT data files."
   echo "h     Print this Help."
   echo "p     Install python modules for ACTS and Jupyter notebooks."
   echo "t     Run pytest."
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

##::: Set variables
DownloadFiles=false
InstallPythonModules=false
RunPyTests=false

# User message
echo "By default, I will just set up the ACTS environment, including PATH."
echo "Checking for flags for additional setup actions..."

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":dhpt" option; do
   case $option in
      d) # Download files ON
        echo "I will download data files for ODD and GEANT."
        DownloadFiles=true;;
      h) # display Help
         Help
         exit;;
      p) # Install python modules ON
         echo "I will install Python modules required for ACTS and Jupyter."
         InstallPythonModules=true;;
      t) # Run Pytest ON
         echo "I will run pytest to check if ACYS Python is working."
         RunPyTests=true;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

# User message
echo "OK, Setting up ACTS..."

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

# Download data files, if -d
if [ "$DownloadFiles" = true ];
then
  # Download the missing detector maps
  echo "Downloading ODD detector maps..."
  cd $ACTSSOURCE/thirdparty/OpenDataDetector/data
  curl -O https://gitlab.cern.ch/acts/OpenDataDetector/-/raw/main/data/odd-material-maps.root
  curl -O https://gitlab.cern.ch/acts/OpenDataDetector/-/raw/main/data/odd-bfield.root
  cd $RUNDIR

	# Download Geant4 data
  echo "Downloading GEANT4 data..."
  source /usr/local/bin/download_geant4_data.sh
fi

#  Source the DD4HEP installation
echo "Setting up DD4hep"
source /usr/local/bin/thisdd4hep_only.sh

# Source the GEANT4 installation
echo "Setting up GEANT (NB - current build is without Geant)"
source /usr/local/bin/geant4.sh

# Set up the python bindings
# REF: https://acts.readthedocs.io/en/latest/examples/python_bindings.html
echo "Setting up Python bindings"
source $ACTSBUILD/python/setup.sh

# Source the ACTS installation
source $ACTSBUILD/this_acts.sh

# Set up ODD detector
echo "Setting up ODD"
export LD_LIBRARY_PATH=$ACTSBUILD/thirdparty/OpenDataDetector/factory:$LD_LIBRARY_PATH


# Install the required python modules, if -p
if [ "$InstallPythonModules" = true ];
then
  # ACTS python requirements
	pip3 install -r $ACTSSOURCE/Examples/Python/tests/requirements.txt

	# Get my jupyter notebook ingredients
	pip3 install jupyter notebook pandas scipy matplotlib
fi

# Run the setup verification tests, if -t
if [ "$RunPyTests" = true ];
then
	# Run the python unit tests
	# REF: https://acts.readthedocs.io/en/latest/examples/python_bindings.html#python-based-unit-tests
	echo "Running python bindings tests..."
	cd $ACTSSOURCE/Examples/Python/tests/
	pytest
	echo "Hopefully lots of passed tests..."
	cd $RUNDIR
fi

# REF: https://stackoverflow.com/questions/38830610/access-jupyter-notebook-running-on-docker-container
alias docknb="echo -e To view jupyter notebook: localhost:8888/tree; jupyter notebook --ip 0.0.0.0 --no-browser --allow-root"

echo "Start jupyter notebooks with docknb"
echo "ACTS is ready now."

# Clean up
OPTIND=1
