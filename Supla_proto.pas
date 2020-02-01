unit Supla_proto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Contnrs,
  IdGlobal;

const
  SUPLA_PROTO_VERSION = 11;
  SUPLA_PROTO_VERSION_MIN = 1;
  SUPLA_TAG_SIZE = 5;
  SUPLA_MAX_DATA_SIZE = 1536;

  SUPLA_RC_MAX_DEV_COUNT = 50;
  SUPLA_SOFTVER_MAXSIZE = 21;
  SUPLA_SOFTVERHEX_MAXSIZE = 43;

  SUPLA_GUID_SIZE = 16;
  SUPLA_GUID_HEXSIZE = 33;
  SUPLA_LOCATION_PWDHEX_MAXSIZE = 65;
  SUPLA_LOCATION_PWD_MAXSIZE = 33;
  SUPLA_ACCESSID_PWDHEX_MAXSIZE = 65;
  SUPLA_ACCESSID_PWD_MAXSIZE = 33;
  SUPLA_LOCATION_CAPTION_MAXSIZE = 401;
  SUPLA_LOCATIONPACK_MAXCOUNT = 20;
  SUPLA_CHANNEL_CAPTION_MAXSIZE = 401;
  SUPLA_CHANNELPACK_MAXCOUNT = 20;
  SUPLA_URL_HOST_MAXSIZE = 101;
  SUPLA_URL_PATH_MAXSIZE = 101;
  SUPLA_SERVER_NAME_MAXSIZE = 65;
  SUPLA_EMAIL_MAXSIZE = 256; // ver. >= 7
  SUPLA_EMAILHEX_MAXSIZE = 513; // ver. >= 7
  SUPLA_PASSWORD_MAXSIZE = 64; // ver. >= 10
  SUPLA_PASSWORDHEX_MAXSIZE = 129; // ver. >= 10
  SUPLA_AUTHKEY_SIZE = 16; // ver. >= 7
  SUPLA_AUTHKEY_HEXSIZE = 33; // ver. >= 7
  SUPLA_OAUTH_TOKEN_MAXSIZE = 256; // ver. >= 10
  SUPLA_CHANNELGROUP_PACK_MAXCOUNT = 20; // ver. >= 9
  SUPLA_CHANNELGROUP_CAPTION_MAXSIZE = 401; // ver. >= 9
  SUPLA_CHANNELVALUE_PACK_MAXCOUNT = 20; // ver. >= 9
  SUPLA_CHANNELEXTENDEDVALUE_PACK_MAXCOUNT = 5; // ver. >= 10

  SUPLA_CHANNELEXTENDEDVALUE_PACK_MAXDATASIZE = (SUPLA_MAX_DATA_SIZE - 50); // ver. >= 10
  SUPLA_CALCFG_DATA_MAXSIZE = 128; // ver. >= 10
  SUPLA_TIMEZONE_MAXSIZE = 51; // ver. >= 11

  SUPLA_CHANNELGROUP_RELATION_PACK_MAXCOUNT = 100; // ver. >= 9

  SUPLA_DCS_CALL_GETVERSION = 10;
  SUPLA_SDC_CALL_GETVERSION_RESULT = 20;
  SUPLA_SDC_CALL_VERSIONERROR = 30;
  SUPLA_DCS_CALL_PING_SERVER = 40;
  SUPLA_SDC_CALL_PING_SERVER_RESULT = 50;
  SUPLA_DS_CALL_REGISTER_DEVICE = 60;
  SUPLA_DS_CALL_REGISTER_DEVICE_B = 65; // ver. >= 2
  SUPLA_DS_CALL_REGISTER_DEVICE_C = 67; // ver. >= 6
  SUPLA_DS_CALL_REGISTER_DEVICE_D = 68; // ver. >= 7
  SUPLA_DS_CALL_REGISTER_DEVICE_E = 69; // ver. >= 10
  SUPLA_SD_CALL_REGISTER_DEVICE_RESULT = 70;
  SUPLA_CS_CALL_REGISTER_CLIENT = 80;
  SUPLA_CS_CALL_REGISTER_CLIENT_B = 85; // ver. >= 6
  SUPLA_CS_CALL_REGISTER_CLIENT_C = 86; // ver. >= 7
  SUPLA_SC_CALL_REGISTER_CLIENT_RESULT = 90;
  SUPLA_SC_CALL_REGISTER_CLIENT_RESULT_B = 92; // ver. >= 9
  SUPLA_DS_CALL_DEVICE_CHANNEL_VALUE_CHANGED = 100;
  SUPLA_DS_CALL_DEVICE_CHANNEL_EXTENDEDVALUE_CHANGED = 105; // ver. >= 10
  SUPLA_SD_CALL_CHANNEL_SET_VALUE = 110;
  SUPLA_DS_CALL_CHANNEL_SET_VALUE_RESULT = 120;
  SUPLA_SC_CALL_LOCATION_UPDATE = 130;
  SUPLA_SC_CALL_LOCATIONPACK_UPDATE = 140;
  SUPLA_SC_CALL_CHANNEL_UPDATE = 150;
  SUPLA_SC_CALL_CHANNELPACK_UPDATE = 160;
  SUPLA_SC_CALL_CHANNEL_VALUE_UPDATE = 170;
  SUPLA_CS_CALL_GET_NEXT = 180;
  SUPLA_SC_CALL_EVENT = 190;
  SUPLA_CS_CALL_CHANNEL_SET_VALUE = 200;
  SUPLA_CS_CALL_CHANNEL_SET_VALUE_B = 205; // ver. >= 3
  SUPLA_DCS_CALL_SET_ACTIVITY_TIMEOUT = 210; // ver. >= 2
  SUPLA_SDC_CALL_SET_ACTIVITY_TIMEOUT_RESULT = 220; // ver. >= 2
  SUPLA_DS_CALL_GET_FIRMWARE_UPDATE_URL = 300; // ver. >= 5
  SUPLA_SD_CALL_GET_FIRMWARE_UPDATE_URL_RESULT = 310; // ver. >= 5
  SUPLA_DCS_CALL_GET_REGISTRATION_ENABLED = 320; // ver. >= 7
  SUPLA_SDC_CALL_GET_REGISTRATION_ENABLED_RESULT = 330; // ver. >= 7
  SUPLA_CS_CALL_OAUTH_TOKEN_REQUEST = 340; // ver. >= 10
  SUPLA_SC_CALL_OAUTH_TOKEN_REQUEST_RESULT = 350; // ver. >= 10
  SUPLA_SC_CALL_CHANNELPACK_UPDATE_B = 360; // ver. >= 8
  SUPLA_SC_CALL_CHANNELPACK_UPDATE_C = 361; // ver. >= 10
  SUPLA_SC_CALL_CHANNEL_UPDATE_B = 370; // ver. >= 8
  SUPLA_SC_CALL_CHANNEL_UPDATE_C = 371; // ver. >= 10
  SUPLA_SC_CALL_CHANNELGROUP_PACK_UPDATE = 380; // ver. >= 9
  SUPLA_SC_CALL_CHANNELGROUP_PACK_UPDATE_B = 381; // ver. >= 10
  SUPLA_SC_CALL_CHANNELGROUP_RELATION_PACK_UPDATE = 390; // ver. >= 9
  SUPLA_SC_CALL_CHANNELVALUE_PACK_UPDATE = 400; // ver. >= 9
  SUPLA_SC_CALL_CHANNELEXTENDEDVALUE_PACK_UPDATE = 405; // ver. >= 10
  SUPLA_CS_CALL_SET_VALUE = 410; // ver. >= 9
  SUPLA_CS_CALL_SUPERUSER_AUTHORIZATION_REQUEST = 420; // ver. >= 10
  SUPLA_SC_CALL_SUPERUSER_AUTHORIZATION_RESULT = 430; // ver. >= 10
  SUPLA_CS_CALL_DEVICE_CALCFG_REQUEST = 440; // ver. >= 10
  SUPLA_CS_CALL_DEVICE_CALCFG_REQUEST_B = 445; // ver. >= 11
  SUPLA_SC_CALL_DEVICE_CALCFG_RESULT = 450; // ver. >= 10
  SUPLA_SD_CALL_DEVICE_CALCFG_REQUEST = 460; // ver. >= 10
  SUPLA_DS_CALL_DEVICE_CALCFG_RESULT = 470; // ver. >= 10
  SUPLA_DCS_CALL_GET_USER_LOCALTIME = 480; // ver. >= 11
  SUPLA_DCS_CALL_GET_USER_LOCALTIME_RESULT = 490; // ver. >= 11

  SUPLA_RESULT_CALL_NOT_ALLOWED = -5;
  SUPLA_RESULT_DATA_TOO_LARGE = -4;
  SUPLA_RESULT_BUFFER_OVERFLOW = -3;
  SUPLA_RESULT_DATA_ERROR = -2;
  SUPLA_RESULT_VERSION_ERROR = -1;
  SUPLA_RESULT_FALSE = 0;
  SUPLA_RESULT_TRUE = 1;

  SUPLA_RESULTCODE_NONE = 0;
  SUPLA_RESULTCODE_UNSUPORTED = 1;
  SUPLA_RESULTCODE_FALSE = 2;
  SUPLA_RESULTCODE_TRUE = 3;
  SUPLA_RESULTCODE_TEMPORARILY_UNAVAILABLE = 4;
  SUPLA_RESULTCODE_BAD_CREDENTIALS = 5;
  SUPLA_RESULTCODE_LOCATION_CONFLICT = 6;
  SUPLA_RESULTCODE_CHANNEL_CONFLICT = 7;
  SUPLA_RESULTCODE_DEVICE_DISABLED = 8;
  SUPLA_RESULTCODE_ACCESSID_DISABLED = 9;
  SUPLA_RESULTCODE_LOCATION_DISABLED = 10;
  SUPLA_RESULTCODE_CLIENT_DISABLED = 11;
  SUPLA_RESULTCODE_CLIENT_LIMITEXCEEDED = 12;
  SUPLA_RESULTCODE_DEVICE_LIMITEXCEEDED = 13;
  SUPLA_RESULTCODE_GUID_ERROR = 14;
  SUPLA_RESULTCODE_HOSTNOTFOUND = 15; // ver. >= 5
  SUPLA_RESULTCODE_CANTCONNECTTOHOST = 16; // ver. >= 5
  SUPLA_RESULTCODE_REGISTRATION_DISABLED = 17; // ver. >= 7
  SUPLA_RESULTCODE_ACCESSID_NOT_ASSIGNED = 18; // ver. >= 7
  SUPLA_RESULTCODE_AUTHKEY_ERROR = 19; // ver. >= 7
  SUPLA_RESULTCODE_NO_LOCATION_AVAILABLE = 20; // ver. >= 7
  SUPLA_RESULTCODE_USER_CONFLICT = 21; // ver. >= 7
  SUPLA_RESULTCODE_UNAUTHORIZED = 22; // ver. >= 10
  SUPLA_RESULTCODE_AUTHORIZED = 23; // ver. >= 10

  SUPLA_OAUTH_RESULTCODE_ERROR = 0; // ver. >= 10
  SUPLA_OAUTH_RESULTCODE_SUCCESS = 1; // ver. >= 10
  SUPLA_OAUTH_TEMPORARILY_UNAVAILABLE = 2; // ver. >= 10

  SUPLA_DEVICE_NAME_MAXSIZE = 201;
  SUPLA_DEVICE_NAMEHEX_MAXSIZE = 401;
  SUPLA_CLIENT_NAME_MAXSIZE = 201;
  SUPLA_CLIENT_NAMEHEX_MAXSIZE = 401;
  SUPLA_SENDER_NAME_MAXSIZE = 201;

  SUPLA_CHANNELMAXCOUNT = 128;

  SUPLA_CHANNELVALUE_SIZE = 8;
  SUPLA_CHANNELEXTENDEDVALUE_SIZE = 1024;

  SUPLA_CHANNELTYPE_SENSORNO = 1000;
  SUPLA_CHANNELTYPE_SENSORNC = 1010; // ver. >= 4
  SUPLA_CHANNELTYPE_DISTANCESENSOR = 1020; // ver. >= 5
  SUPLA_CHANNELTYPE_CALLBUTTON = 1500; // ver. >= 4
  SUPLA_CHANNELTYPE_RELAYHFD4 = 2000;
  SUPLA_CHANNELTYPE_RELAYG5LA1A = 2010;
  SUPLA_CHANNELTYPE_2XRELAYG5LA1A = 2020;
  SUPLA_CHANNELTYPE_RELAY = 2900;
  SUPLA_CHANNELTYPE_THERMOMETERDS18B20 = 3000;
  SUPLA_CHANNELTYPE_DHT11 = 3010; // ver. >= 4
  SUPLA_CHANNELTYPE_DHT22 = 3020; // ver. >= 4
  SUPLA_CHANNELTYPE_DHT21 = 3022; // ver. >= 5
  SUPLA_CHANNELTYPE_AM2302 = 3030; // ver. >= 4
  SUPLA_CHANNELTYPE_AM2301 = 3032; // ver. >= 5

  SUPLA_CHANNELTYPE_THERMOMETER = 3034; // ver. >= 8
  SUPLA_CHANNELTYPE_HUMIDITYSENSOR = 3036; // ver. >= 8
  SUPLA_CHANNELTYPE_HUMIDITYANDTEMPSENSOR = 3038; // ver. >= 8
  SUPLA_CHANNELTYPE_WINDSENSOR = 3042; // ver. >= 8
  SUPLA_CHANNELTYPE_PRESSURESENSOR = 3044; // ver. >= 8
  SUPLA_CHANNELTYPE_RAINSENSOR = 3048; // ver. >= 8
  SUPLA_CHANNELTYPE_WEIGHTSENSOR = 3050; // ver. >= 8
  SUPLA_CHANNELTYPE_WEATHER_STATION = 3100; // ver. >= 8

  SUPLA_CHANNELTYPE_DIMMER = 4000; // ver. >= 4
  SUPLA_CHANNELTYPE_RGBLEDCONTROLLER = 4010; // ver. >= 4
  SUPLA_CHANNELTYPE_DIMMERANDRGBLED = 4020; // ver. >= 4

  SUPLA_CHANNELTYPE_ELECTRICITY_METER = 5000; // ver. >= 10
  SUPLA_CHANNELTYPE_IMPULSE_COUNTER = 5010; // ver. >= 10

  SUPLA_CHANNELTYPE_THERMOSTAT = 6000; // ver. >= 11
  SUPLA_CHANNELTYPE_THERMOSTAT_HEATPOL_HOMEPLUS = 6010; // ver. >= 11

  SUPLA_CHANNELDRIVER_MCP23008 = 2;

  SUPLA_CHANNELFNC_NONE = 0;
  SUPLA_CHANNELFNC_CONTROLLINGTHEGATEWAYLOCK = 10;
  SUPLA_CHANNELFNC_CONTROLLINGTHEGATE = 20;
  SUPLA_CHANNELFNC_CONTROLLINGTHEGARAGEDOOR = 30;
  SUPLA_CHANNELFNC_THERMOMETER = 40;
  SUPLA_CHANNELFNC_HUMIDITY = 42;
  SUPLA_CHANNELFNC_HUMIDITYANDTEMPERATURE = 45;
  SUPLA_CHANNELFNC_OPENINGSENSOR_GATEWAY = 50;
  SUPLA_CHANNELFNC_OPENINGSENSOR_GATE = 60;
  SUPLA_CHANNELFNC_OPENINGSENSOR_GARAGEDOOR = 70;
  SUPLA_CHANNELFNC_NOLIQUIDSENSOR = 80;
  SUPLA_CHANNELFNC_CONTROLLINGTHEDOORLOCK = 90;
  SUPLA_CHANNELFNC_OPENINGSENSOR_DOOR = 100;
  SUPLA_CHANNELFNC_CONTROLLINGTHEROLLERSHUTTER = 110;
  SUPLA_CHANNELFNC_OPENINGSENSOR_ROLLERSHUTTER = 120;
  SUPLA_CHANNELFNC_POWERSWITCH = 130;
  SUPLA_CHANNELFNC_LIGHTSWITCH = 140;
  SUPLA_CHANNELFNC_RING = 150;
  SUPLA_CHANNELFNC_ALARM = 160;
  SUPLA_CHANNELFNC_NOTIFICATION = 170;
  SUPLA_CHANNELFNC_DIMMER = 180;
  SUPLA_CHANNELFNC_RGBLIGHTING = 190;
  SUPLA_CHANNELFNC_DIMMERANDRGBLIGHTING = 200;
  SUPLA_CHANNELFNC_DEPTHSENSOR = 210; // ver. >= 5
  SUPLA_CHANNELFNC_DISTANCESENSOR = 220; // ver. >= 5
  SUPLA_CHANNELFNC_OPENINGSENSOR_WINDOW = 230; // ver. >= 8
  SUPLA_CHANNELFNC_MAILSENSOR = 240; // ver. >= 8
  SUPLA_CHANNELFNC_WINDSENSOR = 250; // ver. >= 8
  SUPLA_CHANNELFNC_PRESSURESENSOR = 260; // ver. >= 8
  SUPLA_CHANNELFNC_RAINSENSOR = 270; // ver. >= 8
  SUPLA_CHANNELFNC_WEIGHTSENSOR = 280; // ver. >= 8
  SUPLA_CHANNELFNC_WEATHER_STATION = 290; // ver. >= 8
  SUPLA_CHANNELFNC_STAIRCASETIMER = 300; // ver. >= 8
  SUPLA_CHANNELFNC_ELECTRICITY_METER = 310; // ver. >= 10
  SUPLA_CHANNELFNC_GAS_METER = 320; // ver. >= 10
  SUPLA_CHANNELFNC_WATER_METER = 330; // ver. >= 10
  SUPLA_CHANNELFNC_THERMOSTAT = 400; // ver. >= 11
  SUPLA_CHANNELFNC_THERMOSTAT_HEATPOL_HOMEPLUS = 410; // ver. >= 11

  SUPLA_BIT_RELAYFUNC_CONTROLLINGTHEGATEWAYLOCK = $0001;
  SUPLA_BIT_RELAYFUNC_CONTROLLINGTHEGATE = $0002;
  SUPLA_BIT_RELAYFUNC_CONTROLLINGTHEGARAGEDOOR = $0004;
  SUPLA_BIT_RELAYFUNC_CONTROLLINGTHEDOORLOCK = $0008;
  SUPLA_BIT_RELAYFUNC_CONTROLLINGTHEROLLERSHUTTER = $0010;
  SUPLA_BIT_RELAYFUNC_POWERSWITCH = $0020;
  SUPLA_BIT_RELAYFUNC_LIGHTSWITCH = $0040;
  SUPLA_BIT_RELAYFUNC_STAIRCASETIMER = $0080; // ver. >= 8

  SUPLA_EVENT_CONTROLLINGTHEGATEWAYLOCK = 10;
  SUPLA_EVENT_CONTROLLINGTHEGATE = 20;
  SUPLA_EVENT_CONTROLLINGTHEGARAGEDOOR = 30;
  SUPLA_EVENT_CONTROLLINGTHEDOORLOCK = 40;
  SUPLA_EVENT_CONTROLLINGTHEROLLERSHUTTER = 50;
  SUPLA_EVENT_POWERONOFF = 60;
  SUPLA_EVENT_LIGHTONOFF = 70;
  SUPLA_EVENT_STAIRCASETIMERONOFF = 80; // ver. >= 9

  SUPLA_URL_PROTO_HTTP = $01;
  SUPLA_URL_PROTO_HTTPS = $02;

  SUPLA_PLATFORM_UNKNOWN = 0;
  SUPLA_PLATFORM_ESP8266 = 1;

  SUPLA_TARGET_CHANNEL = 0;
  SUPLA_TARGET_GROUP = 1;

  SUPLA_MFR_UNKNOWN = 0;
  SUPLA_MFR_ACSOFTWARE = 1;
  SUPLA_MFR_TRANSCOM = 2;
  SUPLA_MFR_LOGI = 3;
  SUPLA_MFR_ZAMEL = 4;
  SUPLA_MFR_NICE = 5;
  SUPLA_MFR_ITEAD = 6;
  SUPLA_MFR_DOYLETRATT = 7;
  SUPLA_MFR_HEATPOL = 8;
  SUPLA_MFR_FAKRO = 9;

  sproto_tag: array [0 .. SUPLA_TAG_SIZE - 1] of AnsiChar = ('S', 'U', 'P', 'L', 'A');

  // Licznik energii
  EM_VAR_FREQ = $0001;
  EM_VAR_VOLTAGE = $0002;
  EM_VAR_CURRENT = $0004;
  EM_VAR_POWER_ACTIVE = $0008;
  EM_VAR_POWER_REACTIVE = $0010;
  EM_VAR_POWER_APPARENT = $0020;
  EM_VAR_POWER_FACTOR = $0040;
  EM_VAR_PHASE_ANGLE = $0080;
  EM_VAR_FORWARD_ACTIVE_ENERGY = $0100;
  EM_VAR_REVERSE_ACTIVE_ENERGY = $0200;
  EM_VAR_FORWARD_REACTIVE_ENERGY = $0400;
  EM_VAR_REVERSE_REACTIVE_ENERGY = $0800;
  EM_VAR_CURRENT_OVER_65A = $1000;
  EM_VAR_ALL = $FFFF;

  EM_MEASUREMENT_COUNT = 5;

  EV_TYPE_ELECTRICITY_METER_MEASUREMENT_V1 = 10;
  EV_TYPE_IMPULSE_COUNTER_DETAILS_V1 = 20;
  EV_TYPE_THERMOSTAT_DETAILS_V1 = 30;

  EM_VALUE_FLAG_PHASE1_ON = $01;
  EM_VALUE_FLAG_PHASE2_ON = $02;
  EM_VALUE_FLAG_PHASE3_ON = $04;

  // Thermostat fields - ver. >= 11
  THERMOSTAT_FIELD_MeasuredTemperatures = $01;
  THERMOSTAT_FIELD_PresetTemperatures = $02;
  THERMOSTAT_FIELD_Flags = $04;
  THERMOSTAT_FIELD_Values = $08;
  THERMOSTAT_FIELD_Time = $10;
  THERMOSTAT_FIELD_Schedule = $20;
  THERMOSTAT_FIELD_All = THERMOSTAT_FIELD_MeasuredTemperatures or THERMOSTAT_FIELD_PresetTemperatures or
    THERMOSTAT_FIELD_Flags or THERMOSTAT_FIELD_Values or THERMOSTAT_FIELD_Time or THERMOSTAT_FIELD_Schedule;

  THERMOSTATE_PROG_ECO = 1;
  THERMOSTATE_PROG_COMFORT = 2;

  // Thermostat configuration commands - ver. >= 11
  SUPLA_THERMOSTAT_CMD_TURNON = 1;
  SUPLA_THERMOSTAT_CMD_SET_MODE_AUTO = 2;
  SUPLA_THERMOSTAT_CMD_SET_MODE_COOL = 3;
  SUPLA_THERMOSTAT_CMD_SET_MODE_HEAT = 4;
  SUPLA_THERMOSTAT_CMD_SET_MODE_NORMAL = 5;
  SUPLA_THERMOSTAT_CMD_SET_MODE_ECO = 6;
  SUPLA_THERMOSTAT_CMD_SET_MODE_TURBO = 7;
  SUPLA_THERMOSTAT_CMD_SET_MODE_DRY = 8;
  SUPLA_THERMOSTAT_CMD_SET_MODE_FANONLY = 9;
  SUPLA_THERMOSTAT_CMD_SET_MODE_PURIFIER = 10;
  SUPLA_THERMOSTAT_CMD_SET_SCHEDULE = 11;
  SUPLA_THERMOSTAT_CMD_SET_TIME = 12;
  SUPLA_THERMOSTAT_CMD_SET_TEMPERATURE = 13;

  THERMOSTAT_SCHEDULE_HOURVALUE_TYPE_TEMPERATURE = 0;
  THERMOSTAT_SCHEDULE_HOURVALUE_TYPE_PROGRAM = 1;

