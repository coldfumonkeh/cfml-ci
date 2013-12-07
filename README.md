[![Build Status](https://travis-ci.org/marcins/cfml-ci.png?branch=master)](https://travis-ci.org/marcins/cfml-ci)
# CFML CI

A template for integrating CFML projects with [Continous Integration](http://en.wikipedia.org/wiki/Continuous_integration) servers.  Extracted from work done for the [Framework One](https://github.com/framework-one/fw1) project.

## Background

There really isn't much out there about integrating CFML projects with CI servers like Jenkins, Bamboo or TravisCI.  Recently FW/1 had a pull request merged that "broke the build", which would have been identified if the tests were run. I thought I'd investigate the feasibility of running the FW/1 test suite on Travis CI, and after a few hours hacking managed to get it working.

There are some limitations to doing this will CFML - the main one is that CFML isn't a standalone language like Ruby or even Java, it (usually) needs to be run through a web server. This means test cases have to be run via HTTP.

Travis CI, in particular, works on virtual machines that are reset in between test runs - that means for every test run you need to setup the environment for the tests to run in. In the case of CFML, this means getting a web server running for the tests.

In it's initial implementation a copy of [Railo Express](http://www.getrailo.org/index.cfm/download/) is downloaded during the setup phase, mxunit is then downloaded and extracted into the Railo Express webroot and the working copy of the code under test is symlinked in to the webroot. This means when Railo Express starts up everything is configured and ready.

### What about Adobe ColdFusion (ACF)

Adobe doesn't provide an equivalent to Railo Express. ACF needs to be installed through an installer before it can be run.  At this stage I haven't attempted to get this kind of environment running on ACF, but I predict it will require installing ACF, setting it up, and then re-packaging that to avoid going through the installer for every test run.

## State of the project

Currently this is a bare minimum skeleton based on code extracted from FW/1 - I have some ideas to make this more generic and run on other CI servers, and suitable Issues will be created to track the progress of these features.