from google.protobuf import wrappers_pb2 as _wrappers_pb2
from mathworks.roadrunner import core_pb2 as _core_pb2
from mathworks.scenario.common import geometry_pb2 as _geometry_pb2
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from collections.abc import Mapping as _Mapping
from typing import ClassVar as _ClassVar, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class ProjectionMode(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    PROJECTION_MODE_UNSPECIFIED: _ClassVar[ProjectionMode]
    PROJECTION_MODE_FULL_PROJECTION: _ClassVar[ProjectionMode]
    PROJECTION_MODE_TRANSLATE_ONLY: _ClassVar[ProjectionMode]
    PROJECTION_MODE_NO_PROJECTION: _ClassVar[ProjectionMode]

class MedianLaneType(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    MEDIAN_LANE_TYPE_UNSPECIFIED: _ClassVar[MedianLaneType]
    MEDIAN_LANE_TYPE_MEDIAN: _ClassVar[MedianLaneType]
    MEDIAN_LANE_TYPE_RAISED_MEDIAN: _ClassVar[MedianLaneType]

class ImportStep(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    IMPORT_STEP_UNSPECIFIED: _ClassVar[ImportStep]
    IMPORT_STEP_LOAD: _ClassVar[ImportStep]
    IMPORT_STEP_BUILD: _ClassVar[ImportStep]

class TomTomHdMapDataFormat(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    TOM_TOM_HD_MAP_DATA_FORMAT_UNSPECIFIED: _ClassVar[TomTomHdMapDataFormat]
    TOM_TOM_HD_MAP_DATA_FORMAT_AVRO: _ClassVar[TomTomHdMapDataFormat]
    TOM_TOM_HD_MAP_DATA_FORMAT_GEOPACKAGE: _ClassVar[TomTomHdMapDataFormat]
PROJECTION_MODE_UNSPECIFIED: ProjectionMode
PROJECTION_MODE_FULL_PROJECTION: ProjectionMode
PROJECTION_MODE_TRANSLATE_ONLY: ProjectionMode
PROJECTION_MODE_NO_PROJECTION: ProjectionMode
MEDIAN_LANE_TYPE_UNSPECIFIED: MedianLaneType
MEDIAN_LANE_TYPE_MEDIAN: MedianLaneType
MEDIAN_LANE_TYPE_RAISED_MEDIAN: MedianLaneType
IMPORT_STEP_UNSPECIFIED: ImportStep
IMPORT_STEP_LOAD: ImportStep
IMPORT_STEP_BUILD: ImportStep
TOM_TOM_HD_MAP_DATA_FORMAT_UNSPECIFIED: TomTomHdMapDataFormat
TOM_TOM_HD_MAP_DATA_FORMAT_AVRO: TomTomHdMapDataFormat
TOM_TOM_HD_MAP_DATA_FORMAT_GEOPACKAGE: TomTomHdMapDataFormat

class OpenDriveImportSettings(_message.Message):
    __slots__ = ("import_signals", "import_props", "import_hoffset_relative_to_orientation", "smooth_fit_road_geometry", "lane_options", "offset", "projection", "projection_mode", "import_region")
    IMPORT_SIGNALS_FIELD_NUMBER: _ClassVar[int]
    IMPORT_PROPS_FIELD_NUMBER: _ClassVar[int]
    IMPORT_HOFFSET_RELATIVE_TO_ORIENTATION_FIELD_NUMBER: _ClassVar[int]
    SMOOTH_FIT_ROAD_GEOMETRY_FIELD_NUMBER: _ClassVar[int]
    LANE_OPTIONS_FIELD_NUMBER: _ClassVar[int]
    OFFSET_FIELD_NUMBER: _ClassVar[int]
    PROJECTION_FIELD_NUMBER: _ClassVar[int]
    PROJECTION_MODE_FIELD_NUMBER: _ClassVar[int]
    IMPORT_REGION_FIELD_NUMBER: _ClassVar[int]
    import_signals: _wrappers_pb2.BoolValue
    import_props: _wrappers_pb2.BoolValue
    import_hoffset_relative_to_orientation: _wrappers_pb2.BoolValue
    smooth_fit_road_geometry: SmoothFitRoadGeometry
    lane_options: LaneOptions
    offset: _geometry_pb2.Vector3
    projection: _geometry_pb2.Projection
    projection_mode: ProjectionMode
    import_region: ImportRegion
    def __init__(self, import_signals: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., import_props: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., import_hoffset_relative_to_orientation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., smooth_fit_road_geometry: _Optional[_Union[SmoothFitRoadGeometry, _Mapping]] = ..., lane_options: _Optional[_Union[LaneOptions, _Mapping]] = ..., offset: _Optional[_Union[_geometry_pb2.Vector3, _Mapping]] = ..., projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., projection_mode: _Optional[_Union[ProjectionMode, str]] = ..., import_region: _Optional[_Union[ImportRegion, _Mapping]] = ...) -> None: ...

class RoadRunnerHdMapImportSettings(_message.Message):
    __slots__ = ("import_step", "load_settings", "build_settings")
    IMPORT_STEP_FIELD_NUMBER: _ClassVar[int]
    LOAD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    BUILD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    import_step: ImportStep
    load_settings: RoadRunnerHdMapLoadSettings
    build_settings: RoadRunnerHdMapBuildSettings
    def __init__(self, import_step: _Optional[_Union[ImportStep, str]] = ..., load_settings: _Optional[_Union[RoadRunnerHdMapLoadSettings, _Mapping]] = ..., build_settings: _Optional[_Union[RoadRunnerHdMapBuildSettings, _Mapping]] = ...) -> None: ...

class RoadRunnerHdMapLoadSettings(_message.Message):
    __slots__ = ("offset", "projection")
    OFFSET_FIELD_NUMBER: _ClassVar[int]
    PROJECTION_FIELD_NUMBER: _ClassVar[int]
    offset: _geometry_pb2.Vector3
    projection: _geometry_pb2.Projection
    def __init__(self, offset: _Optional[_Union[_geometry_pb2.Vector3, _Mapping]] = ..., projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ...) -> None: ...

class RoadRunnerHdMapBuildSettings(_message.Message):
    __slots__ = ("fit_cross_sections", "detect_asphalt_surfaces", "clear_scene_of_existing_data", "curvature_blend", "auto_detect_bridges", "enable_overlap_groups", "use_lane_groups", "combine_transition_lanes")
    FIT_CROSS_SECTIONS_FIELD_NUMBER: _ClassVar[int]
    DETECT_ASPHALT_SURFACES_FIELD_NUMBER: _ClassVar[int]
    CLEAR_SCENE_OF_EXISTING_DATA_FIELD_NUMBER: _ClassVar[int]
    CURVATURE_BLEND_FIELD_NUMBER: _ClassVar[int]
    AUTO_DETECT_BRIDGES_FIELD_NUMBER: _ClassVar[int]
    ENABLE_OVERLAP_GROUPS_FIELD_NUMBER: _ClassVar[int]
    USE_LANE_GROUPS_FIELD_NUMBER: _ClassVar[int]
    COMBINE_TRANSITION_LANES_FIELD_NUMBER: _ClassVar[int]
    fit_cross_sections: _wrappers_pb2.BoolValue
    detect_asphalt_surfaces: _wrappers_pb2.BoolValue
    clear_scene_of_existing_data: _wrappers_pb2.BoolValue
    curvature_blend: _wrappers_pb2.DoubleValue
    auto_detect_bridges: AutoDetectBridges
    enable_overlap_groups: EnableOverlapGroups
    use_lane_groups: _wrappers_pb2.BoolValue
    combine_transition_lanes: _wrappers_pb2.BoolValue
    def __init__(self, fit_cross_sections: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., detect_asphalt_surfaces: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., clear_scene_of_existing_data: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., curvature_blend: _Optional[_Union[_wrappers_pb2.DoubleValue, _Mapping]] = ..., auto_detect_bridges: _Optional[_Union[AutoDetectBridges, _Mapping]] = ..., enable_overlap_groups: _Optional[_Union[EnableOverlapGroups, _Mapping]] = ..., use_lane_groups: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., combine_transition_lanes: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class AutoDetectBridges(_message.Message):
    __slots__ = ("bridge_span_inflation", "enable")
    BRIDGE_SPAN_INFLATION_FIELD_NUMBER: _ClassVar[int]
    ENABLE_FIELD_NUMBER: _ClassVar[int]
    bridge_span_inflation: _wrappers_pb2.DoubleValue
    enable: _wrappers_pb2.BoolValue
    def __init__(self, bridge_span_inflation: _Optional[_Union[_wrappers_pb2.DoubleValue, _Mapping]] = ..., enable: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class EnableOverlapGroups(_message.Message):
    __slots__ = ("enable", "group_name", "preserve_junction_lanes", "preserve_junction_shape")
    ENABLE_FIELD_NUMBER: _ClassVar[int]
    GROUP_NAME_FIELD_NUMBER: _ClassVar[int]
    PRESERVE_JUNCTION_LANES_FIELD_NUMBER: _ClassVar[int]
    PRESERVE_JUNCTION_SHAPE_FIELD_NUMBER: _ClassVar[int]
    enable: _wrappers_pb2.BoolValue
    group_name: _wrappers_pb2.StringValue
    preserve_junction_lanes: _wrappers_pb2.BoolValue
    preserve_junction_shape: _wrappers_pb2.BoolValue
    def __init__(self, enable: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., group_name: _Optional[_Union[_wrappers_pb2.StringValue, _Mapping]] = ..., preserve_junction_lanes: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., preserve_junction_shape: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class ImportRegion(_message.Message):
    __slots__ = ("box",)
    BOX_FIELD_NUMBER: _ClassVar[int]
    box: _geometry_pb2.Box2
    def __init__(self, box: _Optional[_Union[_geometry_pb2.Box2, _Mapping]] = ...) -> None: ...

class LaneOptions(_message.Message):
    __slots__ = ("curb_lane_markings_to_curb_lanes", "convert_lane_heights", "median_lane_type")
    CURB_LANE_MARKINGS_TO_CURB_LANES_FIELD_NUMBER: _ClassVar[int]
    CONVERT_LANE_HEIGHTS_FIELD_NUMBER: _ClassVar[int]
    MEDIAN_LANE_TYPE_FIELD_NUMBER: _ClassVar[int]
    curb_lane_markings_to_curb_lanes: _wrappers_pb2.BoolValue
    convert_lane_heights: _wrappers_pb2.BoolValue
    median_lane_type: MedianLaneType
    def __init__(self, curb_lane_markings_to_curb_lanes: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., convert_lane_heights: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., median_lane_type: _Optional[_Union[MedianLaneType, str]] = ...) -> None: ...

class HereHdLiveMapSettings(_message.Message):
    __slots__ = ()
    def __init__(self) -> None: ...

class HereProtobufFilesSettings(_message.Message):
    __slots__ = ("root_folder", "uncompress_using_gzip")
    ROOT_FOLDER_FIELD_NUMBER: _ClassVar[int]
    UNCOMPRESS_USING_GZIP_FIELD_NUMBER: _ClassVar[int]
    root_folder: str
    uncompress_using_gzip: _wrappers_pb2.BoolValue
    def __init__(self, root_folder: _Optional[str] = ..., uncompress_using_gzip: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class HereHdMapLoadSettings(_message.Message):
    __slots__ = ("here_hd_live_map_settings", "here_protobuf_files_settings")
    HERE_HD_LIVE_MAP_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    HERE_PROTOBUF_FILES_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    here_hd_live_map_settings: HereHdLiveMapSettings
    here_protobuf_files_settings: HereProtobufFilesSettings
    def __init__(self, here_hd_live_map_settings: _Optional[_Union[HereHdLiveMapSettings, _Mapping]] = ..., here_protobuf_files_settings: _Optional[_Union[HereProtobufFilesSettings, _Mapping]] = ...) -> None: ...

class HereHdMapImportSettings(_message.Message):
    __slots__ = ("load_settings", "build_settings")
    LOAD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    BUILD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    load_settings: HereHdMapLoadSettings
    build_settings: RoadRunnerHdMapBuildSettings
    def __init__(self, load_settings: _Optional[_Union[HereHdMapLoadSettings, _Mapping]] = ..., build_settings: _Optional[_Union[RoadRunnerHdMapBuildSettings, _Mapping]] = ...) -> None: ...

class TomTomHdMapFilesSettings(_message.Message):
    __slots__ = ("data_format", "root_folder")
    DATA_FORMAT_FIELD_NUMBER: _ClassVar[int]
    ROOT_FOLDER_FIELD_NUMBER: _ClassVar[int]
    data_format: TomTomHdMapDataFormat
    root_folder: str
    def __init__(self, data_format: _Optional[_Union[TomTomHdMapDataFormat, str]] = ..., root_folder: _Optional[str] = ...) -> None: ...

class TomTomHdMapLoadSettings(_message.Message):
    __slots__ = ("files_settings",)
    FILES_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    files_settings: TomTomHdMapFilesSettings
    def __init__(self, files_settings: _Optional[_Union[TomTomHdMapFilesSettings, _Mapping]] = ...) -> None: ...

class TomTomHdMapImportSettings(_message.Message):
    __slots__ = ("load_settings", "build_settings")
    LOAD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    BUILD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    load_settings: TomTomHdMapLoadSettings
    build_settings: RoadRunnerHdMapBuildSettings
    def __init__(self, load_settings: _Optional[_Union[TomTomHdMapLoadSettings, _Mapping]] = ..., build_settings: _Optional[_Union[RoadRunnerHdMapBuildSettings, _Mapping]] = ...) -> None: ...

class ActorAttributes(_message.Message):
    __slots__ = ("name", "id", "color", "asset_path", "behavior_asset_path")
    NAME_FIELD_NUMBER: _ClassVar[int]
    ID_FIELD_NUMBER: _ClassVar[int]
    COLOR_FIELD_NUMBER: _ClassVar[int]
    ASSET_PATH_FIELD_NUMBER: _ClassVar[int]
    BEHAVIOR_ASSET_PATH_FIELD_NUMBER: _ClassVar[int]
    name: str
    id: str
    color: str
    asset_path: str
    behavior_asset_path: str
    def __init__(self, name: _Optional[str] = ..., id: _Optional[str] = ..., color: _Optional[str] = ..., asset_path: _Optional[str] = ..., behavior_asset_path: _Optional[str] = ...) -> None: ...

class CsvTrajectoryImportSettings(_message.Message):
    __slots__ = ("actor_attributes", "spawn_time", "remove_time")
    ACTOR_ATTRIBUTES_FIELD_NUMBER: _ClassVar[int]
    SPAWN_TIME_FIELD_NUMBER: _ClassVar[int]
    REMOVE_TIME_FIELD_NUMBER: _ClassVar[int]
    actor_attributes: ActorAttributes
    spawn_time: _wrappers_pb2.DoubleValue
    remove_time: _wrappers_pb2.DoubleValue
    def __init__(self, actor_attributes: _Optional[_Union[ActorAttributes, _Mapping]] = ..., spawn_time: _Optional[_Union[_wrappers_pb2.DoubleValue, _Mapping]] = ..., remove_time: _Optional[_Union[_wrappers_pb2.DoubleValue, _Mapping]] = ...) -> None: ...

class SdMapImportSettings(_message.Message):
    __slots__ = ("build_settings",)
    BUILD_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    build_settings: SdMapBuildSettings
    def __init__(self, build_settings: _Optional[_Union[SdMapBuildSettings, _Mapping]] = ...) -> None: ...

class SdMapBuildSettings(_message.Message):
    __slots__ = ("destructive_options", "non_destructive_options", "scene_builder_options", "auto_detect_bridges", "enable_overlap_groups")
    DESTRUCTIVE_OPTIONS_FIELD_NUMBER: _ClassVar[int]
    NON_DESTRUCTIVE_OPTIONS_FIELD_NUMBER: _ClassVar[int]
    SCENE_BUILDER_OPTIONS_FIELD_NUMBER: _ClassVar[int]
    AUTO_DETECT_BRIDGES_FIELD_NUMBER: _ClassVar[int]
    ENABLE_OVERLAP_GROUPS_FIELD_NUMBER: _ClassVar[int]
    destructive_options: SdMapDestructiveBuildOptions
    non_destructive_options: SdMapNonDestructiveBuildOptions
    scene_builder_options: SdMapSceneBuilderOptions
    auto_detect_bridges: AutoDetectBridges
    enable_overlap_groups: EnableOverlapGroups
    def __init__(self, destructive_options: _Optional[_Union[SdMapDestructiveBuildOptions, _Mapping]] = ..., non_destructive_options: _Optional[_Union[SdMapNonDestructiveBuildOptions, _Mapping]] = ..., scene_builder_options: _Optional[_Union[SdMapSceneBuilderOptions, _Mapping]] = ..., auto_detect_bridges: _Optional[_Union[AutoDetectBridges, _Mapping]] = ..., enable_overlap_groups: _Optional[_Union[EnableOverlapGroups, _Mapping]] = ...) -> None: ...

class SdMapDestructiveBuildOptions(_message.Message):
    __slots__ = ("preserve_heights", "clear_scene_of_existing_data")
    PRESERVE_HEIGHTS_FIELD_NUMBER: _ClassVar[int]
    CLEAR_SCENE_OF_EXISTING_DATA_FIELD_NUMBER: _ClassVar[int]
    preserve_heights: _wrappers_pb2.BoolValue
    clear_scene_of_existing_data: _wrappers_pb2.BoolValue
    def __init__(self, preserve_heights: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., clear_scene_of_existing_data: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class SdMapNonDestructiveBuildOptions(_message.Message):
    __slots__ = ("driving_side", "enable_overlap_groups")
    DRIVING_SIDE_FIELD_NUMBER: _ClassVar[int]
    ENABLE_OVERLAP_GROUPS_FIELD_NUMBER: _ClassVar[int]
    driving_side: _core_pb2.DrivingSide
    enable_overlap_groups: _wrappers_pb2.BoolValue
    def __init__(self, driving_side: _Optional[_Union[_core_pb2.DrivingSide, str]] = ..., enable_overlap_groups: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class SdMapSceneBuilderOptions(_message.Message):
    __slots__ = ("elevate_roads_by_layer", "create_turn_lanes")
    ELEVATE_ROADS_BY_LAYER_FIELD_NUMBER: _ClassVar[int]
    CREATE_TURN_LANES_FIELD_NUMBER: _ClassVar[int]
    elevate_roads_by_layer: _wrappers_pb2.BoolValue
    create_turn_lanes: _wrappers_pb2.BoolValue
    def __init__(self, elevate_roads_by_layer: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., create_turn_lanes: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class SmoothFitRoadGeometry(_message.Message):
    __slots__ = ("tolerance", "max_depth")
    TOLERANCE_FIELD_NUMBER: _ClassVar[int]
    MAX_DEPTH_FIELD_NUMBER: _ClassVar[int]
    tolerance: _wrappers_pb2.DoubleValue
    max_depth: _wrappers_pb2.Int32Value
    def __init__(self, tolerance: _Optional[_Union[_wrappers_pb2.DoubleValue, _Mapping]] = ..., max_depth: _Optional[_Union[_wrappers_pb2.Int32Value, _Mapping]] = ...) -> None: ...