type
  _supla_int_t = integer;
  bytes = array of byte;
  AnsiChars = array of AnsiChar;
  TSuplaGuid = array [0 .. SUPLA_GUID_SIZE - 1] of AnsiChar;
  TSuplaAuthKey = array [0 .. SUPLA_AUTHKEY_SIZE - 1] of AnsiChar;

  TSuplaDataPacket = packed record
    tag: array [0 .. SUPLA_TAG_SIZE - 1] of AnsiChar;
    version: byte;
    rr_id: cardinal;
    call_type: cardinal;
    data_size: cardinal;
    data: array [0 .. SUPLA_MAX_DATA_SIZE - 1] of byte;
    function setData(_call_type: cardinal; var dt; sz: integer): integer;
  end;

  // [IODevice->Server->Client]
  TElectricityMeter_Value = packed record // v. >= 10
    flags: byte;
    total_forward_active_energy: cardinal; // * 0.01 kW
    procedure Zero;
  end;

  TDS_ImpulseCounter_Value = packed record //
    counter: Uint64;
  end;

  TThermostat_Value = packed record
    IsOn: byte;
    flags: byte;
    MeasuredTemperature: smallint; // * 0.01
    PresetTemperature: smallint; // * 0.01
  end;

  TSuplaVal = record
    dt: array [0 .. SUPLA_CHANNELVALUE_SIZE - 1] of byte;
    function getAsString: string;
    function loadFromStr(s: string): boolean;
    procedure Zero;
    procedure setAsDouble(db: double);
    procedure setAsUint64(db: Uint64);
    procedure setInt_1(x: integer);
    procedure setInt_2(x: integer);
    procedure setFromElectricityMeter(elV: TElectricityMeter_Value);
    procedure setFromThermostat(th: TThermostat_Value);

    function getAsFloat: double;
    function getInt_1: integer;
    function getInt_2: integer;
  end;

  TDS_SuplaDeviceChannel_B = packed record // ver. >= 2
    // device -> server
    Number: byte;
    TypeM: _supla_int_t;
    FuncList: _supla_int_t;
    Default: _supla_int_t;
    value: TSuplaVal;
    procedure SetValueAsDouble(d: double);
  end;

  TDS_SuplaRegisterDevice_D = packed record // ver. >= 7
    // device -> server
    Email: array [0 .. SUPLA_EMAIL_MAXSIZE - 1] of AnsiChar; // UTF8
    AuthKey: TSuplaAuthKey;
    GUID: TSuplaGuid;
    Name: array [0 .. SUPLA_DEVICE_NAME_MAXSIZE - 1] of AnsiChar;
    SoftVer: array [0 .. SUPLA_SOFTVER_MAXSIZE - 1] of AnsiChar;
    ServerName: array [0 .. SUPLA_SERVER_NAME_MAXSIZE - 1] of AnsiChar;
    channel_count: byte;
    channels: array [0 .. SUPLA_CHANNELMAXCOUNT - 1] of TDS_SuplaDeviceChannel_B; // Last variable in struct!
    procedure Init(_Email, _svrName, _DevName, _softVer: string);
    function AddChn(_TypeCh, _FuncList, _Default: _supla_int_t): integer;
  end;

  TSuplaProtoData = packed record
    next_rr_id: cardinal;
    version: byte;
    procedure IncRRId;
    procedure Init;
  end;

  (*
    union TsrpcDataPacketData {
    TDCS_SuplaPingServer *dcs_ping;
    TSDC_SuplaPingServerResult *sdc_ping_result;
    TSDC_SuplaGetVersionResult *sdc_getversion_result;
    TSDC_SuplaVersionError *sdc_version_error;
    TDCS_SuplaSetActivityTimeout *dcs_set_activity_timeout;
    TSDC_SuplaSetActivityTimeoutResult *sdc_set_activity_timeout_result;
    TDS_SuplaRegisterDevice *ds_register_device;
    TDS_SuplaRegisterDevice_B *ds_register_device_b;
    TDS_SuplaRegisterDevice_C *ds_register_device_c;
    TDS_SuplaRegisterDevice_D *ds_register_device_d;
    TDS_SuplaRegisterDevice_E *ds_register_device_e;
    TSD_SuplaRegisterDeviceResult *sd_register_device_result;
    TCS_SuplaRegisterClient *cs_register_client;
    TCS_SuplaRegisterClient_B *cs_register_client_b;
    TCS_SuplaRegisterClient_C *cs_register_client_c;
    TSC_SuplaRegisterClientResult *sc_register_client_result;
    TSC_SuplaRegisterClientResult_B *sc_register_client_result_b;
    TDS_SuplaDeviceChannelValue *ds_device_channel_value;
    TDS_SuplaDeviceChannelExtendedValue *ds_device_channel_extendedvalue;
    TSC_SuplaLocation *sc_location;
    TSC_SuplaLocationPack *sc_location_pack;
    TSC_SuplaChannel *sc_channel;
    TSC_SuplaChannel_B *sc_channel_b;
    TSC_SuplaChannel_C *sc_channel_c;
    TSC_SuplaChannelPack *sc_channel_pack;
    TSC_SuplaChannelPack_B *sc_channel_pack_b;
    TSC_SuplaChannelPack_C *sc_channel_pack_c;
    TSC_SuplaChannelValue *sc_channel_value;
    TSC_SuplaEvent *sc_event;
    TSD_SuplaChannelNewValue *sd_channel_new_value;
    TDS_SuplaChannelNewValueResult *ds_channel_new_value_result;
    TCS_SuplaChannelNewValue *cs_channel_new_value;
    TCS_SuplaChannelNewValue_B *cs_channel_new_value_b;
    TDS_FirmwareUpdateParams *ds_firmware_update_params;
    TSD_FirmwareUpdate_UrlResult *sc_firmware_update_url_result;
    TSDC_RegistrationEnabled *sdc_reg_enabled;
    TSC_SuplaChannelGroupPack *sc_channelgroup_pack;
    TSC_SuplaChannelGroupPack_B *sc_channelgroup_pack_b;
    TSC_SuplaChannelGroupRelationPack *sc_channelgroup_relation_pack;
    TSC_SuplaChannelValuePack *sc_channelvalue_pack;
    TSC_SuplaChannelExtendedValuePack *sc_channelextendedvalue_pack;
    TCS_SuplaNewValue *cs_new_value;
    TSC_OAuthTokenRequestResult *sc_oauth_tokenrequest_result;
    TCS_SuperUserAuthorizationRequest *cs_superuser_authorization_request;
    TSC_SuperUserAuthorizationResult *sc_superuser_authorization_result;
    TCS_DeviceCalCfgRequest *cs_device_calcfg_request;
    TCS_DeviceCalCfgRequest_B *cs_device_calcfg_request_b;
    TSC_DeviceCalCfgResult *sc_device_calcfg_result;
    TSD_DeviceCalCfgRequest *sd_device_calcfg_request;
    TDS_DeviceCalCfgResult *ds_device_calcfg_result;
    TSDC_UserLocalTimeResult *sdc_user_localtime_result;
    };
  *)
  TsrpcDataPacketData = TIdBytes;

  TSD_SuplaRegisterDeviceResult = packed record
    // server -> device
    result_code: _supla_int_t;
    activity_timeout: byte;
    version: byte;
    version_min: byte;
  end;

  TSD_SuplaChannelNewValue = packed record
    // server -> device
    SenderID: _supla_int_t;
    ChannelNumber: byte;
    DurationMS: _supla_int_t;
    value: TSuplaVal;
  end;

  TElectricityMeter_Measurement = packed record // v. >= 10
    // 3 phases
    freq: word; // * 0.01 Hz
    voltage: array [0 .. 2] of word; // * 0.01 V
    current: array [0 .. 2] of word; // * 0.001 A (0.01A FOR EM_VAR_CURRENT_OVER_65A)
    power_active: array [0 .. 2] of _supla_int_t; // * 0.00001 kW
    power_reactive: array [0 .. 2] of _supla_int_t; // * 0.00001 kvar
    power_apparent: array [0 .. 2] of _supla_int_t; // * 0.00001 kVA
    power_factor: array [0 .. 2] of smallint; // * 0.001
    phase_angle: array [0 .. 2] of smallint; // * 0.1 degree
  end;

  TMyCurrency = packed record
    dt: array [0 .. 2] of AnsiChar;
    procedure LoadFromString(txt: string);
    function getAsString: string;
  end;

  TMyCustomUnit = packed record
    dt: array [0 .. 8] of AnsiChar;
    procedure LoadFromString(txt: string);
    function getAsString: string;
  end;

  TElectricityMeter_ExtendedValue = packed record // v. >= 10
    // [IODevice->Server->Client]
    total_forward_active_energy: array [0 .. 2] of Uint64;
    total_reverse_active_energy: array [0 .. 2] of Uint64;
    total_forward_reactive_energy: array [0 .. 2] of Uint64;
    total_reverse_reactive_energy: array [0 .. 2] of Uint64;

    // The price per unit, total cost and currency is overwritten by the server
    // total_cost == SUM(total_forward_active_energy[n] * price_per_unit
    total_cost: _supla_int_t; // * 0.01
    price_per_unit: _supla_int_t; // * 0.0001
    // Currency Code A https://www.nationsonline.org/oneworld/currencies.htm
    currency: TMyCurrency;

    measured_values: _supla_int_t;
    period: _supla_int_t; // Approximate period between measurements in seconds
    m_count: _supla_int_t;
    m: array [0 .. EM_MEASUREMENT_COUNT - 1] of TElectricityMeter_Measurement; // Last variable in struct!
    procedure getAsShortValue(var val: TSuplaVal);
  end;

  TSC_ImpulseCounter_ExtendedValue = packed record // v. >= 10
    // The price per unit, total cost and currency is overwritten by the server
    // total_cost = calculated_value * price_per_unit
    total_cost: _supla_int_t; // * 0.01
    price_per_unit: _supla_int_t; // * 0.0001
    // Currency Code A https://www.nationsonline.org/oneworld/currencies.htm
    currency: TMyCurrency;
    custom_unit: TMyCustomUnit; // UTF8 including the terminating null byte ('\0')
    impulses_per_unit: _supla_int_t;
    counter: Uint64;
    calculated_value: Uint64; // * 0.001
    procedure getAsShortValue(var val: TSuplaVal);
  end;

  TThermostat_Time = packed record // v. >= 11
    sec: byte; // 0-59
    min: byte; // 0-59
    hour: byte; // 0-24
    dayOfWeek: byte; // 1 = Sunday, 2 = Monday, , 7 = Saturday
  end;

  TThermostat_Schedule_HourTab = array [0 .. 23] of byte;

  TThermostat_Schedule_Cmd = packed record
    flag: byte;
    Days: byte;
    Hours: TThermostat_Schedule_HourTab;
  end;

  TThermostat_Schedule = packed record // v. >= 11
    ValueType: byte; // THERMOSTAT_SCHEDULE_HOURVALUE_TYPE_
    // 7 days x 24h
    // 0 = Sunday, 1 = Monday, …, 6 = Saturday
    HourValue: array [0 .. 6] of TThermostat_Schedule_HourTab;
    procedure SetFromCmd(buf: bytes);
  end;

  TThermostat_ExtendedValue = packed record // v. >= 11
    Fields: byte;
    MeasuredTemperature: array [0 .. 9] of smallint; // * 0.01
    PresetTemperature: array [0 .. 9] of smallint; // * 0.01
    flags: array [0 .. 7] of smallint;
    Values: array [0 .. 7] of smallint;
    Time: TThermostat_Time;
    Schedule: TThermostat_Schedule; // 7 days x 24h (4bit/hour)

    procedure setFlagBit(flagNr, bitNr: integer; q: boolean);
    function getFlagBit(flagNr, bitNr: integer): boolean;

    procedure getAsShortValue(IsOn: boolean; var val: TSuplaVal);
    procedure Init;

    procedure setThermostatOn(q: boolean);
    function getThermostatOn: boolean;
    procedure setAutoMode(q: boolean);
    function getAutoMode: boolean;
    procedure setEcoMode(q: boolean);
    function getEcoMode: boolean;
    procedure setTurboMode(q: boolean);
    function getTurboMode: boolean;
  end;

  TDS_SuplaDeviceChannelValue = packed record
    // device -> server
    ChannelNumber: byte;
    value: TSuplaVal;
  end;

  TDS_SuplaDeviceChannelValueTab = array of TDS_SuplaDeviceChannelValue;

  TSuplaChannelExtendedValue = packed record // v. >= 10
    Evtype: byte; // EV_TYPE_
    size: cardinal;
    value: array [0 .. SUPLA_CHANNELEXTENDEDVALUE_SIZE - 1] of AnsiChar; // Last variable in struct!

    function loadFromElectricityMeter(const em: TElectricityMeter_ExtendedValue): boolean;
    function loadFromImpulseCounter(const imp: TSC_ImpulseCounter_ExtendedValue): boolean;
    function loadFromThermostat(const th: TThermostat_ExtendedValue): boolean;
  end;

  TDS_SuplaDeviceChannelExtendedValue = packed record // v. >= 10
    // device -> server
    ChannelNumber: byte;
    value: TSuplaChannelExtendedValue; // Last variable in struct!
  end;

  TSrpcReceivedData = packed record
    call_type: cardinal;
    rr_id: cardinal;
    data: TsrpcDataPacketData;
  end;

  TSrpcReceivedDataTab = array of TSrpcReceivedData;

  TSD_DeviceCalCfgRequest = packed record
    SenderID: _supla_int_t;
    ChannelNumber: _supla_int_t;
    Command: _supla_int_t;
    SuperUserAuthorized: byte;
    DataType: _supla_int_t;
    DataSize: cardinal;
    data: array [0 .. SUPLA_CALCFG_DATA_MAXSIZE - 1] of byte; // Last variable in struct!
  end;



  // ----------------------------------------------------------------------------
  // definicjae VCL                                                            .
  // ----------------------------------------------------------------------------

