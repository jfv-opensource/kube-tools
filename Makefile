default: build

common-build: common-clean
	mkdir -p build
	-./inline.sh --in-file km  --out-file build/km
	-./inline.sh --in-file kc  --out-file build/kc
	-./inline.sh --in-file kw  --out-file build/kw
	-./inline.sh --in-file klb --out-file build/klb
	chmod 755 build/*

common-clean:
	-rm build/*
	-rmdir build

build: common-build
	mkdir -p usr/bin
	cp -f  build/* usr/bin/
	help2man --no-info usr/bin/kc -n 'Kubernetes controller tool' > debian/kc.1
	help2man --no-info usr/bin/km -n 'Kubernetes master' > debian/km.1
	help2man --no-info usr/bin/kw -n 'Kubernetes worker' > debian/kw.1
	help2man --no-info usr/bin/klb -n 'Kubernetes load-balancer' > debian/klb.1

clean: common-clean
	-rm -f debian/*.1 
	-rm -f usr/bin/*
	-rmdir usr/bin usr

.PHONY: debian build
debian: 
	debuild -us -uc

debian-clean:
	debclean

docker: common-build
	cp -f build/km build/km.sh
	cp -f build/kc build/kc.sh
	cp -f build/kw build/kw.sh
	cp -f build/klb build/klb.sh
	docker build -t kubetools .
