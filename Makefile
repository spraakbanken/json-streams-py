.PHONY: venv help test test-w-coverage lint lint-no-fail

.default: help

help:
	@echo "usage:"

PLATFORM := ${shell uname -o}
INVENV_PATH = ${shell which invenv}

ifeq (${VIRTUAL_ENV},)
  VENV_NAME = .venv
else
  VENV_NAME = ${VIRTUAL_ENV}
endif

${info Platform: ${PLATFORM}}
${info Using ${VENV_NAME}}
${info invenv: ${INVENV_PATH}}

VENV_BIN = ${VENV_NAME}/bin

ifeq (${INVENV_PATH},)
  INVENV = export VIRTUAL_ENV="${VENV_NAME}"; export PATH="${VENV_BIN}:${PATH}"; unset PYTHON_HOME;
else
  INVENV = invenv -C ${VENV_NAME}
endif

ifeq (${PLATFORM}, Android)
  FLAKE8_FLAGS = --jobs=1
else
  FLAKE8_FLAGS = --jobs=auto
endif

PYTHON = ${VENV_BIN}/python


venv: ${VENV_NAME}/venv.created

${VENV_NAME}/venv.created:
	test -d ${VENV_NAME} || python -m venv ${VENV_NAME}
	@touch $@

${VENV_NAME}/dev.installed: setup.py setup.cfg requirements.txt
	${INVENV} python -m pip install -Ue .[dev]
	@touch $@

update-pip: venv
	${INVENV} python -m pip install --upgrade pip

install-dev: venv ${VENV_NAME}/dev.installed

test: install-dev
	${INVENV} pytest -vv tests

test-w-coverage: install-dev
	${INVENV} pytest -vv --cov=json_streams  --cov-report=term-missing tests

lint: install-dev
	${INVENV}  pylint --rcfile=.pylintrc json_streams tests

lint-no-fail: install-dev
	${INVENV}  pylint --rcfile=.pylintrc --exit-zero json_streams tests

bumpversion-major: install-dev
	${INVENV} bump2version major

bumpversion-minor: install-dev
	${INVENV} bump2version minor

bumpversion-patch: install-dev
	${INVENV} bump2version patch