type

  TChannelTypeObj = class(TObject)
    TypeCh: integer;
    TypName: string;
  end;

  TChannelTypeList = class(TObjectList)
  private
    function FGetItem(Index: integer): TChannelTypeObj;
  public
    property Items[Index: integer]: TChannelTypeObj read FGetItem;
    procedure Add(aType: integer; aName: string);
    function getTypeIndex(chType: integer): integer;
    procedure LoadNames(SL: TStrings);
    function getTypeName(ChannelType: integer): string;
  end;

function CheckSuplaTag(var dt): boolean;
function getChanelTypeName(chType: integer): string;

var
  ChannelTypeList: TChannelTypeList;

implementation

procedure setAnsiChar(var Dst; sz: integer; str: string);
var
  pch: pAnsiChar;
  i, k: integer;
begin
  pch := pAnsiChar(@Dst);
  fillchar(Dst, sz, ' ');
  k := 0;
  for i := 1 to length(str) do
  begin
    pch^ := AnsiChar(str[i]);
    inc(k);
    inc(pch);
    if k = sz then
      break;
  end;
  if k < sz - 1 then
    pch^ := #0;
end;

function CheckSuplaTag(var dt): boolean;
var
  pch: pAnsiChar;
  i: integer;
begin
  Result := true;
  pch := pAnsiChar(@dt);
  for i := 0 to SUPLA_TAG_SIZE - 1 do
  begin
    if sproto_tag[i] <> pch^ then
      Result := false;
    inc(pch);
  end;
