PREFIX=		/usr/local
DOCBOOK_XSL=	${PREFIX}/share/xsl/docbook
.SUFFIXES:	.sh

all: minixmlto

clean:
	rm minixmlto

install: minixmlto
	install -m 755 minixmlto ${PREFIX}/bin

.sh:
	sed -e 's,@DOCBOOK_XSL@,${DOCBOOK_XSL},g' $< > $@
