PREFIX=		/usr/local
DOCBOOK_XSL=	${PREFIX}/share/xsl/docbook
.SUFFIXES:	.sh

all: minixmlto

clean:
	rm minixmlto

install: minixmlto
	install -m 755 minixmlto ${DESTDIR}${PREFIX}/bin
	install -m 755 -d $(DESTDIR)$(PREFIX)/share/minixmlto
	install -m 644 pretty.style $(DESTDIR)$(PREFIX)/share/minixmlto/pretty.style

.sh:
	sed -e 's,@DOCBOOK_XSL@,${DOCBOOK_XSL},g' $< > $@