end;

function TSuplaDataPacket.setData(_call_type: cardinal; var dt; sz: integer): integer;
begin
  fillchar(self, sizeof(self), 0);
  call_type := _call_type;
  move(sproto_tag, tag, SUPLA_TAG_SIZE);
  if sz <= SUPLA_MAX_DATA_SIZE then
  begin
    data_size := sz;
    move(dt, data, sz);
    Result := sizeof(self) - SUPLA_MAX_DATA_SIZE + sz;
  end
  else
    Result := SUPLA_RESULT_DATA_ERROR;
end;

function TSuplaVal.getAsString: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to SUPLA_CHANNELVALUE_SIZE - 1 do
  begin
    Result := Result + IntToHex(dt[i], 2);
  end;
end;

function TSuplaVal.loadFromStr(s: string): boolean;
var
  i: integer;
begin
  Result := false;
  if length(s) = 2 * SUPLA_CHANNELVALUE_SIZE then
  begin
    try
      for i := 0 to SUPLA_CHANNELVALUE_SIZE - 1 do
      begin
        dt[i] := StrToInt('$' + copy(s, 1 + 2 * i, 2));
      end;
      Result := true;
    except
      Result := false;
    end;
  end;
end;

procedure TSuplaVal.Zero;
begin
  fillchar(dt, 8, 0);
