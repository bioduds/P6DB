import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.html';

Perl = new Mongo.Collection( 'perl' );

Template.hello.onCreated( ()=> {
  // counter starts at 0
  //Meteor.subscribe( 'perl' );
  this.counter = new ReactiveVar(0);
  this.tecnicos = new ReactiveVar([]);
  this.dbs = new ReactiveVar([]);
  Meteor.call( "getDBs", ( _error, _data )=> {
    var jDBs = JSON.parse( _data.stdout );
    this.dbs.set( jDBs );
    console.debug( jDBs );
  });
  Meteor.call( "getPWD", ( _error, _data )=> {
    console.log( _data.stdout );
  });
}); 

Template.hello.helpers({
  counter() { return Template.instance().counter.get(); },
  tecnicos() { return Template.instance().tecnicos.get(); }
});

Template.hello.events({
  'click button'( event, instance ) {
    // increment the counter when button is clicked
    instance.counter.set(instance.counter.get() + 1);
  },
  'submit #ec-form'( event, instance ) {
    event.preventDefault();
    var op = "all";
    var key = "key";
    var value = $( "#ec-perl" ).val();
    if( $( "#ec-select-all" ).is(':selected') ) op = "all";
    if( $( "#ec-select-ec" ).is(':selected') ) {
      op = "eq";
      key = $( "#ec-perl-key" ).val();
      value = $( "#ec-perl-value" ).val();
    }
    console.log( "Sending " + value );
    Meteor.call( "getDB", "futs", ( _error, _data )=> {
      Meteor.call( "getData", _data[0]._id._str, op, key, value, ( error, data )=> {
        console.debug( data );
      });
    });
  }
});