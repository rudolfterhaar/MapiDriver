unit MonetDB.Wrapper;

interface

uses Sysutils, Classes, libmapi;

type
  TField = record

    FieldName:string;
    Value:string;
    FieldType:string;
  end;

  TMonetDBConnection = class;

  TMonetDBQuery = class
    private
       conn:TMonetDBConnection;
       Handle:libmapi.MapiHdl;
       MapiMessage:MapiMsg;
       prepared:boolean;
       function FgetField(fieldno:integer):tfield;

       function fgetFieldByName(name:string):TField;
    public
      sql:string;
      procedure Execute;
      procedure Prepare;

      function FieldCount:integer;  // Return the number of fields in the current row.
      function RowCount:int64;      // If possible, return the number of rows in the last select call. A -1 is returned if this information is not available.
      function LastID:int64;        // If possible, return the last inserted id of auto_increment (or alike) column. A -1 is returned if this information is not available. We restrict this to single row inserts and one auto_increment column per table. If the restrictions do not hold, the result is unspecified.
      function RowsAffected:int64;  // Return the number of rows affected by a database update command such as SQL's INSERT/DELETE/UPDATE statements.

      function FetchRow    : integer;
      function FetchAllRows: int64;

      function SeekRow(row:int64; whence:integer):MapiMsg;
      function FetchReset :MapiMsg;

      property Field[index:integer]     : TField read FgetField;
      property FieldByName[name:string] : TField read fgetFieldByName;

      constructor create(_conn:tmonetdbconnection; _sql:string);
  end;

  TMonetDBConnection = class
     private
       mapiref :  libmapi.mapi ;
       fhost:string;
       fusername:string;
       fpassword:string;
       fdbname:string;
       flang:string;
       fport:integer;
       function fgetconnectionstatus: boolean;
       function getMapiError: MapiMsg;
       function getMapiErrorString:string;
       procedure Connect;
       procedure SetConnected(value:boolean);
     public
         function Ping:MapiMsg;       //Test availability of the server. Returns zero upon success.
        procedure DestroyConnection;  //Terminate the session described by mid if not already done so, and free all resources. The handle cannot be used anymore
        procedure Reconnect;          //Close the current channel (if still open) and re-establish a fresh connection. This will remove all global session variables.

        function OpenQuery(sql:string):TMonetDBQuery;
        function ExecSQL(sql:string):integer;  //returns rows affected


        property lang     : string  read flang     write flang;
        property dbname   : string  read fdbname   write fdbname;
        property host     : string  read fhost     write fhost;
        property port     : integer read fport     write fport;
        property username : string  read fusername write fusername;
        property password : string  read fpassword write fpassword;
        property MapiError: MapiMsg read getMapiError ;
        property MapiErrorString:string read getMapiErrorString;

        property connected:boolean read fgetconnectionstatus write setconnected;





  end;

implementation

{ TMonetDBConnection }


  procedure TMonetDBConnection.Connect;
    var utfHost:putf8char;
        utfUsername:putf8char;
        utfPassword:putf8char;
        utfLang:putf8char;
        utfDBName:putf8char;
    begin
      utfHost :=putf8char( utf8encode(host) );
      utfUsername:=putf8char(utf8encode(username));
      utfPassword:=putf8char(utf8encode(password));
      utfLang:=putf8char(utf8encode(Lang));
      utfDBName:=putf8char(utf8encode(dbname));
      self.mapiref :=  libmapi.mapi_connect(utfHost, port, utfUsername, utfPassword,utfLang,utfDBName)      ;
    end;


procedure TMonetDBConnection.DestroyConnection;
begin
  if self.mapiref<>nil then libmapi.mapi_destroy(self.mapiref);
end;

function TMonetDBConnection.ExecSQL(sql: string):integer;
var query:tmonetdbquery;
begin
  try
    query:=tmonetdbquery.create(self,sql) ;
  finally
    query.free;
  end;
end;

