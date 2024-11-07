unit libmapi;
{ This unit is automatically generated by Chet:
  https://github.com/neslib/Chet }

{$MINENUMSIZE 4}

interface

const
  {$IF Defined(WIN32)}
  mapilib = 'libmapi.dll';
  _PU = '';
  {$ELSEIF Defined(WIN64)}
  mapilib = 'libmapi.dll';
  _PU = '';
  {$ELSE}
    {$MESSAGE Error 'Unsupported platform'}
  {$ENDIF}

const
  _MAPI_H_INCLUDED = 1;
  _MAPI_QUERYTYPE_H_INCLUDED = 1;
  MAPI_SEEK_SET = 0;
  MAPI_SEEK_CUR = 1;
  MAPI_SEEK_END = 2;
  MOK = 0;
  MERROR = (-1);
  MTIMEOUT = (-2);
  MMORE = (-3);
  MSERVER = (-4);
  MREDIRECT = (-5);
  { TODO : Macro probably uses invalid symbol "mapi_export": }
  (* mapi_export extern __declspec ( dllimport ) *)
  { TODO : Unable to convert function-like macro: }
  (* __attribute__ ( Spec ) *)

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  PPointer = ^Pointer;
  PNativeUInt = ^NativeUInt;
  PMapiStruct = Pointer;
  PPMapiStruct = ^PMapiStruct;
  PMapiStatement = Pointer;
  PPMapiStatement = ^PMapiStatement;

  mapi_query_t = (
    Q_PARSE = 0,
    Q_TABLE = 1,
    Q_UPDATE = 2,
    Q_SCHEMA = 3,
    Q_TRANS = 4,
    Q_PREPARE = 5,
    Q_BLOCK = 6);
  Pmapi_query_t = ^mapi_query_t;
  MapiMsg = Integer;

  mapi_handshake_options_levels = (
    MAPI_HANDSHAKE_AUTOCOMMIT = 1,
    MAPI_HANDSHAKE_REPLY_SIZE = 2,
    MAPI_HANDSHAKE_SIZE_HEADER = 3,
    MAPI_HANDSHAKE_COLUMNAR_PROTOCOL = 4,
    MAPI_HANDSHAKE_TIME_ZONE = 5,
    MAPI_HANDSHAKE_OPTIONS_LEVEL = 6);
  Pmapi_handshake_options_levels = ^mapi_handshake_options_levels;
  Mapi = Pointer;
  PMapi = ^Mapi;
  MapiHdl = Pointer;
  PMapiHdl = ^MapiHdl;

function mapi_mapi(const host: PUTF8Char; port: Integer; const username: PUTF8Char; const password: PUTF8Char; const lang: PUTF8Char; const dbname: PUTF8Char): Mapi; cdecl;
  external mapilib name _PU + 'mapi_mapi';

function mapi_mapiuri(const url: PUTF8Char; const user: PUTF8Char; const pass: PUTF8Char; const lang: PUTF8Char): Mapi; cdecl;
  external mapilib name _PU + 'mapi_mapiuri';

function mapi_destroy(mid: Mapi): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_destroy';

function mapi_connect(const host: PUTF8Char; port: Integer; const username: PUTF8Char; const password: PUTF8Char; const lang: PUTF8Char; const dbname: PUTF8Char): Mapi; cdecl;
  external mapilib name _PU + 'mapi_connect';
  // Setup a connection with a Mserver at a host:port and login with username and password. If host == NULL, the local host is accessed.
  // If host starts with a '/' and the system supports it, host is actually the name of a UNIX domain socket, and port is ignored.
  // If port == 0, a default port is used. If username == NULL, the username of the owner of the client application containing the Mapi code is used.
  // If password == NULL, the password is omitted. The preferred query language is any of {sql,mil,mal,xquery }.
  // On success, the function returns a pointer to a structure with administration about the connection.

function mapi_disconnect(mid: Mapi): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_disconnect';
  // Terminate the session described by mid. The only possible uses of the handle after this call is mapi_destroy() and mapi_reconnect(). Other uses lead to failure.




function mapi_resolve(const host: PUTF8Char; port: Integer; const pattern: PUTF8Char): PPUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_resolve';


function mapi_reconnect(mid: Mapi): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_reconnect';

function mapi_ping(mid: Mapi): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_ping';

type
  mapi_setfilecallback2_getfunc = function(priv: Pointer; const filename: PUTF8Char; binary: Boolean; offset: UInt64; size: PNativeUInt): PUTF8Char; cdecl;

type
  mapi_setfilecallback2_putfunc = function(priv: Pointer; const filename: PUTF8Char; binary: Boolean; const data: Pointer; size: NativeUInt): PUTF8Char; cdecl;

procedure mapi_setfilecallback2(mid: Mapi; getfunc: mapi_setfilecallback2_getfunc; putfunc: mapi_setfilecallback2_putfunc; priv: Pointer); cdecl;
  external mapilib name _PU + 'mapi_setfilecallback2';

type
  mapi_setfilecallback_getfunc = function(priv: Pointer; const filename: PUTF8Char; binary: Boolean; offset: UInt64; size: PNativeUInt): PUTF8Char; cdecl;

type
  mapi_setfilecallback_putfunc = function(priv: Pointer; const filename: PUTF8Char; const data: Pointer; size: NativeUInt): PUTF8Char; cdecl;

procedure mapi_setfilecallback(mid: Mapi; getfunc: mapi_setfilecallback_getfunc; putfunc: mapi_setfilecallback_putfunc; priv: Pointer); cdecl;
  external mapilib name _PU + 'mapi_setfilecallback';

function mapi_error(mid: Mapi): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_error';

function mapi_error_str(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_error_str';

procedure mapi_noexplain(mid: Mapi; const errorprefix: PUTF8Char); cdecl;
  external mapilib name _PU + 'mapi_noexplain';

procedure mapi_explain(mid: Mapi; fd: PPointer); cdecl;
  external mapilib name _PU + 'mapi_explain';

procedure mapi_explain_query(hdl: MapiHdl; fd: PPointer); cdecl;
  external mapilib name _PU + 'mapi_explain_query';

procedure mapi_explain_result(hdl: MapiHdl; fd: PPointer); cdecl;
  external mapilib name _PU + 'mapi_explain_result';

procedure mapi_trace(mid: Mapi; flag: Boolean); cdecl;
  external mapilib name _PU + 'mapi_trace';

function mapi_get_trace(mid: Mapi): Boolean; cdecl;
  external mapilib name _PU + 'mapi_get_trace';

function mapi_get_time_zone(mid: Mapi): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_time_zone';

function mapi_get_autocommit(mid: Mapi): Boolean; cdecl;
  external mapilib name _PU + 'mapi_get_autocommit';

function mapi_get_columnar_protocol(mid: Mapi): Boolean; cdecl;
  external mapilib name _PU + 'mapi_get_columnar_protocol';

function mapi_log(mid: Mapi; const nme: PUTF8Char): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_log';

function mapi_set_time_zone(mid: Mapi; seconds_east_of_utc: Integer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_set_time_zone';

function mapi_setAutocommit(mid: Mapi; autocommit: Boolean): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_setAutocommit';

function mapi_set_columnar_protocol(mid: Mapi; columnar_protocol: Boolean): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_set_columnar_protocol';

function mapi_set_size_header(mid: Mapi; value: Boolean): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_set_size_header';

function mapi_release_id(mid: Mapi; id: Integer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_release_id';

function mapi_result_error(hdl: MapiHdl): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_result_error';

function mapi_result_errorcode(hdl: MapiHdl): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_result_errorcode';

function mapi_next_result(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_next_result';

function mapi_needmore(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_needmore';

function mapi_more_results(hdl: MapiHdl): Boolean; cdecl;
  external mapilib name _PU + 'mapi_more_results';

function mapi_new_handle(mid: Mapi): MapiHdl; cdecl;
  external mapilib name _PU + 'mapi_new_handle';

function mapi_close_handle(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_close_handle';

function mapi_bind(hdl: MapiHdl; fnr: Integer; ptr: PPUTF8Char): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_bind';

function mapi_bind_var(hdl: MapiHdl; fnr: Integer; &type: Integer; ptr: Pointer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_bind_var';

function mapi_bind_numeric(hdl: MapiHdl; fnr: Integer; scale: Integer; precision: Integer; ptr: Pointer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_bind_numeric';

function mapi_clear_bindings(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_clear_bindings';

function mapi_param_type(hdl: MapiHdl; fnr: Integer; ctype: Integer; sqltype: Integer; ptr: Pointer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_param_type';

function mapi_param_string(hdl: MapiHdl; fnr: Integer; sqltype: Integer; ptr: PUTF8Char; sizeptr: PInteger): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_param_string';

function mapi_param(hdl: MapiHdl; fnr: Integer; ptr: PPUTF8Char): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_param';

function mapi_param_numeric(hdl: MapiHdl; fnr: Integer; scale: Integer; precision: Integer; ptr: Pointer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_param_numeric';

function mapi_clear_params(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_clear_params';

function mapi_prepare(mid: Mapi; const cmd: PUTF8Char): MapiHdl; cdecl;
  external mapilib name _PU + 'mapi_prepare';

function mapi_prepare_handle(hdl: MapiHdl; const cmd: PUTF8Char): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_prepare_handle';

function mapi_execute(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_execute';

function mapi_fetch_reset(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_fetch_reset';

function mapi_finish(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_finish';

function mapi_query(mid: Mapi; const cmd: PUTF8Char): MapiHdl; cdecl;
  external mapilib name _PU + 'mapi_query';

function mapi_query_handle(hdl: MapiHdl; const cmd: PUTF8Char): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_query_handle';

function mapi_query_prep(mid: Mapi): MapiHdl; cdecl;
  external mapilib name _PU + 'mapi_query_prep';

function mapi_query_part(hdl: MapiHdl; const cmd: PUTF8Char; size: NativeUInt): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_query_part';

function mapi_query_done(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_query_done';

function mapi_query_abort(hdl: MapiHdl; reason: Integer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_query_abort';

function mapi_send(mid: Mapi; const cmd: PUTF8Char): MapiHdl; cdecl;
  external mapilib name _PU + 'mapi_send';

function mapi_read_response(hdl: MapiHdl): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_read_response';

function mapi_cache_limit(mid: Mapi; limit: Integer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_cache_limit';

function mapi_cache_freeup(hdl: MapiHdl; percentage: Integer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_cache_freeup';

function mapi_seek_row(hdl: MapiHdl; rowne: Int64; whence: Integer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_seek_row';

type
  mapi_set_timeout_callback = function(p1: Pointer): Boolean; cdecl;

function mapi_set_timeout(mid: Mapi; timeout: Cardinal; callback: mapi_set_timeout_callback; callback_data: Pointer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_set_timeout';

function mapi_timeout(mid: Mapi; time: Cardinal): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_timeout';

function mapi_fetch_row(hdl: MapiHdl): Integer; cdecl;
  external mapilib name _PU + 'mapi_fetch_row';

function mapi_fetch_all_rows(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_fetch_all_rows';

function mapi_get_field_count(hdl: MapiHdl): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_field_count';

function mapi_get_row_count(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_get_row_count';

function mapi_get_last_id(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_get_last_id';

function mapi_rows_affected(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_rows_affected';

function mapi_get_querytime(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_get_querytime';

function mapi_get_maloptimizertime(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_get_maloptimizertime';

function mapi_get_sqloptimizertime(hdl: MapiHdl): Int64; cdecl;
  external mapilib name _PU + 'mapi_get_sqloptimizertime';

function mapi_fetch_field(hdl: MapiHdl; fnr: Integer): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_fetch_field';

function mapi_fetch_field_len(hdl: MapiHdl; fnr: Integer): NativeUInt; cdecl;
  external mapilib name _PU + 'mapi_fetch_field_len';

function mapi_store_field(hdl: MapiHdl; fnr: Integer; outtype: Integer; outparam: Pointer): MapiMsg; cdecl;
  external mapilib name _PU + 'mapi_store_field';

function mapi_fetch_line(hdl: MapiHdl): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_fetch_line';

function mapi_split_line(hdl: MapiHdl): Integer; cdecl;
  external mapilib name _PU + 'mapi_split_line';

function mapi_get_lang(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_lang';

function mapi_get_uri(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_uri';

function mapi_get_dbname(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_dbname';

function mapi_get_host(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_host';

function mapi_get_user(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_user';

function mapi_get_mapi_version(): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_mapi_version';

function mapi_get_monet_version(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_monet_version';

function mapi_get_motd(mid: Mapi): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_motd';

function mapi_is_connected(mid: Mapi): Boolean; cdecl;
  external mapilib name _PU + 'mapi_is_connected';

function mapi_get_table(hdl: MapiHdl; fnr: Integer): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_table';

function mapi_get_name(hdl: MapiHdl; fnr: Integer): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_name';

function mapi_get_type(hdl: MapiHdl; fnr: Integer): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_type';

function mapi_get_len(hdl: MapiHdl; fnr: Integer): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_len';

function mapi_get_digits(hdl: MapiHdl; fnr: Integer): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_digits';

function mapi_get_scale(hdl: MapiHdl; fnr: Integer): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_scale';

function mapi_get_query(hdl: MapiHdl): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_get_query';

function mapi_get_querytype(hdl: MapiHdl): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_querytype';

function mapi_get_tableid(hdl: MapiHdl): Integer; cdecl;
  external mapilib name _PU + 'mapi_get_tableid';

function mapi_quote(const msg: PUTF8Char; size: Integer): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_quote';

function mapi_unquote(msg: PUTF8Char): PUTF8Char; cdecl;
  external mapilib name _PU + 'mapi_unquote';

function mapi_get_active(mid: Mapi): MapiHdl; cdecl;
  external mapilib name _PU + 'mapi_get_active';

function wsaerror(p1: Integer): PUTF8Char; cdecl;
  external mapilib name _PU + 'wsaerror';

implementation

end.