=========================================
Setting up continuous integration for S2E
=========================================


.. code-block:: bash

    echo "admin" | docker secret create jenkins-pass -
    echo "admin" | docker secret create jenkins-user -
    echo "github-token-hash" | docker secret create jenkins-github-token -

    # Change the IP address, it can be any NIC IP on your system
    docker swarm init --advertise-addr 192.168.187.136

    cd jenkins

    docker build -t cyberhaven/s2e-jenkins -f Dockerfile .
    docker stack deploy -c jenkins.yml jenkins

    # Remove the passwords, we don't need them anymore once
    # the system is running
    docker secret rm jenkins-user
    docker secret rm jenkins-pass
    docker secret rm jenkins-github-token

    # Delete the jenkins stack if you don't need it anymore.
    # This will lose all the data
    docker stack rm jenkins


    curl -s -k "http://admin:admin@localhost:8080/pluginManager/api/json?depth=1"   | jq -r '.plugins[].shortName' | tee plugins.txt


Some notes on Jenkins plugins:

- Use github-pullrequest, it's pretty much the only one that works correctly. GHPRB and others don't work well with authentication tokens.