end;

procedure TSuplaVal.setAsDouble(db: double);
begin
  move(db, dt, 8);
end;

procedure TSuplaVal.setAsUint64(db: Uint64);
begin
  move(db, dt, 8);
end;

procedure TSuplaVal.setInt_1(x: integer);
begin
  move(x, dt[0], 4);
end;

procedure TSuplaVal.setInt_2(x: integer);
begin
  move(x, dt[4], 4);
end;

procedure TSuplaVal.setFromElectricityMeter(elV: TElectricityMeter_Value);
begin
  Zero;
  move(elV, dt[0], sizeof(elV));
end;

procedure TSuplaVal.setFromThermostat(th: TThermostat_Value);
begin
  Zero;
  move(th, dt[0], sizeof(th));
end;

function TSuplaVal.getAsFloat: double;
begin
  move(dt, Result, 8);
end;

function TSuplaVal.getInt_1: integer;
begin
  move(dt, Result, 4);
end;

function TSuplaVal.getInt_2: integer;
begin
  move(dt[4], Result, 8);
end;

procedure TDS_SuplaDeviceChannel_B.SetValueAsDouble(d: double);
begin
  move(d, value, 8);
end;

procedure TDS_SuplaRegisterDevice_D.Init(_Email, _svrName, _DevName, _softVer: string);
begin
  fillchar(self, sizeof(TDS_SuplaRegisterDevice_D), 0);
  setAnsiChar(Email, sizeof(Email), _Email);
  setAnsiChar(ServerName, sizeof(ServerName), _svrName);
  setAnsiChar(SoftVer, sizeof(SoftVer), _softVer);
  setAnsiChar(Name, sizeof(Name), 'PC-' + _DevName);
