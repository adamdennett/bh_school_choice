FROM rocker/shiny-verse
RUN apt update && apt install -y  libudunits2-dev libgdal-dev libgeos-dev libproj-dev curl
RUN R -e "install.packages('leaflet')"
RUN R -e "install.packages('sf')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('viridis')"
RUN R -e "install.packages('janitor')"
RUN R -e "install.packages('shinylive')"
RUN R -e "install.packages('httpuv')"
RUN R -e "install.packages('here')"
COPY bh_school_choice /srv/shiny-server/bh_school_choice/
WORKDIR /srv/shiny-server/bh_school_choice/ 
RUN /bin/bash init.sh
