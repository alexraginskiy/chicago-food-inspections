# Chicago Food Inspection

![image](https://f.cloud.github.com/assets/925730/1580365/2924ab28-51bc-11e3-8f2a-9d73ddcceebe.png)


JavaScript app to search and view Chicago Department of Public Health’s Food Protection's inspections

Try it live at http://alexraginskiy.github.io/chicago-food-inspections/

## About the project

This is a demonstration of building a web-app that connects to the City of Chicago Data Portal.
It was written primarily in CoffeeScript using [Backbone.js](http://backbonejs.org/) and the [Chaplin framework](http://chaplinjs.org/) and assembled with [Brunch](http://brunch.io).

Currently, it connects directly to the data source using your web browser. It is hosted and served as static assets via GitHub. To learn more about the data set powering the results from this app, visit the [City of Chicago Data Portal](https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5).

The next phase of this project will include a replicated copy of the data set being served by a custom web app to allow better search results.

## Installing

If you wish to install and run this locally, you will need:
* Node.js and NPM (tested and developed on v0.10.21)
* Brunch [brunch.io](http://brunch.io) `npm install -g brunch`
* Ruby and Sass Gem (for building stylesheets)

To install:
* Clone this repo using git
* Run `npm install` & `bower install` in the cloned directory
* Run `brunch watch --server` to build and start a local web server

Running tests:
* In browser
  * Run `brunch watch --server` to build and start a local web server
  * Visit http://localhost:3333/test/
* Headless: 
  * Install [phantomjs](http://phantomjs.org/) and [mocha-phantomjs](https://github.com/metaskills/mocha-phantomjs)
  * Run `npm test` in the project directory

For more information on building and developing this app, see [Chaplin.js](http://chaplinjs.org/) and [Brunch](http://brunch.io)

### License

Copyright (c) 2013 Alex Raginskiy

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
