#	$OpenBSD$

INSTALL_DATA=	/usr/bin/install -c -m 644

NOPROFILE=

LIB=		evdev

PREFIX=		/usr/local
INCSDIR=	${PREFIX}/include
LIBDIR=		${PREFIX}/lib

CPPFLAGS+=	-I${.CURDIR} \
		-I${INCSDIR} \

INCS= 		libevdev.h
SRCS=		libevdev.c
PKGCONFIG=	libevdev.pc


includes: _SUBDIRUSE
	mkdir -p ${DESTDIR}${INCSDIR}/libevdev
	cd ${.CURDIR}; for i in ${INCS}; do \
	    j="cmp -s $$i ${DESTDIR}${INCSDIR}/$$i || \
		${INSTALL_DATA} $$i ${DESTDIR}${INCSDIR}/libevdev"; \
		echo "\tinstalling $$i"; \
		eval "$$j"; \
	done

# pkgconfig
PACKAGE_VERSION = 1.13.1
PKGCONFIG = libevdev.pc

.SUFFIXES: .in .pc

all: ${PKGCONFIG}

CLEANFILES += ${PKGCONFIG}

${PKGCONFIG}: ${PKGCONFIG}.in
	@sed -e 's#@prefix@#${PREFIX}#g' \
	    -e 's#@datarootdir@#$${prefix}/share#g' \
	    -e 's#@datadir@#$${datarootdir}#g' \
	    -e 's#@exec_prefix@#$${prefix}#g' \
	    -e 's#@libdir@#$${exec_prefix}/lib#g' \
	    -e 's#@includedir@#$${prefix}/include#g' \
	    -e 's#@PACKAGE_VERSION@#'${PACKAGE_VERSION}'#g' \
	    ${EXTRA_PKGCONFIG_SUBST} \
	< $? > $@

install-pc: ${PKGCONFIG}
	${INSTALL_DATA} ${PKGCONFIG} ${DESTDIR}${LIBDIR}/pkgconfig

realinstall: install-pc

.include <bsd.obj.mk>
.include <bsd.lib.mk>

