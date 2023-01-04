# Robot Framework in simple Browser library docker image

[Robot Framework](http://robotframework.org/) and [Browser library](https://robotframework-browser.org/) in a [Official Fedora](https://hub.docker.com/_/fedora/) Docker image.

## What is the aim with this image

* Aim to have simple, basic Docker image containing Robot Framework and [Browser library](https://robotframework-browser.org/) to run browser automation
* **Only** contains the necessary libraries to run browser automation with Browser library. That means, Robot Framework, Nodejs, and Browser library
* Intended as a "small" simple container, that can be used as is for Browser automation testing, or as a base image to be used as FROM in Dockerfile. I personally use this as a base image, and add needed libraries as work/project needs.
* If you look for a more comprehensive "all-in-one" package, I can recommend the [Paul Podgorsek's](https://github.com/ppodgorsek/docker-robot-framework) image.

## What this image contains

### Usage

You can run the container with the following command:

    docker run --rm --user robot \
      -v "local path to test suite folder":/home/robot/test \
      -v "local path to test report folder":/home/robot/report \
      mruuhamo/rfdocker 

### Understanding the Dockerfile

Dockerfile does the following in following order
* Takes the Linux Fedora distribution
* Declares the environmental variables, this contains the user variables, target folders, and installed software versions and screen size
* Creates the user group for running robot framework
* Creates user for running robot framework, and adds that to the user group
* Adds the packages from Fedora to be installed. The necessary packages to run Browser library
* Installs Pip, and installs Robot Framework, and initializes Browser library
* Crates the default folders for running tests and saving reports
* Sets the user and workdir to created user

### Installed versions:

* [Fedora Linux Docker image](https://hub.docker.com/_/fedora/) 37
* [Robot Framework](https://github.com/robotframework/robotframework) 6.0.1
* [Robot Framework Browser Library](https://github.com/MarketSquare/robotframework-browser) 14.3.0
* [Chromium](https://packages.fedoraproject.org/pkgs/chromium/chromium/) 105.0.5195.125-2.fc37

## Image's Configuration

### Changing the Image's screen resolution

It is possible to define the settings of the virtual screen in which the browser is run by changing several environment variables:

* `SCREEN_COLOUR_DEPTH` (default: 24)
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)

### Running with XVFB or without

Container is designed to be run **without** [xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) on default. However, if you want to run with xvfb, please change the **XVFB_ENABLED** ENV value from 0 (False) to 1 (True) in the Dockerfile. Xvfb is installed alongside container for execution incase virtual hardware is not available on host machine.


## Inspirations

Image is heavily inspired by both the original [Rfdocker](https://github.com/asyrjasalo/rfdocker) container and the excellent [Ppodgorsek](https://github.com/ppodgorsek/docker-robot-framework) robot framework container.
