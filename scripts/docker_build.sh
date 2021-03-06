#!/bin/bash
set -e -x

# Install a system package required by our library
yum install -y gsl-devel

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "$PYBIN" =~ (cp27|cp34|cp35|cp36|cp37) ]]; then
        ${PYBIN}/pip install -r /code/dev-requirements.txt
        ${PYBIN}/pip install -r /code/test-requirements.txt
        ${PYBIN}/pip wheel /code/ -w dist/
    fi
done

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    auditwheel repair $whl --plat $PLAT -w /code/dist/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    if [[ "$PYBIN" =~ (cp27|cp34|cp35|cp36|cp37) ]]; then
        ${PYBIN}/pip install pysbrl --no-index -f /code/dist
        (cd /code; ${PYBIN}/python -m pytest)
    fi
done