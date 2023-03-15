# pip-issue-11854-multipackage-repo

This repo is a reproducer for https://github.com/pypa/pip/issues/11854 in conjunction with
https://github.com/szabi/pip-issue-11854-consumer.

This is a very basic multi-package repos setup. It contains two packages, one within a namespace.

The package roots are the directories in `pkgs`, which contain the `pyproject.toml` files:

    pkgs
    ├── dist-package-one
    │   └── pyproject.toml
    └── dist-package-two
        └── pyproject.toml

The accompanying project is a consumer of the packages which tries to install them from the respective
subdirectories via the git+ssh protocol.