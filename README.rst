=========================================
Setting up continuous integration for S2E
=========================================

S2E uses `buildkite <https://wwww.buildkite.com>`__ for continuous integration.

Deployment steps:

.. code-block:: bash

    # 1. Build the required docker images
    $ ./build-images.sh

    # 2. Start the build-kite agent
    $ TOKEN=XXX AGENT_USER=buildkite-agent ROOT_DIR=/disk/buildkite NAME=agent ./start-agent.sh
