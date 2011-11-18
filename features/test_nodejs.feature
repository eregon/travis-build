Feature: Testing a Node.js project

  Background:
   Given the following test payload
     | repository | travis-ci/travis-ci                                                      |
     | commit     | 1234567                                                                  |
     | config     | language: node.js, node_js: 0.4.12, env: FOO=foo, npm_args: --dev |

  Scenario: A successful build
    When it starts a job
    Then it exports the given environment variables
     And it successfully clones the repository to the build dir with git
     And it successfully checks out the commit with git to the repository directory
     And it successfully switches to the node.js version: 0.4.12
     And it does not find the file package.json
     And it successfully runs the script: make test
     And it closes the ssh session
     And it returns the status 0
     And it has captured the following events
       | name            | data                          |
       | job:test:start  | started_at: [now]             |
       | job:test:log    | log: /Using worker/           |
       | job:test:log    | log: cd ~/builds              |
       | job:test:log    | log: export FOO               |
       | job:test:log    | log: git clone                |
       | job:test:log    | log: cd travis-ci/travis-ci   |
       | job:test:log    | log: git checkout             |
       | job:test:log    | log: nvm use 0.4.12           |
       | job:test:log    | log: make test                |
       | job:test:log    | log: /Done.* 0/               |
       | job:test:finish | finished_at: [now], status: 0 |

  Scenario: A successful with a package.json file
    When it starts a job
    Then it exports the given environment variables
     And it successfully clones the repository to the build dir with git
     And it successfully checks out the commit with git to the repository directory
     And it successfully switches to the node.js version: 0.4.12
     And it finds a file package.json and successfully installs the npm packages
     And it successfully runs the script: npm test
     And it closes the ssh session
     And it returns the status 0
     And it has captured the following events
       | name            | data                          |
       | job:test:start  | started_at: [now]             |
       | job:test:log    | log: /Using worker/           |
       | job:test:log    | log: cd ~/builds              |
       | job:test:log    | log: export FOO               |
       | job:test:log    | log: git clone                |
       | job:test:log    | log: cd travis-ci/travis-ci   |
       | job:test:log    | log: git checkout             |
       | job:test:log    | log: nvm use 0.4.12           |
       | job:test:log    | log: npm install --dev        |
       | job:test:log    | log: npm test                 |
       | job:test:log    | log: /Done.* 0/               |
       | job:test:finish | finished_at: [now], status: 0 |

  Scenario: The repository can not be cloned
    When it starts a job
    Then it exports the given environment variables
     And it fails to clone the repository to the build dir with git
     And it closes the ssh session
     And it returns the status 1

  Scenario: The commit can not be checked out
    When it starts a job
    Then it exports the given environment variables
     And it successfully clones the repository to the build dir with git
     And it fails to check out the commit with git to the repository directory
     And it closes the ssh session
     And it returns the status 1

  Scenario: The node.js version can not be activated
    When it starts a job
    Then it exports the given environment variables
     And it successfully clones the repository to the build dir with git
     And it successfully checks out the commit with git to the repository directory
     And it fails to switch to the node.js version: 0.4.12
     And it closes the ssh session
     And it returns the status 1

  Scenario: The bundle can not be installed
    When it starts a job
    Then it exports the given environment variables
     And it successfully clones the repository to the build dir with git
     And it successfully checks out the commit with git to the repository directory
     And it successfully switches to the node.js version: 0.4.12
     And it finds a file package.json but fails to install the npm packages
     And it closes the ssh session
     And it returns the status 1

  Scenario: A failing build
    When it starts a job
    Then it exports the given environment variables
     And it successfully clones the repository to the build dir with git
     And it successfully checks out the commit with git to the repository directory
     And it successfully switches to the node.js version: 0.4.12
     And it does not find the file package.json
     And it fails to run the script: make test
     And it closes the ssh session
     And it returns the status 1


