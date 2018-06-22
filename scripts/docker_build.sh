#!/bin/bash
set -e -x

# Install a system package required by our library
yum install -y gsl-devel gmp-devel

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [ "$PYBIN" == "/opt/python/cp33-cp33m/bin" ]; then
        continue
    fi
    ${PYBIN}/pip install -r /code/dev-requirements.txt
    ${PYBIN}/pip wheel /code/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair $whl -w /code/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    ${PYBIN}/pip install pysbrl --no-index -f /code/wheelhouse
    if [ "$PYBIN" == "/opt/python/cp27-cp27m/bin" ]; then
        (cd /code; ${PYBIN}/python -m py.test)
        continue
    fi
    (cd /code; ${PYBIN}/python -m pytest)
done