end;

function TDS_SuplaRegisterDevice_D.AddChn(_TypeCh, _FuncList, _Default: _supla_int_t): integer;
var
  nr: integer;
begin
  nr := channel_count;
  channels[nr].Number := nr;
  channels[nr].TypeM := _TypeCh;
  channels[nr].FuncList := _FuncList;
  channels[nr].Default := _Default;
  inc(channel_count);
  Result := nr;
end;

procedure TSuplaProtoData.Init;
begin
  fillchar(self, sizeof(self), 0);
  version := SUPLA_PROTO_VERSION;
end;

procedure TSuplaProtoData.IncRRId;
begin
  inc(next_rr_id);
  if next_rr_id = 0 then
    next_rr_id := 1;

end;

procedure TElectricityMeter_Value.Zero;
begin
  flags := 0;
  total_forward_active_energy := 0;
end;

procedure TMyCurrency.LoadFromString(txt: string);
var
  n, i: integer;
begin
  fillchar(dt, sizeof(dt), 0);
  n := length(txt);
  if n > 3 then
    n := 3;
  for i := 0 to n - 1 do
  begin
    dt[i] := AnsiChar(txt[i + 1]);
  end;
end;

function TMyCurrency.getAsString: string;
var
  Cu: array of char;
  i: integer;
