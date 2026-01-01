# fortran-nng

[![Build](https://github.com/interkosmos/fortran-nng/actions/workflows/build.yml/badge.svg)](https://github.com/interkosmos/fortran-nng/actions/workflows/build.yml)

A collection of Fortran 2018 ISO C binding interfaces to the lightweight
messaging library [NNG](https://nng.nanomsg.org/) **v1.11.0**:

> NNG, like its predecessors [nanomsg](https://github.com/nanomsg/nanomsg) (and
> to some extent [ZeroMQ](https://zeromq.org/)), is a lightweight, broker-less
> library, offering a simple API to solve common recurring messaging problems,
> such as publish/subscribe, RPC-style request/reply, or service discovery. The
> API frees the programmer from worrying about details like connection
> management, retries, and other common considerations, so that they can focus
> on the application instead of the plumbing.

The bindings cover the API of NNG v1 (stable) and are not compatible to NNG v2
(yet). Link your Fortran programs with `libfortran-nng.a` and `libnng.so`. If
_fortran-nng_ is installed to `/opt`, run:

```
$ gfortran -I/opt/include/libfortran-nng -o example example.f90 /opt/lib/libfortran-nng.a -lnng
```

## Build Instructions

On Linux, install NNG with development headers first:

```
# apt-get install libnng1 libnng-devel nng-utils
```

On FreeBSD:

```
# pkg install net/nng
```

If the NNG library is installed globally, build and install the interfaces
library simply by running:

```
$ make
$ make install PREFIX=/opt
```

To link against a static `libnng.a` library instead, run:

```
$ make LDLIBS="/path/to/libnng.a -lpthread"
```

## Fortran Package Manager

This project supports the
[Fortran Package Manager](https://github.com/fortran-lang/fpm) (FPM). To build
the project with FPM, run:

```
$ fpm build --profile release
```

The example programs are available with the ``fpm run --example`` command. You
can add *fortran-nng* to your `fpm.toml` with:

```toml
[dependencies]
fortran-nng = { git = "https://github.com/interkosmos/fortran-nng.git" }
```

## Examples

The following programs can be found in directory `examples/`:

* **http_client**: sends an HTTP GET request and outputs the response.
* **pubsub**: implements a simple pub/sub forwarder.
* **reqrep**: demonstrates request-response pattern between client and server.

Build the examples with:

```
$ make examples
```

## Compatiblity

The interfaces of _fortran-nng_ differ slightly from C API:

* Derived types do not have to be initialised like in C.
* All strings passed to the NNG interfaces have to be properly null-terminated
  with constant `c_null_char`, except for parameter strings already provided by
  the Fortran modules.
* The prefix of `nng_log_level` enumerators has been changed from `NNG_LOG_` to
  `NNG_LOG_LEVEL_` due to conflicts with procedures of the same name.
* The prefix of `nng_log_facility` enumerators has been changed from `NNG_LOG_` to
  `NNG_LOG_FACILITY_` due to conflicts with procedures of the same name.

## References

* [NNG Web Site](https://nng.nanomsg.org/)
* [NNG Documentation](https://nng.nanomsg.org/man/v1.10.0/index.html) (v1.10.0)

## Licence

ISC
