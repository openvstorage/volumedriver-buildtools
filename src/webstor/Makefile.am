ACLOCAL_AMFLAGS = -I m4


lib_LTLIBRARIES = libwebstor.la

libwebstor_la_SOURCES = \
	asyncurl.cpp \
	wsconn.cpp \
	sysutils.cpp


bin_PROGRAMS = wsdbg wsperf wscmd


wsdbg_SOURCES = \
	wsdbg.cpp

wsperf_SOURCES = \
	wsperf.cpp

wscmd_SOURCES = \
	wscmd.cpp

EXTRA_LIBS=-lcurl -lssl -lcrypto -lxml2 -lcares -lpthread -lm -lrt

wsdbg_LDFLAGS = -Wl,--as-needed
wsdbg_LDADD = libwebstor.la  $(EXTRA_LIBS)

wsperf_LDFLAGS = -Wl,--as-needed
wsperf_LDADD = libwebstor.la  $(EXTRA_LIBS)

wscmd_LDFLAGS = -Wl,--as-needed
wscmd_LDADD = libwebstor.la  $(EXTRA_LIBS)

pkginclude_HEADERS=  \
	asyncurl.h \
	wsconn.h

noinst_HEADERS = \
	sysutils.h
