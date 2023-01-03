#!/bin/sh


# First check if the robot should be run normally or with simulation (xvfb)
if [ $XVFB_ENABLED -eq 0 ]
then
# Run with normal robot arguments
python3 -m robot.run --nostatusrc -v SCREEN_HEIGHT:${SCREEN_HEIGHT} -v SCREEN_WIDTH:${SCREEN_WIDTH} --outputdir ${UREPORT} ${UTESTS}


else
# Run the tests with xvfb arguments
xvfb-run \
    --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
    robot \
    --outputDir $UREPORT \
    $UTESTS

fi