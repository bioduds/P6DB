import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';

var exec = require('sync-exec');
var Fiber = Npm.require('fibers');
var Future = Npm.require('fibers/future');

var HOME = "";

Meteor.startup(() => {
  // code to run on server at startup
  console.log( "Starting P6DB..." );
  var call = 'pwd';
  var pwd = exec( call );
  console.log( pwd.stdout );
  var stamp = pwd.stdout.split(".meteor");
  HOME = stamp[0];
});

Meteor.methods({
  'getPWD' : ()=> {
    var call = 'pwd';
    return exec( call );
  },
  'getDBs' : ()=> {
    var call = 'perl6 ../../../../../../scripts/dbs.pl'
    return exec( call );
  },
  'createDB' : ( dbName )=> {
    var future = new Future();
    new Fiber( function() {
      future.return( Files.insert( { db:dbName }) );
    }).run();
    return future.wait();
  },
  'getData' : ( file, op="all", key="key", value="f5dad591ca" )=> {
    var call = 'perl6 ../../../../../../scripts/' + file 
                + '.pl --op="' + op + '" -' + key + '="' + value + '"';
    var output = exec( call );
    return output.stdout;
  },
  'createTable' : ( dbName, tableName, conditions, tables, hash )=> {
    console.log( "Create Table..." );
    var call = 'perl6 ../../../../../../scripts/create-table.pl -db="' 
      + dbName + '" -condition="' + conditions + '" -tables="' + tables + '" -values="' 
      + hash + '"';
    console.log( call );
    var output = exec( call );
    return output.stdout;
  }
});