begin
  setlength(Cu, 3);
  for i := 0 to 2 do
    Cu[i] := char(dt[i]);
  Result := String.Create(Cu[0], 0, 3);
end;

procedure TMyCustomUnit.LoadFromString(txt: string);
var
  n, i: integer;
begin
  fillchar(dt, sizeof(dt), 0);
  n := length(txt);
  if n > 9 then
    n := 9;
  for i := 0 to n - 1 do
  begin
    dt[i] := AnsiChar(txt[i + 1]);
  end;
end;

function TMyCustomUnit.getAsString: string;
var
  Cu: array of char;
  i: integer;
begin
  setlength(Cu, 9);
  for i := 0 to 8 do
    Cu[i] := char(dt[i]);
  Result := String.Create(Cu[0], 0, 9);
end;

procedure TElectricityMeter_ExtendedValue.getAsShortValue(var val: TSuplaVal);
var
  elV: TElectricityMeter_Value;
  suma: Uint64;
begin
  if sizeof(TElectricityMeter_Value) > sizeof(TSuplaVal) then
    raise Exception.Create('TElectricityMeter_Value to big!');
  elV.Zero;

  suma := total_forward_active_energy[0] + total_forward_active_energy[1] + total_forward_active_energy[2];
  elV.total_forward_active_energy := suma div 1000;

  if (m_count <> 0) and ((measured_values and EM_VAR_VOLTAGE) <> 0) then
    if m[m_count - 1].voltage[0] > 0 then
      elV.flags := elV.flags or EM_VALUE_FLAG_PHASE1_ON;
  if m[m_count - 1].voltage[1] > 0 then
    elV.flags := elV.flags or EM_VALUE_FLAG_PHASE2_ON;
  if m[m_count - 1].voltage[2] > 0 then
    elV.flags := elV.flags or EM_VALUE_FLAG_PHASE3_ON;
  val.setFromElectricityMeter(elV);
end;

procedure TSC_ImpulseCounter_ExtendedValue.getAsShortValue(var val: TSuplaVal);
begin
  val.setAsUint64(counter);
end;

procedure TThermostat_ExtendedValue.Init;
var
  i, j: integer;
begin
  for i := 0 to 6 do
  begin
    for j := 0 to 23 do
    begin
      Schedule.HourValue[i][j] := THERMOSTATE_PROG_ECO;
    end;
  end;

end;

procedure TThermostat_ExtendedValue.getAsShortValue(IsOn: boolean; var val: TSuplaVal);
var
  thv: TThermostat_Value;
begin
  thv.IsOn := byte(IsOn);
  thv.flags := self.flags[0];
  thv.MeasuredTemperature := self.MeasuredTemperature[0];
  thv.PresetTemperature := self.PresetTemperature[0];
  val.setFromThermostat(thv);
end;

procedure TThermostat_Schedule.SetFromCmd(buf: bytes);
  procedure SetDays(const Cmd: TThermostat_Schedule_Cmd);
  var
    i: integer;
  begin
    for i := 0 to 6 do
    begin
      if (Cmd.Days and (1 shl i))<>0 then
      begin
        HourValue[i] := Cmd.Hours;
      end;
    end;
  end;

var
  n: integer;
  i: integer;
  Cmd: TThermostat_Schedule_Cmd;
begin
  n := length(buf) div sizeof(TThermostat_Schedule_Cmd);
  for i := 0 to n - 1 do
  begin
    move(buf[i * sizeof(TThermostat_Schedule_Cmd)], Cmd, sizeof(TThermostat_Schedule_Cmd));
    if Cmd.flag <> 0 then
    begin
      SetDays(Cmd);
    end;
  end;
end;

// -----
procedure TThermostat_ExtendedValue.setFlagBit(flagNr, bitNr: integer; q: boolean);
begin
  if q then
    flags[flagNr] := flags[flagNr] or (1 shl bitNr)
  else
    flags[flagNr] := flags[flagNr] and not(1 shl bitNr);
end;

function TThermostat_ExtendedValue.getFlagBit(flagNr, bitNr: integer): boolean;
begin
  Result := ((flags[flagNr] and (1 shl bitNr)) <> 0);
end;

procedure TThermostat_ExtendedValue.setThermostatOn(q: boolean);
begin
  setFlagBit(4, 0, q);
end;

function TThermostat_ExtendedValue.getThermostatOn: boolean;
begin
  Result := getFlagBit(4, 0);
end;

procedure TThermostat_ExtendedValue.setAutoMode(q: boolean);
begin
  setFlagBit(4, 2, q);
end;

function TThermostat_ExtendedValue.getAutoMode: boolean;
begin
  Result := getFlagBit(4, 2);
end;

procedure TThermostat_ExtendedValue.setEcoMode(q: boolean);
begin
  setFlagBit(7, 1, q);
end;

function TThermostat_ExtendedValue.getEcoMode: boolean;
begin
  Result := getFlagBit(7, 1);
end;

procedure TThermostat_ExtendedValue.setTurboMode(q: boolean);
begin
  setFlagBit(7, 0, q);
end;

function TThermostat_ExtendedValue.getTurboMode: boolean;
begin
  Result := getFlagBit(7, 0);
end;

/// ----

