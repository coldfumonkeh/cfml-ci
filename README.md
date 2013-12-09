[![Build Status](https://travis-ci.org/marcins/cfml-ci.png?branch=master)](https://travis-ci.org/marcins/cfml-ci)
# CFML CI

A template for integrating CFML projects with [Continous Integration](http://en.wikipedia.org/wiki/Continuous_integration) servers.  Extracted from work done for the [Framework One](https://github.com/framework-one/fw1) project.

Use this template to add to your project so that your MXUnit test suite gets run under Railo and the results are reported on a CI server.

## Implementation Guide

### Requirement

 * a CI server (eg. [Travis CI](http://travis-ci.org/), [Jenkins](http://jenkins-ci.org/), [Bamboo](https://www.atlassian.com/software/bamboo), etc) running on Linux or Mac OS X
 * an [MXUnit](http://mxunit.org) based test suite (or the desire to create one)
 * [Apache Ant](http://ant.apache.org/) 1.9+ (older versions have a bug with waiting for shell scripts to return)
 * awk (not mawk - this was what was on the Debian Jenkins box I was testing with an it does't work), the awk built into Mac OS X is fine

### Basic requirements

To get started adding the CFML CI template to your project:
 * you need to copy the `build.xml` into your project, or if you already have a `build.xml` integrate the properties and targets
 * if you don't already have tests, copy the whole `tests` directory
   * otherwise copy the `ci` directory into your `tests` directory
 * customise the properties at the top of the `build.xml`
 * add the setup and test run command to your CI server (see below)

### Travis CI

Travis implementation is relatively straightforward, there are sensible defaults passed in the `.travis.yml` file, and the other defaults in the `build.xml` are generally fine:

 * copy the `.travis.yml` from this project into your repo root
 * in Travis CI settings, toggle Travis CI on for your Github repository
 * push a commit to Github
 * check build status on Travis CI

### Jenkins

 * Create a new project
 * Provide your source repository settings as per usual
 * add an "Invoke Ant" build step
 	* Targets: `install-ci-deps test-ci-railo`
 	* Advanced -> Properties:
 	  ```work.dir=$WORKSPACE/work```

To improve build performance you can load the Railo Express and MXUnit archives onto your build server and use local references for the Railo / MXUnit URLs - under Advanced -> Properties:

```
railo.url=/home/user/railo-express-4.1.1.009-nojre.tar.gz
mxunit.url=/home/user/fix-railo-nulls.zip
```

(This obviously assumes you have put those files under /home/user on your Jenkins server)

### Bamboo

TODO: I don't have a Bamboo install, so either someone else can write this or wait for me to get around to trying a trial!

## History

There really wasn't much out there about integrating CFML projects with CI servers like Jenkins, Bamboo or TravisCI.  Recently FW/1 had a pull request merged that "broke the build", which would have been identified if the tests were run. I thought I'd investigate the feasibility of running the FW/1 test suite on Travis CI, and after a few hours hacking managed to get it working.

There are some limitations to doing this will CFML - the main one is that CFML isn't a standalone language like Ruby or even Java, it (usually) needs to be run through a web server. This means test cases have to be run via HTTP.

Travis CI, in particular, works on virtual machines that are reset in between test runs - that means for every test run you need to setup the environment for the tests to run in. In the case of CFML, this means getting a web server running for the tests.

In it's initial implementation a copy of [Railo Express](http://www.getrailo.org/index.cfm/download/) is downloaded during the setup phase, mxunit is then downloaded and extracted into the Railo Express webroot and the working copy of the code under test is symlinked in to the webroot. This means when Railo Express starts up everything is configured and ready.

### What about Adobe ColdFusion (ACF)

Adobe doesn't provide an equivalent to Railo Express. ACF needs to be installed through an installer before it can be run.  At this stage I haven't attempted to get this kind of environment running on ACF, but I predict it will require installing ACF, setting it up, and then re-packaging that to avoid going through the installer for every test run.