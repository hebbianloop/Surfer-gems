# Start with base freesurfer container
# build from directory containing surfergems (path is relative)
FROM vistalab/freesurfer

RUN apt-get update && apt-get install -y openjdk-7-jre-headless \
	dialog \
	parallel \
	git \
	bsdmainutils


RUN ln -s /bin/grep /bin/ggrep
ADD surfergems /usr/bin/surfergems
RUN chmod +x /usr/bin/surfergems


ENTRYPOINT ["/usr/bin/surfergems"]
