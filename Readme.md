LeadConduit Integration Generator

[![Build Status](https://secure.travis-ci.org/alexkwolfe/generator-leadconduit-integration.png?branch=master)](https://travis-ci.org/alexkwolfe/generator-leadconduit-integration)


### What is this?

This tool is provided for developers who wish to create a new integration for the LeadConduit platform. After asking a few
simple questions, it generates the code and tests necessary to integrate a third party system with LeadConduit. It is
intended that the generated code be customized to account for the specifics of integrating with a particular system.


### Getting Started

LeadConduit integrations are written in JavaScript or CoffeeScript on the Node.JS platform. You must have
[Node.JS installed](http://node.js/download) in order to develop integrations or use this generator.

You must also have the [Yeoman](http://yeoman.io) tool and this generator installed:

```bash
npm install -g yo
npm install -g generator-leadconduit-integration
```

Once those steps are done, you're ready to generate a new LeadConduit integration.


### How to generate a LeadConduit Integration

Make a directory for your integration and then run the generator using `yo`.

```bash
mkdir leadconduit-integration-foobar
yo leadconduit-integration
```

After answering a short series of questions, your integration will be generated. The integration code can be found
in the `src/` directory and the tests for your code can be found in the `spec/` directory.


### How to test your integration

The generator created some tests for you based on the answers you gave. You can run the tests as follows:

```bash
cake test
```

When you make changes to the code, you will also need to change the tests. We will not allow integrations on to the platform
which have broken or inadequate tests, so make sure you give due attention to the tests.


### Putting your integration into version control

We strongly recommend creating a GitHub repository for your new integration. The GitHub platform provides an excellent avenue
for collaboratively working on code. If you have never used git or GitHub before, the [GitHub Bootcamp](https://help.github.com/articles/set-up-git/)
is a great place to start reading.

Once you have [created a GitHub repository](https://help.github.com/articles/creating-a-new-repository/) for your integration,
initialize your local repository, add the GitHub repo to [as a remote](https://help.github.com/articles/adding-a-remote/),
and push your code to the remote repository.

That process looks something like:

```bash
git init .
git remote add origin https://github.com/mygithubaccount/leadconduit-integration-foobar.git
git push origin remote
```

As you make changes to your integration, commit them to your local repository, and then push them to your GitHub repo:

```bash
git commit -am "I made an important change."
git push origin master
```

Note: public GitHub repositories are visible to the entire world. Do not commit API keys or other secrets with your
integration code. Generally speaking, API keys must be provided by LeadConduit users and therefore must not be hardcoded
in your integration.


### How to ask for help

If you're trying to write an integration but are running into any sort of trouble, we're always here to help. Send an
email to our [Support Team](mailto:support@activeprospect.com) and we'll reply right away. When asking for help, it's best
if the integration is committed to GitHub so that we can look at it, pull it down, and run it as we're helping you work
through your questions.


### How to submit an integration

Once you have finished your integration and are satisfied that you have excellent test coverage, send an email to our
[Support Team](mailto:support@activeprospect.com) to let use know that you'd like to include your integration on the
LeadConduit platform.

Generally speaking there are three steps that must be taken to take your integration live:

 1. Publish your integration as an NPM package using `npm publish`
 2. Open a GitHub pull request against the [leadconduit-integrations](https://github.com/activeprospect/leadconduit-integrations)
    repository to add your integration to the [package.json](https://github.com/activeprospect/leadconduit-integrations/blob/master/package.json) file.
 3. Wait for our team to approve your integration. Once it is approved, we will merge your pull request and your
    integration will go live in our next release.


### About versioning

We use [Semantic Versioning](http://semver.org) and you should too. But if you don't know how, don't worry. We'll help
ensure that your package version makes sense before we take include it on the platform or before we allow updates to your
integration.


