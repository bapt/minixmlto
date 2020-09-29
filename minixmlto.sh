#!/bin/sh
#-
# Copyright (c) 2016 Baptiste Daroussin <bapt@FreeBSD.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#

docbookpath="@DOCBOOK_XSL@"

err() {
	ec=$1
	shift
	echo $@ >&2
	exit $ec
}
set -e

output=""

while getopts "o:" option; do
	case "$option" in
	'o')
		output="> ${OPTARG}"
	;;
	*)
		err 1 "Unsupported option ${option}"
	;;
	esac
done

shift $((OPTIND - 1))

[ $# -eq 2 ] || err 1 "usage: $0 <format> <file>"
xslt=$(which xsltproc)
[ -x ${xslt} ] || err 1 "xsltproc: not found"

case $1 in
man)
	xslpath=${docbookpath}/manpages/docbook.xsl
	;;
html-nochunks)
	xslpath=${docbookpath}/html/docbook.xsl
	xslargs="-o $(basename ${2%.*}.html)"
	;;
html|html-dir)
	xslpath=${docbookpath}/html/chunk.xsl
	;;
txt)
	xslpath=${docbookpath}/html/docbook.xsl
	post_args="| sed -e 's/&#8212;/-/g' | html2text -nobs -style pretty -o $(basename ${2%.*}.txt)"
	;;
*)
	err 1 "Unsupported format"
	;;
esac

eval ${xslt} ${xslargs} ${xslpath} ${2} ${post_args} ${output}
