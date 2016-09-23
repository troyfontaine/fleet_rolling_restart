# fleet_rolling_restart Script  
A bash script using fleetctl to restart service units.  Based off the work by Rob Tuley found [here](http://engineering.rainchasers.com/coreos/fleet/2015/03/03/rolling-unit-restart.html).

## Software Pre-requisites  

* Fleetctl (package available)   
* BASH 3.2 (Pre-installed with many distributions of Linux and macOS)  

### Fleetctl  

The method to install Fleetctl depends on your OS.  

#### macOS  
On macOS it is recommended that you use [Homebrew](http://brew.sh).  If you do not have it installed, follow the instructions on their website to install Homebrew.

If you have Homebrew installed, run the following command to install:  
```
brew install fleetctl
```

#### Linux
Fleetctl is available on several distributions via their built-in package manager while on others you must build it from source.  

A recent version of go (1.4 or higher) is required, so if your distribution's package manager doesn't offer a recent release, try searching for a tutorial relevant to your distro.  A good one for ubuntu is [here](https://www.digitalocean.com/community/tutorials/how-to-install-go-1-6-on-ubuntu-14-04).

To install fleetctl, the tutorial [here](https://leoengine.org/fleetctl-on-ubuntudebian-system/) should give you all you need.

## Usage
Coming soon  

## Known Issues
Currently the script cannot accomodate services configured with "dynamic" IPs (the IP follows the @symbol in the service name).  A fix is planned for a future release.
