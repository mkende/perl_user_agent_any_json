# DO NOT EDIT! This file is written by perl_setup_dist.
# If needed, you can add content at the end of the file.

# This script is executed during the updateContent phase of the container lifecycle.
# It contains all the commands that need access to the repository content and so,
# cannot be executed as part of the Dockerfile.

sudo cpanm --notest --installdeps --with-develop --with-configure --with-recommends --with-suggests --with-all-features .
perl Makefile.PL

if [ -n "${PAUSE_USERNAME}" ] && [ -n "${PAUSE_USERNAME}" ]; then
  echo "user ${PAUSE_USERNAME}\npassword ${PAUSE_PASSWORD}" > ~/.pause
fi

# End of the template. You can add custom content below this line.