function TSuplaChannelExtendedValue.loadFromElectricityMeter(const em: TElectricityMeter_ExtendedValue): boolean;
begin
  Result := false;
  Evtype := EV_TYPE_ELECTRICITY_METER_MEASUREMENT_V1;
  size := sizeof(TElectricityMeter_ExtendedValue) - sizeof(TElectricityMeter_Measurement) * EM_MEASUREMENT_COUNT +
    sizeof(TElectricityMeter_Measurement) * em.m_count;

  if (size > 0) and (size <= SUPLA_CHANNELEXTENDEDVALUE_SIZE) then
  begin
    fillchar(value[0], sizeof(value), 0);
    move(em, value[0], size);
    Result := true;
  end;
end;

function TSuplaChannelExtendedValue.loadFromImpulseCounter(const imp: TSC_ImpulseCounter_ExtendedValue): boolean;
begin
  Result := false;
  Evtype := EV_TYPE_IMPULSE_COUNTER_DETAILS_V1;
  size := sizeof(TSC_ImpulseCounter_ExtendedValue);

  if (size > 0) and (size <= SUPLA_CHANNELEXTENDEDVALUE_SIZE) then
  begin
    fillchar(value[0], sizeof(value), 0);
    move(imp, value[0], size);
    Result := true;
  end;
end;

function TSuplaChannelExtendedValue.loadFromThermostat(const th: TThermostat_ExtendedValue): boolean;
begin
  Result := false;
  Evtype := EV_TYPE_THERMOSTAT_DETAILS_V1;
  size := sizeof(TThermostat_ExtendedValue);

  if (th.Fields and THERMOSTAT_FIELD_Schedule) = 0 then
  begin
    size := size - sizeof(th.Schedule);
    if (th.Fields and THERMOSTAT_FIELD_Time) = 0 then
    begin
      size := size - sizeof(th.Time);
      if (th.Fields and THERMOSTAT_FIELD_Values) = 0 then
      begin
        size := size - sizeof(th.Values);
        if (th.Fields and THERMOSTAT_FIELD_Flags) = 0 then
        begin
          size := size - sizeof(th.Fields);

          if (th.Fields and THERMOSTAT_FIELD_PresetTemperatures) = 0 then
          begin
            size := size - sizeof(th.PresetTemperature);

            if (th.Fields and THERMOSTAT_FIELD_MeasuredTemperatures) = 0 then
            begin
              size := size - sizeof(th.MeasuredTemperature);
            end;
          end;
        end;
      end;
    end;
  end;

  if (size > 0) and (size <= SUPLA_CHANNELEXTENDEDVALUE_SIZE) then
  begin
    fillchar(value[0], sizeof(value), 0);
    move(th, value[0], size);
    Result := true;
  end;
end;

// -----------------------------------------------------------------------------
function TChannelTypeList.FGetItem(Index: integer): TChannelTypeObj;
begin
  Result := inherited GetItem(Index) as TChannelTypeObj;
end;

procedure TChannelTypeList.Add(aType: integer; aName: string);
var
  TObj: TChannelTypeObj;
begin
  TObj := TChannelTypeObj.Create;
  TObj.TypeCh := aType;
  TObj.TypName := Format('%.4u - %s', [aType, aName]);
  inherited Add(TObj);
end;

function TChannelTypeList.getTypeIndex(chType: integer): integer;
var
  idx: integer;
begin
  Result := -1;
  for idx := 0 to Count - 1 do
  begin
    if Items[idx].TypeCh = chType then
    begin
      Result := idx;
      break;
    end;
  end;
end;

procedure TChannelTypeList.LoadNames(SL: TStrings);
var
  i: integer;
begin
  SL.Clear;
  for i := 0 to Count - 1 do
  begin
    SL.Add(Items[i].TypName);
  end;
end;

function TChannelTypeList.getTypeName(ChannelType: integer): string;
var
  idx: integer;
begin
  idx := getTypeIndex(ChannelType);
  if idx >= 0 then
    Result := Items[idx].TypName
  else
    Result := Format('Unknow type id=%u', [ChannelType]);
end;

function GetChannelTypeList: TChannelTypeList;
begin
  Result := TChannelTypeList.Create;
  { 1 } Result.Add(SUPLA_CHANNELTYPE_SENSORNO, 'SENSORNO');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_SENSORNC, 'SENSORNC');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_DISTANCESENSOR, 'DISTANCESENSOR');
  Result.Add(SUPLA_CHANNELTYPE_CALLBUTTON, 'CALLBUTTON');
  Result.Add(SUPLA_CHANNELTYPE_RELAYHFD4, 'RELAYHFD4');
  Result.Add(SUPLA_CHANNELTYPE_RELAYG5LA1A, 'RELAYG5LA1A');
  Result.Add(SUPLA_CHANNELTYPE_2XRELAYG5LA1A, '2XRELAYG5LA1A');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_RELAY, 'RELAY');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_THERMOMETERDS18B20, 'THERMOMETERDS18B20');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_DHT11, 'DHT11');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_DHT22, 'DHT22');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_DHT21, 'DHT21');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_AM2302, 'AM2302');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_AM2301, 'AM2301');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_THERMOMETER, 'THERMOMETER');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_HUMIDITYSENSOR, 'HUMIDITYSENSOR');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_HUMIDITYANDTEMPSENSOR, 'HUMIDITYANDTEMPSENSOR');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_WINDSENSOR, 'WINDSENSOR');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_PRESSURESENSOR, 'PRESSURESENSOR');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_RAINSENSOR, 'RAINSENSOR');
  { 1 } Result.Add(SUPLA_CHANNELTYPE_WEIGHTSENSOR, 'WEIGHTSENSOR');
  Result.Add(SUPLA_CHANNELTYPE_WEATHER_STATION, 'WEATHER_STATION');
  Result.Add(SUPLA_CHANNELTYPE_DIMMER, 'DIMMER');
  Result.Add(SUPLA_CHANNELTYPE_RGBLEDCONTROLLER, 'RGBLEDCONTROLLER');
  Result.Add(SUPLA_CHANNELTYPE_DIMMERANDRGBLED, 'DIMMERANDRGBLED');
  Result.Add(SUPLA_CHANNELTYPE_ELECTRICITY_METER, 'ELECTRICITY_METER');
  Result.Add(SUPLA_CHANNELTYPE_IMPULSE_COUNTER, 'IMPULSE_COUNTER');
  Result.Add(SUPLA_CHANNELTYPE_THERMOSTAT, 'THERMOSTAT');
  Result.Add(SUPLA_CHANNELTYPE_THERMOSTAT_HEATPOL_HOMEPLUS, 'THERMOSTAT_HEATPOL_HOMEPLUS');
end;

function getChanelTypeName(chType: integer): string;
var
  idx: integer;
begin
  Result := 'Unknow channel type';
  idx := ChannelTypeList.getTypeIndex(chType);
  if idx >= 0 then
    Result := ChannelTypeList.Items[idx].TypName;
end;

initialization

ChannelTypeList := GetChannelTypeList;

finalization

ChannelTypeList.Free;

end.
