SCRIPTS = km kc kw klb
INLINES = $(patsubst %,build/%.sh,$(SCRIPTS))
BINS = $(patsubst %.sh,%,$(INLINES))
MANS = $(patsubst %,debian/%.1,$(SCRIPTS))
TARGETS = $(INLINES) $(BINS) $(MANS)

build/%.sh: %
	mkdir -p build
	./inline.sh --in-file $< --out-file $@
	chmod 755 $@

debian/%.1: build/%
	./genman.sh $< > $@

all: $(TARGETS)

install:
	mkdir -p $(DESTDIR)/usr/bin
	install -m 0755 -t $(DESTDIR)/usr/bin $(BINS)

uninstall:
	rm -f $(addprefix $(DESTDIR)/usr/bin/, $(SCRIPTS))

clean::
	rm -f $(TARGETS)

distclean: clean

.PHONY: all install uninstall clean distclean
.DELETE_ON_ERROR:

debian: 
	debuild -us -uc

debian-clean:
	debclean

.PHONY: debian debian-clean

DEBIANS = bookworm
UBUNTUS = focal jammy noble
DOCKER_DEBIANS = $(addprefix docker-debian-,$(DEBIANS)) 
DOCKER_UBUNTUS = $(addprefix docker-ubuntu-,$(UBUNTUS))

docker-debian-%: $(INLINES)
	mkdir -p docker/debian/$*/build/
	cp -f $(INLINES) docker/debian/$*/build/
	-docker rmi kubetools-debian-$*
	docker build -t kubetools-debian-$* docker/debian/$*/

docker-ubuntu-%: $(INLINES)
	mkdir -p docker/ubuntu/$*/build/
	cp -f $(INLINES) docker/ubuntu/$*/build/
	-docker rmi kubetools-ubuntu-$*
	docker build -t kubetools-ubuntu-$* docker/ubuntu/$*

docker-debian: $(DOCKER_DEBIANS)
docker-ubuntu: $(DOCKER_UBUNTUS)
docker: docker-debian docker-ubuntu
$(DOCKERS):

clean-docker:
	-rm -Rf docker/*/*/build

.PHONY: docker-debian docker-ubuntu docker clean-docker

