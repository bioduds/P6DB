Template.create.events({
  'submit #ec-form-create'( event, instance ) {
    event.preventDefault();
    Meteor.call( "getDB", $( "#ec-db-name" ).val(), ( __error, __data )=> {
      var conditions = $( "#ec-db-conditions" ).val().replace( /"/g, '\\"');
      var tables = $( "#ec-db-tables" ).val().replace( /"/g, '\\"');
      var hash = $( "#ec-db-hash-set" ).val().replace( /"/g, '\\"');
      if( __data.length > 0 ) {
        console.log( "Mandando ver..." );
        Meteor.call( "createTable", $( "#ec-db-name" ).val(), "tableName", 
                     conditions, tables, hash, ( _error, _data )=> {
          console.debug( _data );
        });
      }
      else {
        console.log( "Essa DB não existe" );
        Meteor.call( "createDB", $( "#ec-db-name" ).val(), ( _error, _data )=> {
          console.debug( _data );
          console.log( "Mandando ver com db criada..." );
          Meteor.call( "createTable", _data, "tableName", 
                       conditions, tables, hash, ( error, data )=> {
            console.debug( data );
          });
        });
      }
    });
  },
  'submit #ec-form-create-db'( event, instance ) {
    event.preventDefault();
    Meteor.call( "getDB", $( "#ec-create-db" ).val(), ( __error, __data )=> {
      if( __data.length > 0 ) {
        console.log( "Essa DB já existe" );
      }
      else {
        Meteor.call( "createDB", $( "#ec-create-db" ).val(), ( _error, _data )=> {
          console.debug( _data );
        });
      }
    });
  }  
});