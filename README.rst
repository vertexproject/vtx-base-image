Vertex Base Image
-----------------

Dockerfiles for building Docker images used in the official Vertex Project Docker containers.

The Docker containers built from this repository do NOT have Synapse installed in them.  They contain all Synapse
dependencies and updated system packages, to ensure that Synapse is running with the latest updates.  Integrations with
pyup.io allow us to know right away when a third party module make break some functionality in Synapse.

The following images are available for use from Docker, having been built on Debian docker images:

- ``vertexproject/vtx-base-image:py311``

The following images are no longer built:

- ``vertexproject/vtx-base-image:py37``
- ``vertexproject/vtx-base-image:py38``
- ``vertexproject/vtx-base-image:py310``

Builds
------

- Circle Ci |circleci|_
- pyup.io |pyupio|_
- Docker Store https://store.docker.com/community/images/vertexproject/vtx-base-image

.. |circleci| image:: https://circleci.com/gh/vertexproject/vtx-base-image/tree/master.svg?style=svg
.. _circleci: https://circleci.com/gh/vertexproject/vtx-base-image/tree/master

.. |pyupio| image:: https://pyup.io/repos/github/vertexproject/vtx-base-image/shield.svg
.. _pyupio: https://pyup.io/repos/github/vertexproject/vtx-base-image/