function TMonetDBConnection.fgetconnectionstatus: boolean;
begin
  if self.mapiref =nil
    then result:=false
    else result:=true;
end;

function TMonetDBConnection.getMapiError: MapiMsg;
  begin
    result:=mapi_error(mapiref);
  end;

function TMonetDBConnection.getMapiErrorString: string;
  begin
    result := utf8tostring(mapi_error_str(mapiref));
  end;

function TMonetDBConnection.OpenQuery(sql: string): TMonetDBQuery;
  begin
    result:=tmonetdbquery.create(self,sql);
  end;

function TMonetDBConnection.Ping: MapiMsg;
begin
  result:=mapi_ping(mapiref);
end;

procedure TMonetDBConnection.Reconnect;
begin
  if self.mapiref<>nil then libmapi.mapi_reconnect(self.mapiref);
end;

procedure TMonetDBConnection.SetConnected(value: boolean);
begin
  if value=false
    then
      begin
        if self.mapiref<>nil
          then libmapi.mapi_disconnect(self.mapiref);
      end
    else
      begin
        if mapiref=nil then self.Connect;
      end;
end;

{ TMonetDBQuery }

constructor TMonetDBQuery.create(_conn:tmonetdbconnection; _sql: string);
begin
  sql:=_sql;
  conn:=_conn;
end;

procedure TMonetDBQuery.Execute;
begin
  if Handle=nil
    then
      Handle := libmapi.mapi_query(conn.mapiref,  putf8char(utf8encode(sql)))
    else
      begin
        if prepared
          then
            begin
              prepared:=false;
              MapiMessage := libmapi.mapi_execute(self.Handle);
            end
          else
            begin
              MapiMessage := libmapi.mapi_query_handle(Handle,putf8char(utf8encode(sql)));
            end;
      end;
end;

function TMonetDBQuery.FetchAllRows: int64;
begin
   result:= libmapi.mapi_fetch_all_rows(self.Handle);
end;

function TMonetDBQuery.FetchRow: integer;
begin
  result:=libmapi.mapi_fetch_row(Handle);
end;

function TMonetDBQuery.FgetField(fieldno: integer): tfield;
begin
  result.FieldName := utf8tostring( libmapi.mapi_get_name(handle,fieldno));
  result.Value     := utf8tostring(libmapi.mapi_fetch_field(Handle,fieldno));
  result.FieldType := utf8tostring( libmapi.mapi_get_type(handle,fieldno) );
end;


function TMonetDBQuery.fgetFieldByName(name: string): TField;
var col:integer ;
    f:tfield;
begin
  result.FieldName := '';
  result.Value     := '';
  result.FieldType := '';

  for col := 0 to self.FieldCount-1 do
    begin
      f:=self.Field[col];
      if f.FieldName.ToUpper=name.ToUpper
        then
          begin
            result:=f;
            exit;
          end;

    end;
end;

function TMonetDBQuery.FieldCount: integer;
begin
  result:= libmapi.mapi_get_field_count(Handle);
end;

function TMonetDBQuery.LastID: int64;
begin
  result:=libmapi.mapi_get_last_id(Handle);
end;

procedure TMonetDBQuery.Prepare;
begin
  prepared:=true;
  self.Handle := libmapi.mapi_prepare(conn.mapiref, putf8char(utf8encode(sql)) ) ;
end;

function TMonetDBQuery.FetchReset: MapiMsg;
begin
  result:=libmapi.mapi_fetch_reset(Handle);
end;

function TMonetDBQuery.RowCount: int64;
begin
  result:=libmapi.mapi_get_row_count(Handle);
end;

function TMonetDBQuery.RowsAffected: int64;
begin
  result:=libmapi.mapi_rows_affected(Handle);

end;

function TMonetDBQuery.SeekRow(row: int64; whence: integer): MapiMsg;
begin
  result:=libmapi.mapi_seek_row(handle, row, whence);
end;

end.