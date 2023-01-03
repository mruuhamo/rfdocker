# We take the fedora linux package
FROM fedora:37

LABEL description="Robot Framework in a Fedora 37 docker image, with Browser Library. Includes necessary tools to run Robot Framework Browser library in container. Inspired by asyrjasalo and ppodgorsek robot framework docker images"

# Declare robot env variables
ENV NAME_UID="robot"
ENV NAME_GID="robot"
ENV HOST_UID=1000
ENV HOST_GID=1000
ENV SHELL="/bin/bash"
ENV UHOME="/home/robot"
ENV UREPORT="/home/robot/report"
ENV UTESTS="/home/robot/test"
# Set installation dependency versions
ENV CHROMIUM_VERSION 105.0.5195.125-2.fc37
ENV XVFB_VERSION 1.20.14-8.fc37
ENV RF_VERSION 6.0.1
ENV BROWSER_LIBRARY_VERSION 14.3.0
# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920
# Set XVFB run value (0 == False, 1 == True)
ENV XVFB_ENABLED 0

# Set root user for installations
USER root

# Set user group for robot framework users
RUN groupadd --system \
  -g ${HOST_GID} \
  ${NAME_GID}

# Set robot user
RUN useradd --system \
  -u ${HOST_UID} \
  -g ${NAME_GID} \
  -d ${UHOME} \
  -s ${SHELL} \
  ${NAME_UID}

# Add packages from Fedora to be installed. System dependencies to run Browser Library
RUN dnf upgrade -y --refresh \
&& dnf install -y \
    chromium-${CHROMIUM_VERSION}* \
    npm \
    nodejs \
    python3-pip \
    xorg-x11-server-Xvfb-${XVFB_VERSION}* \
&& dnf clean all

# Updgrade pip
RUN pip3 install --no-cache-dir --upgrade pip

# Install RF and browser
RUN pip3 install --no-cache-dir robotframework==$RF_VERSION
RUN pip3 install --no-cache-dir robotframework-browser

#initialize browser library
RUN rfbrowser init

# Create the default report and work folders with the default user to avoid runtime issues
# These folders are writeable by anyone, to ensure the user can be changed on the command line.
RUN mkdir -p ${UREPORT} \
  && mkdir -p ${UHOME} \
  && chown ${HOST_UID}:${HOST_GID} ${UREPORT} \
  && chown ${HOST_UID}:${HOST_GID} ${UHOME} \
  && chmod ugo+w ${UREPORT} ${UHOME}

# Copy the run.sh binary
COPY run.sh ${UHOME}/run.sh

# Allow any user to write logs
RUN chmod ugo+w /var/log \
  && chown ${HOST_UID}:${HOST_GID} /var/log

#Add robot folder to PATH
ENV PATH="/home/robot:$PATH"

# Set work dir and also user, robot
WORKDIR ${UHOME}
USER ${NAME_UID}

CMD ["run.sh"]