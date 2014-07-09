[![Build Status](https://travis-ci.org/marcins/cfml-ci.png?branch=master)](https://travis-ci.org/marcins/cfml-ci)
# CFML CI

A template for integrating CFML projects with [Continous Integration](http://en.wikipedia.org/wiki/Continuous_integration) servers.  Extracted from work done for the [Framework One](https://github.com/framework-one/fw1) project.

Use this template to add to your project so that your test suite gets run under a clean installed ACF or Railo server, and the results are reported on a CI server.

## Implementation Guide

### Requirement

 * a CI server (eg. [Travis CI](http://travis-ci.org/), [Jenkins](http://jenkins-ci.org/), [Bamboo](https://www.atlassian.com/software/bamboo), etc) running on Linux or Mac OS X
 * a [TestBox](http://wiki.coldbox.org/wiki/TestBox.cfm) or an [MXUnit](http://mxunit.org) based test suite (or the desire to create one)
 * [Apache Ant](http://ant.apache.org/) 1.9+ (older versions have a bug with waiting for shell scripts to return)
 * awk (not mawk - this was what was on the Debian Jenkins box I was testing with an it does't work), the awk built into Mac OS X is fine

### Basic requirements

To get started adding the CFML CI template to your project:
 * you need to copy the `build.xml` into your project, or if you already have a `build.xml` integrate the properties and targets
 * if you don't already have tests, copy the whole `tests` directory
   * otherwise copy the `ci` directory into your `tests` directory
 * customise the properties at the top of the `build.xml` - there's more detail on the various options below
 * add the setup and test run command to your CI server (see below)

#### build.xml properties

##### General configuration

 * *test.project*: a short name for your project, this will be used as the context root for installing your project into the test server
 * *work.dir*: working directory where the server will be installed - this should be a directory that doesn't already exist as it gets deleted and re-created on every test run, default is /tmp/work
 * *build.dir*: directory that gets mapped into the webserver, normally this will probably just be wherever your build.xml is (the default).

 * *test.framework*: whether to use the TestBox or MXUnit test runner for your tests.

##### Platforms

cfml-ci supports both Railo (4.0+) and Adobe ColdFusion (9.0.2 and 10). You can configure the various platforms and the URLs where they will be downloaded from. For Railo, Railo Express is used as the test server as it essentially comes "ready to go" so the download comes from Railo directly. For Adobe ColdFusion an "install" is required, and so ACF has been installed, configured and re-packaged for use by cfml-ci. Downloads for this ACF re-distribution are hosted on S3.

If you are running cfml-ci in your own CI environment then it is recommended to have locally hosted copies of your target platforms, to avoid a slower download over the Internet. For Travis CI the URLs provided are fast (I assume Travis CI is on AWS as well).

You can provide both "remote" and "local" URLs (or paths), by default local will be used unless you set the source property when running ant.  Either a URL or file path starting with a / is supported for URLs (technically both for remote and local, but it doesn't make sense for remote).

To add a new platform you need to set the following properties:

 * PLATFORM.local.url
 * PLATFORM.remote.url
 * PLATFORM.helper

The "helper" is the shell script that will be used for installing, starting and stopping the server and is found in `tests/ci/scripts`. All helper scripts are of the form `ci-helper-HELPER.sh`, where HELPER is the property. If you need to add your own, see the existing scripts as a reference.

### Travis CI

Travis implementation is relatively straightforward, there are sensible defaults passed in the `.travis.yml` file, and the other defaults in the `build.xml` are generally fine:

 * copy the `.travis.yml` from this project into your repo root
 * in Travis CI settings, toggle Travis CI on for your Github repository
 * push a commit to Github
 * check build status on Travis CI

### Jenkins

 - **TODO**: update this section after the move to "platforms"
 
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

 - **TODO**: I don't have a Bamboo install, so either someone else can write this or wait for me to get around to trying a trial!

## History

There really wasn't much out there about integrating CFML projects with CI servers like Jenkins, Bamboo or TravisCI.  Recently FW/1 had a pull request merged that "broke the build", which would have been identified if the tests were run. I thought I'd investigate the feasibility of running the FW/1 test suite on Travis CI, and after a few hours hacking managed to get it working.

There are some limitations to doing this will CFML - the main one is that CFML isn't a standalone language like Ruby or even Java, it (usually) needs to be run through a web server. This means test cases have to be run via HTTP.

Travis CI, in particular, works on virtual machines that are reset in between test runs - that means for every test run you need to setup the environment for the tests to run in. In the case of CFML, this means getting a web server running for the tests.

In it's initial implementation a copy of [Railo Express](http://www.getrailo.org/index.cfm/download/) is downloaded during the setup phase, mxunit is then downloaded and extracted into the Railo Express webroot and the working copy of the code under test is symlinked in to the webroot. This means when Railo Express starts up everything is configured and ready.

Support for Adobe ColdFusion 9.0.2 and 10 was added in December 2013, after getting some verbal email based approval from Adobe to repackage a Developer install of Adobe ColdFusion for use with CI.
