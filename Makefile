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

clean:
	rm -f $(TARGETS)

distclean: clean

.PHONY: all install uninstall clean distclean

debian: 
	debuild -us -uc

debian-clean:
	debclean

.PHONY: debian debian-clean

docker: docker-debian-bookworm docker-ubuntu-focal docker-ubuntu-jammy docker-ubuntu-noble

docker-debian-bookworm: $(INLINES)
	mkdir -p docker/debian/bookworm/build/
	cp -f build/km.sh docker/debian/bookworm/build/km.sh
	cp -f build/kc.sh docker/debian/bookworm/build/kc.sh
	cp -f build/kw.sh docker/debian/bookworm/build/kw.sh
	cp -f build/klb.sh docker/debian/bookworm/build/klb.sh
	docker build -t kubetools-debian docker/debian/bookworm/

docker-ubuntu-focal: $(INLINES)
	mkdir -p docker/ubuntu/focal/build/
	cp -f build/km.sh docker/ubuntu/focal/build/km.sh
	cp -f build/kc.sh docker/ubuntu/focal/build/kc.sh
	cp -f build/kw.sh docker/ubuntu/focal/build/kw.sh
	cp -f build/klb.sh docker/ubuntu/focal/build/klb.sh
	-docker rmi kubetools-ubuntu-focal
	docker build -t kubetools-ubuntu-focal docker/ubuntu/focal

docker-ubuntu-jammy: $(INLINES)
	mkdir -p docker/ubuntu/jammy/build/
	cp -f build/km.sh docker/ubuntu/jammy/build/km.sh
	cp -f build/kc.sh docker/ubuntu/jammy/build/kc.sh
	cp -f build/kw.sh docker/ubuntu/jammy/build/kw.sh
	cp -f build/klb.sh docker/ubuntu/jammy/build/klb.sh
	-docker rmi kubetools-ubuntu-jammy
	docker build -t kubetools-ubuntu-jammy docker/ubuntu/jammy


docker-ubuntu-noble: $(INLINES)
	mkdir -p docker/ubuntu/noble/build/
	cp -f build/km.sh docker/ubuntu/noble/build/km.sh
	cp -f build/kc.sh docker/ubuntu/noble/build/kc.sh
	cp -f build/kw.sh docker/ubuntu/noble/build/kw.sh
	cp -f build/klb.sh docker/ubuntu/noble/build/klb.sh
	-docker rmi kubetools-ubuntu-nobble
	docker build -t kubetools-ubuntu-nobble docker/ubuntu/noble

docker-clean:
	-rm -Rf docker/debian/*/build
	-rm -Rf docker/ubuntu/*/build

