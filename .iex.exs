#  Using MAVProxy as a reference, provide helper functions for working with
#  vehicles running APM. Importing the API into an iex session should give
#  an interactive CLI very similar to MAVProxy, using info/warn level log
#  messages for extra feedback. The same API can be called directly from code.

import MAVLink.Router, only: [subscribe: 0, subscribe: 1, unsubscribe: 0, pack_and_send: 1, pack_and_send: 2]
import MAVLink.Util.Arm, only: [arm: 0, arm: 3, disarm: 0, disarm: 3]
import MAVLink.Util.CacheManager, only: [mavs: 0, msg: 0, msg: 1, msg: 2, params: 0, params: 1, params: 2]
import MAVLink.Util.FocusManager, only: [focus: 0, focus: 1, focus: 2]
import MAVLink.Util.ParamRequest, only: [param_request_list: 0, param_request_list: 3]
import MAVLink.Util.ParamSet, only: [param_set: 2, param_set: 5]
import MAVLink.Util.SITL, only: [forward_rc: 0, forward_rc: 4]

alias APM.Message.{  # TODO can MAVLink generate a macro for this?
  Heartbeat, SysStatus, SystemTime, Ping, ChangeOperatorControl, ChangeOperatorControlAck, AuthKey, SetMode,
  ParamRequestRead, ParamRequestList, ParamValue, ParamSet, GpsRawInt, GpsStatus, ScaledImu, RawImu,
  RawPressure, ScaledPressure, Attitude, AttitudeQuaternion, LocalPositionNed, GlobalPositionInt,
  RcChannelsScaled, RcChannelsRaw, ServoOutputRaw, MissionRequestPartialList, MissionWritePartialList,
  MissionItem, MissionRequest, MissionSetCurrent, MissionCurrent, MissionRequestList, MissionCount, MissionClearAll,
  MissionItemReached, MissionAck, SetGpsGlobalOrigin, GpsGlobalOrigin, ParamMapRc, MissionRequestInt,
  SafetySetAllowedArea, SafetyAllowedArea, AttitudeQuaternionCov, NavControllerOutput, GlobalPositionIntCov,
  LocalPositionNedCov, RcChannels, RequestDataStream, DataStream, ManualControl, RcChannelsOverride,
  MissionItemInt, VfrHud, CommandInt, CommandLong, CommandAck, ManualSetpoint, SetAttitudeTarget,
  AttitudeTarget, SetPositionTargetLocalNed, PositionTargetLocalNed, SetPositionTargetGlobalInt,
  PositionTargetGlobalInt, LocalPositionNedSystemGlobalOffset, HilState, HilControls, HilRcInputsRaw,
  HilActuatorControls, OpticalFlow, GlobalVisionPositionEstimate, VisionPositionEstimate, VisionSpeedEstimate,
  ViconPositionEstimate, HighresImu, OpticalFlowRad, HilSensor, SimState, RadioStatus, FileTransferProtocol,
  Timesync, CameraTrigger, HilGps, HilOpticalFlow, HilStateQuaternion, ScaledImu2, LogRequestList, LogEntry,
  LogRequestData, LogData, LogErase, LogRequestEnd, GpsInjectData, Gps2Raw, PowerStatus, SerialControl,
  GpsRtk, Gps2Rtk, ScaledImu3, DataTransmissionHandshake, EncapsulatedData, DistanceSensor, TerrainRequest,
  TerrainData, TerrainCheck, TerrainReport, ScaledPressure2, AttPosMocap, SetActuatorControlTarget,
  ActuatorControlTarget, Altitude, ResourceRequest, ScaledPressure3, FollowTarget, ControlSystemState,
  BatteryStatus, AutopilotVersion, LandingTarget, SensorOffsets, SetMagOffsets, Meminfo, ApAdc,
  DigicamConfigure, DigicamControl, MountConfigure, MountControl, MountStatus, FencePoint, FenceFetchPoint,
  FenceStatus, Ahrs, Simstate, Hwstatus, Radio, LimitsStatus, Wind, Data16, Data32, Data64, Data96, Rangefinder,
  AirspeedAutocal, RallyPoint, RallyFetchPoint, CompassmotStatus, Ahrs2, CameraStatus, CameraFeedback, Battery2,
  Ahrs3, AutopilotVersionRequest, RemoteLogDataBlock, RemoteLogBlockStatus, LedControl, MagCalProgress,
  MagCalReport, EkfStatusReport, PidTuning, Deepstall, GimbalReport, GimbalControl, GimbalTorqueCmdReport,
  GoproHeartbeat, GoproGetRequest, GoproGetResponse, GoproSetRequest, GoproSetResponse, EfiStatus, Rpm,
  EstimatorStatus, WindCov, GpsInput, GpsRtcmData, HighLatency, HighLatency2, Vibration, HomePosition,
  SetHomePosition, MessageInterval, ExtendedSysState, AdsbVehicle, Collision, V2Extension, MemoryVect,
  DebugVect, NamedValueFloat, NamedValueInt, Statustext, Debug, SetupSigning, ButtonChange, PlayTune,
  CameraInformation, CameraSettings, StorageInformation, CameraCaptureStatus, CameraImageCaptured,
  FlightInformation, MountOrientation, LoggingData, LoggingDataAcked, LoggingAck, VideoStreamInformation,
  VideoStreamStatus, WifiConfigAp, AisVessel, UavcanNodeStatus, UavcanNodeInfo, ObstacleDistance, Odometry,
  IsbdLinkStatus, RawRpm, UtmGlobalPosition, DebugFloatArray, GeneratorStatus, ActuatorOutputStatus, WheelDistance,
  WinchStatus, UavionixAdsbOutCfg, UavionixAdsbOutDynamic, UavionixAdsbTransceiverHealthReport, DeviceOpRead,
  DeviceOpReadReply, DeviceOpWrite, DeviceOpWriteReply, AdapTuning, VisionPositionDelta, AoaSsa,
  EscTelemetry1To4, EscTelemetry5To8, EscTelemetry9To12, OsdParamConfig, OsdParamConfigReply,
  OsdParamShowConfig, OsdParamShowConfigReply, ObstacleDistance3d, IcarousHeartbeat, IcarousKinematicBands}

IEx.configure(default_prompt: "iex(%counter) vehicle ...>")
