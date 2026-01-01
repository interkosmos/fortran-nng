.POSIX:

PREFIX  = /usr/local

CC = gcc
FC = gfortran
AR = ar

DEBUG   = -g -O0 -Wall -std=f2018
RELEASE = -O2

CFLAGS  = $(RELEASE) -I$(PREFIX)/include
FFLAGS  = $(RELEASE)
ARFLAGS = rcs
LDFLAGS = -L$(PREFIX)/lib
LDLIBS  = -lnng
INCDIR  = $(PREFIX)/include/libfortran-nng
LIBDIR  = $(PREFIX)/lib
TARGET  = libfortran-nng.a

SRC = src/nng.F90 \
      src/nng_bus0.f90 \
      src/nng_http.f90 \
      src/nng_macro.c \
      src/nng_pair0.f90 \
      src/nng_pair1.f90 \
      src/nng_pipeline0.f90 \
      src/nng_pubsub0.f90 \
      src/nng_reqrep0.f90 \
      src/nng_survey0.f90 \
      src/nng_util.f90
OBJ = nng.o \
      nng_bus0.o \
      nng_http.o \
      nng_macro.o \
      nng_pair0.o \
      nng_pair1.o \
      nng_pipeline0.o \
      nng_pubsub0.o \
      nng_reqrep0.o \
      nng_survey0.o \
      nng_util.o

.PHONY: all clean examples install

all: $(TARGET)

examples: http_client pubsub reqrep

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -c src/nng_macro.c
	$(FC) $(FFLAGS) -c src/nng_util.f90
	$(FC) $(FFLAGS) -c src/nng.F90
	$(FC) $(FFLAGS) -c src/nng_bus0.f90
	$(FC) $(FFLAGS) -c src/nng_http.f90
	$(FC) $(FFLAGS) -c src/nng_pair0.f90
	$(FC) $(FFLAGS) -c src/nng_pair1.f90
	$(FC) $(FFLAGS) -c src/nng_pipeline0.f90
	$(FC) $(FFLAGS) -c src/nng_pubsub0.f90
	$(FC) $(FFLAGS) -c src/nng_reqrep0.f90
	$(FC) $(FFLAGS) -c src/nng_survey0.f90
	$(AR) $(ARFLAGS) $(TARGET) $(OBJ)

http_client: $(TARGET) examples/http_client.f90
	$(FC) $(FFLAGS) $(LDFLAGS) -o http_client examples/http_client.f90 $(TARGET) $(LDLIBS)

pubsub: $(TARGET) examples/pubsub.f90
	$(FC) $(FFLAGS) $(LDFLAGS) -o pubsub examples/pubsub.f90 $(TARGET) $(LDLIBS)

reqrep: $(TARGET) examples/reqrep.f90
	$(FC) $(FFLAGS) $(LDFLAGS) -o reqrep examples/reqrep.f90 $(TARGET) $(LDLIBS)

install: $(TARGET)
	@echo "--- Installing $(TARGET) to $(LIBDIR)/ ..."
	install -d $(LIBDIR)
	install -m 644 $(TARGET) $(LIBDIR)/
	@echo "--- Installing module files to $(INCDIR)/ ..."
	install -d $(INCDIR)
	install -m 644 nng.mod $(INCDIR)/
	install -m 644 nng_bus0.mod $(INCDIR)/
	install -m 644 nng_http.mod $(INCDIR)/
	install -m 644 nng_pair0.mod $(INCDIR)/
	install -m 644 nng_pair1.mod $(INCDIR)/
	install -m 644 nng_pipeline0.mod $(INCDIR)/
	install -m 644 nng_pubsub0.mod $(INCDIR)/
	install -m 644 nng_reqrep0.mod $(INCDIR)/
	install -m 644 nng_survey0.mod $(INCDIR)/
	install -m 644 nng_util.mod $(INCDIR)/

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e http_client ]; then rm http_client; fi
	if [ -e pubsub ]; then rm pubsub; fi
	if [ -e reqrep ]; then rm reqrep; fi
