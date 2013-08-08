# Ready-made Yeoman Angular seed for my workflow

A Yeoman Angular-generated seed with CoffeeScript, Rosetta, Jade and Bootstrap 3 pre-set-up.

Other changes from the generic Yeoman Angular seed:

* The "server" watch target works properly for CoffeeScript.
* The "server" watch target updates:
    *  Jade files > HTML
    * Rosetta file > LESS & SASS > CSS
    * LESS files > SASS > CSS
    * SASS files > CSS
* The Rosetta file eases sharing styles between Bootstrap and your SASS/LESS and minimises style redefinition.
* The "build" target produces more compressed code.
* E2E (end-to-end) testing is implemented and set up.
* Testing targets have ready "watch" versions.
* Gruntfile is a bit cleaner and more modular.

## Getting started

Clone this repo and install the required npm modules:

    $ git clone git@github.com:Cybolic/yeoman-angular-coffee-jade-bootstrap3-rosetta-seed.git my-project
    $ cd my-project
    $ npm install

### While developing

Run the test/watch server:

    $ grunt server

edit your files and watch the page update.

### Running the tests

    $ grunt test

or, to auto-update

    $ grunt test:watch

or, to create a JUnit style XML file e.g. for Jenkins:

    $ grunt test:junit  # outputs to test/test-results.xml

or, to run an end-to-end test:

    $ grunt test:e2e

### When it's time to ship

Build the distribution files:

    $ grunt build

and copy the `dist` directory to your server. Done.