from google.protobuf import wrappers_pb2 as _wrappers_pb2
from mathworks.roadrunner import core_pb2 as _core_pb2
from mathworks.scenario.common import geometry_pb2 as _geometry_pb2
from google.protobuf.internal import enum_type_wrapper as _enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from collections.abc import Mapping as _Mapping
from typing import ClassVar as _ClassVar, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class CrgRoadDataFormat(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    CRG_ROAD_DATA_FORMAT_UNSPECIFIED: _ClassVar[CrgRoadDataFormat]
    CRG_ROAD_DATA_FORMAT_LRFI: _ClassVar[CrgRoadDataFormat]
    CRG_ROAD_DATA_FORMAT_LDFI: _ClassVar[CrgRoadDataFormat]

class NoOpsActionType(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    NO_OPS_ACTION_TYPE_UNSPECIFIED: _ClassVar[NoOpsActionType]
    NO_OPS_ACTION_TYPE_USER_DEFINED: _ClassVar[NoOpsActionType]
    NO_OPS_ACTION_TYPE_EMPTY: _ClassVar[NoOpsActionType]
    NO_OPS_ACTION_TYPE_EMPTY_PRIVATE: _ClassVar[NoOpsActionType]

class CatalogExportType(int, metaclass=_enum_type_wrapper.EnumTypeWrapper):
    __slots__ = ()
    CATALOG_EXPORT_TYPE_UNSPECIFIED: _ClassVar[CatalogExportType]
    CATALOG_EXPORT_TYPE_NONE: _ClassVar[CatalogExportType]
    CATALOG_EXPORT_TYPE_REFERENCE: _ClassVar[CatalogExportType]
CRG_ROAD_DATA_FORMAT_UNSPECIFIED: CrgRoadDataFormat
CRG_ROAD_DATA_FORMAT_LRFI: CrgRoadDataFormat
CRG_ROAD_DATA_FORMAT_LDFI: CrgRoadDataFormat
NO_OPS_ACTION_TYPE_UNSPECIFIED: NoOpsActionType
NO_OPS_ACTION_TYPE_USER_DEFINED: NoOpsActionType
NO_OPS_ACTION_TYPE_EMPTY: NoOpsActionType
NO_OPS_ACTION_TYPE_EMPTY_PRIVATE: NoOpsActionType
CATALOG_EXPORT_TYPE_UNSPECIFIED: CatalogExportType
CATALOG_EXPORT_TYPE_NONE: CatalogExportType
CATALOG_EXPORT_TYPE_REFERENCE: CatalogExportType

class AutoCadExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "export_only_highest_lods", "target_projection", "export_to_tiles")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    target_projection: _geometry_pb2.Projection
    export_to_tiles: ExportToTiles
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ...) -> None: ...

class FilmboxExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "embed_textures", "apply_material_color_to_textures", "export_only_highest_lods", "target_projection", "export_to_tiles")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EMBED_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    APPLY_MATERIAL_COLOR_TO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    embed_textures: _wrappers_pb2.BoolValue
    apply_material_color_to_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    target_projection: _geometry_pb2.Projection
    export_to_tiles: ExportToTiles
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., embed_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., apply_material_color_to_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ...) -> None: ...

class WavefrontExportSettings(_message.Message):
    __slots__ = ("target_projection",)
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    target_projection: _geometry_pb2.Projection
    def __init__(self, target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ...) -> None: ...

class StlExportSettings(_message.Message):
    __slots__ = ("target_projection",)
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    target_projection: _geometry_pb2.Projection
    def __init__(self, target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ...) -> None: ...

class GltfExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "export_only_highest_lods", "embed_textures", "target_projection", "export_to_tiles")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    EMBED_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    embed_textures: _wrappers_pb2.BoolValue
    target_projection: _geometry_pb2.Projection
    export_to_tiles: ExportToTiles
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., embed_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ...) -> None: ...

class OpenFlightExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "export_only_highest_lods", "target_projection", "export_to_tiles")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    target_projection: _geometry_pb2.Projection
    export_to_tiles: ExportToTiles
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ...) -> None: ...

class OpenSceneGraphExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "embed_textures", "export_only_highest_lods", "target_projection", "export_to_tiles")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EMBED_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    embed_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    target_projection: _geometry_pb2.Projection
    export_to_tiles: ExportToTiles
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., embed_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ...) -> None: ...

class UnrealDatasmithExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "export_only_highest_lods", "target_projection", "export_to_tiles")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    target_projection: _geometry_pb2.Projection
    export_to_tiles: ExportToTiles
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ...) -> None: ...

class UsdExportSettings(_message.Message):
    __slots__ = ("split_by_segmentation", "power_of_two_textures", "apply_material_color_to_textures", "export_only_highest_lods", "export_to_tiles", "target_projection", "export_individual_assets")
    SPLIT_BY_SEGMENTATION_FIELD_NUMBER: _ClassVar[int]
    POWER_OF_TWO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    APPLY_MATERIAL_COLOR_TO_TEXTURES_FIELD_NUMBER: _ClassVar[int]
    EXPORT_ONLY_HIGHEST_LODS_FIELD_NUMBER: _ClassVar[int]
    EXPORT_TO_TILES_FIELD_NUMBER: _ClassVar[int]
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_INDIVIDUAL_ASSETS_FIELD_NUMBER: _ClassVar[int]
    split_by_segmentation: _wrappers_pb2.BoolValue
    power_of_two_textures: _wrappers_pb2.BoolValue
    apply_material_color_to_textures: _wrappers_pb2.BoolValue
    export_only_highest_lods: _wrappers_pb2.BoolValue
    export_to_tiles: ExportToTiles
    target_projection: _geometry_pb2.Projection
    export_individual_assets: _wrappers_pb2.BoolValue
    def __init__(self, split_by_segmentation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., power_of_two_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., apply_material_color_to_textures: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_only_highest_lods: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_to_tiles: _Optional[_Union[ExportToTiles, _Mapping]] = ..., target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., export_individual_assets: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class ApolloExportSettings(_message.Message):
    __slots__ = ("apollo_version", "database_version", "database_name", "driving_side", "export_signals", "export_objects", "clamp_distances")
    APOLLO_VERSION_FIELD_NUMBER: _ClassVar[int]
    DATABASE_VERSION_FIELD_NUMBER: _ClassVar[int]
    DATABASE_NAME_FIELD_NUMBER: _ClassVar[int]
    DRIVING_SIDE_FIELD_NUMBER: _ClassVar[int]
    EXPORT_SIGNALS_FIELD_NUMBER: _ClassVar[int]
    EXPORT_OBJECTS_FIELD_NUMBER: _ClassVar[int]
    CLAMP_DISTANCES_FIELD_NUMBER: _ClassVar[int]
    apollo_version: float
    database_version: float
    database_name: str
    driving_side: _core_pb2.DrivingSide
    export_signals: _wrappers_pb2.BoolValue
    export_objects: _wrappers_pb2.BoolValue
    clamp_distances: _wrappers_pb2.BoolValue
    def __init__(self, apollo_version: _Optional[float] = ..., database_version: _Optional[float] = ..., database_name: _Optional[str] = ..., driving_side: _Optional[_Union[_core_pb2.DrivingSide, str]] = ..., export_signals: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_objects: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., clamp_distances: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class GeoJsonExportSettings(_message.Message):
    __slots__ = ("reduce_file_size",)
    REDUCE_FILE_SIZE_FIELD_NUMBER: _ClassVar[int]
    reduce_file_size: _wrappers_pb2.BoolValue
    def __init__(self, reduce_file_size: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class OpenDriveExportSettings(_message.Message):
    __slots__ = ("target_projection", "open_drive_version", "database_version", "database_name", "driving_side", "enforce_connected_road_continuity", "export_markings_as_line", "export_signals", "export_objects", "apply_parking_slope", "export_hoffset_relative_to_orientation", "export_conflict_points", "export_scene_origin_reference", "clamp_distances", "synthetic_open_crg", "export_open_crg")
    TARGET_PROJECTION_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_VERSION_FIELD_NUMBER: _ClassVar[int]
    DATABASE_VERSION_FIELD_NUMBER: _ClassVar[int]
    DATABASE_NAME_FIELD_NUMBER: _ClassVar[int]
    DRIVING_SIDE_FIELD_NUMBER: _ClassVar[int]
    ENFORCE_CONNECTED_ROAD_CONTINUITY_FIELD_NUMBER: _ClassVar[int]
    EXPORT_MARKINGS_AS_LINE_FIELD_NUMBER: _ClassVar[int]
    EXPORT_SIGNALS_FIELD_NUMBER: _ClassVar[int]
    EXPORT_OBJECTS_FIELD_NUMBER: _ClassVar[int]
    APPLY_PARKING_SLOPE_FIELD_NUMBER: _ClassVar[int]
    EXPORT_HOFFSET_RELATIVE_TO_ORIENTATION_FIELD_NUMBER: _ClassVar[int]
    EXPORT_CONFLICT_POINTS_FIELD_NUMBER: _ClassVar[int]
    EXPORT_SCENE_ORIGIN_REFERENCE_FIELD_NUMBER: _ClassVar[int]
    CLAMP_DISTANCES_FIELD_NUMBER: _ClassVar[int]
    SYNTHETIC_OPEN_CRG_FIELD_NUMBER: _ClassVar[int]
    EXPORT_OPEN_CRG_FIELD_NUMBER: _ClassVar[int]
    target_projection: _geometry_pb2.Projection
    open_drive_version: float
    database_version: float
    database_name: str
    driving_side: _core_pb2.DrivingSide
    enforce_connected_road_continuity: _wrappers_pb2.BoolValue
    export_markings_as_line: _wrappers_pb2.BoolValue
    export_signals: _wrappers_pb2.BoolValue
    export_objects: _wrappers_pb2.BoolValue
    apply_parking_slope: _wrappers_pb2.BoolValue
    export_hoffset_relative_to_orientation: _wrappers_pb2.BoolValue
    export_conflict_points: _wrappers_pb2.BoolValue
    export_scene_origin_reference: _wrappers_pb2.BoolValue
    clamp_distances: _wrappers_pb2.BoolValue
    synthetic_open_crg: SyntheticOpenCrg
    export_open_crg: _wrappers_pb2.BoolValue
    def __init__(self, target_projection: _Optional[_Union[_geometry_pb2.Projection, _Mapping]] = ..., open_drive_version: _Optional[float] = ..., database_version: _Optional[float] = ..., database_name: _Optional[str] = ..., driving_side: _Optional[_Union[_core_pb2.DrivingSide, str]] = ..., enforce_connected_road_continuity: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_markings_as_line: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_signals: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_objects: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., apply_parking_slope: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_hoffset_relative_to_orientation: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_conflict_points: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., export_scene_origin_reference: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., clamp_distances: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., synthetic_open_crg: _Optional[_Union[SyntheticOpenCrg, _Mapping]] = ..., export_open_crg: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class RoadRunnerHdMapExportSettings(_message.Message):
    __slots__ = ("author_name", "remove_short_lane_groups", "merge_junction_maneuver_lanes")
    AUTHOR_NAME_FIELD_NUMBER: _ClassVar[int]
    REMOVE_SHORT_LANE_GROUPS_FIELD_NUMBER: _ClassVar[int]
    MERGE_JUNCTION_MANEUVER_LANES_FIELD_NUMBER: _ClassVar[int]
    author_name: str
    remove_short_lane_groups: _wrappers_pb2.BoolValue
    merge_junction_maneuver_lanes: _wrappers_pb2.BoolValue
    def __init__(self, author_name: _Optional[str] = ..., remove_short_lane_groups: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., merge_junction_maneuver_lanes: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class OpenScenarioExportSettings(_message.Message):
    __slots__ = ("open_scenario_version", "path_to_open_drive", "scene_graph_format_name", "path_to_existing_scene_graph", "export_scene_graph", "open_scene_graph_settings", "scene_graph_settings", "open_drive_settings", "catalog_settings", "move_noninstantaneous_init_actions", "no_ops_action", "relocate_vehicle_origin")
    OPEN_SCENARIO_VERSION_FIELD_NUMBER: _ClassVar[int]
    PATH_TO_OPEN_DRIVE_FIELD_NUMBER: _ClassVar[int]
    SCENE_GRAPH_FORMAT_NAME_FIELD_NUMBER: _ClassVar[int]
    PATH_TO_EXISTING_SCENE_GRAPH_FIELD_NUMBER: _ClassVar[int]
    EXPORT_SCENE_GRAPH_FIELD_NUMBER: _ClassVar[int]
    OPEN_SCENE_GRAPH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    SCENE_GRAPH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    CATALOG_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    MOVE_NONINSTANTANEOUS_INIT_ACTIONS_FIELD_NUMBER: _ClassVar[int]
    NO_OPS_ACTION_FIELD_NUMBER: _ClassVar[int]
    RELOCATE_VEHICLE_ORIGIN_FIELD_NUMBER: _ClassVar[int]
    open_scenario_version: float
    path_to_open_drive: str
    scene_graph_format_name: str
    path_to_existing_scene_graph: str
    export_scene_graph: _wrappers_pb2.BoolValue
    open_scene_graph_settings: OpenSceneGraphExportSettings
    scene_graph_settings: SceneGraphSettings
    open_drive_settings: OpenDriveExportSettings
    catalog_settings: CatalogSettings
    move_noninstantaneous_init_actions: _wrappers_pb2.BoolValue
    no_ops_action: NoOpsActionType
    relocate_vehicle_origin: _wrappers_pb2.BoolValue
    def __init__(self, open_scenario_version: _Optional[float] = ..., path_to_open_drive: _Optional[str] = ..., scene_graph_format_name: _Optional[str] = ..., path_to_existing_scene_graph: _Optional[str] = ..., export_scene_graph: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., open_scene_graph_settings: _Optional[_Union[OpenSceneGraphExportSettings, _Mapping]] = ..., scene_graph_settings: _Optional[_Union[SceneGraphSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ..., catalog_settings: _Optional[_Union[CatalogSettings, _Mapping]] = ..., move_noninstantaneous_init_actions: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., no_ops_action: _Optional[_Union[NoOpsActionType, str]] = ..., relocate_vehicle_origin: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class OpenScenarioXmlExportSettings(_message.Message):
    __slots__ = ("open_scenario_version", "path_to_open_drive", "scene_graph_settings", "open_drive_settings", "catalog_settings", "move_noninstantaneous_init_actions", "no_ops_action", "relocate_vehicle_origin")
    OPEN_SCENARIO_VERSION_FIELD_NUMBER: _ClassVar[int]
    PATH_TO_OPEN_DRIVE_FIELD_NUMBER: _ClassVar[int]
    SCENE_GRAPH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    CATALOG_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    MOVE_NONINSTANTANEOUS_INIT_ACTIONS_FIELD_NUMBER: _ClassVar[int]
    NO_OPS_ACTION_FIELD_NUMBER: _ClassVar[int]
    RELOCATE_VEHICLE_ORIGIN_FIELD_NUMBER: _ClassVar[int]
    open_scenario_version: float
    path_to_open_drive: str
    scene_graph_settings: SceneGraphSettings
    open_drive_settings: OpenDriveExportSettings
    catalog_settings: CatalogSettings
    move_noninstantaneous_init_actions: _wrappers_pb2.BoolValue
    no_ops_action: NoOpsActionType
    relocate_vehicle_origin: _wrappers_pb2.BoolValue
    def __init__(self, open_scenario_version: _Optional[float] = ..., path_to_open_drive: _Optional[str] = ..., scene_graph_settings: _Optional[_Union[SceneGraphSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ..., catalog_settings: _Optional[_Union[CatalogSettings, _Mapping]] = ..., move_noninstantaneous_init_actions: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., no_ops_action: _Optional[_Union[NoOpsActionType, str]] = ..., relocate_vehicle_origin: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class SceneGraphSettings(_message.Message):
    __slots__ = ("format_name", "path_to_new_file", "path_to_existing_file", "export_scene_graph", "open_scene_graph_settings")
    FORMAT_NAME_FIELD_NUMBER: _ClassVar[int]
    PATH_TO_NEW_FILE_FIELD_NUMBER: _ClassVar[int]
    PATH_TO_EXISTING_FILE_FIELD_NUMBER: _ClassVar[int]
    EXPORT_SCENE_GRAPH_FIELD_NUMBER: _ClassVar[int]
    OPEN_SCENE_GRAPH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    format_name: str
    path_to_new_file: str
    path_to_existing_file: str
    export_scene_graph: _wrappers_pb2.BoolValue
    open_scene_graph_settings: OpenSceneGraphExportSettings
    def __init__(self, format_name: _Optional[str] = ..., path_to_new_file: _Optional[str] = ..., path_to_existing_file: _Optional[str] = ..., export_scene_graph: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ..., open_scene_graph_settings: _Optional[_Union[OpenSceneGraphExportSettings, _Mapping]] = ...) -> None: ...

class CatalogSettings(_message.Message):
    __slots__ = ("export_type", "catalog_root_directory")
    EXPORT_TYPE_FIELD_NUMBER: _ClassVar[int]
    CATALOG_ROOT_DIRECTORY_FIELD_NUMBER: _ClassVar[int]
    export_type: CatalogExportType
    catalog_root_directory: str
    def __init__(self, export_type: _Optional[_Union[CatalogExportType, str]] = ..., catalog_root_directory: _Optional[str] = ...) -> None: ...

class OpenScenario2ExportSettings(_message.Message):
    __slots__ = ("open_drive_settings",)
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class OpenScenarioDslExportSettings(_message.Message):
    __slots__ = ("open_drive_settings",)
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class CarlaExportSettings(_message.Message):
    __slots__ = ("open_drive_settings", "unreal_datasmith_settings", "filmbox_settings")
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    UNREAL_DATASMITH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    FILMBOX_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    open_drive_settings: OpenDriveExportSettings
    unreal_datasmith_settings: UnrealDatasmithExportSettings
    filmbox_settings: FilmboxExportSettings
    def __init__(self, open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ..., unreal_datasmith_settings: _Optional[_Union[UnrealDatasmithExportSettings, _Mapping]] = ..., filmbox_settings: _Optional[_Union[FilmboxExportSettings, _Mapping]] = ...) -> None: ...

class CarlaFilmboxExportSettings(_message.Message):
    __slots__ = ("open_drive_settings", "filmbox_settings")
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    FILMBOX_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    open_drive_settings: OpenDriveExportSettings
    filmbox_settings: FilmboxExportSettings
    def __init__(self, open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ..., filmbox_settings: _Optional[_Union[FilmboxExportSettings, _Mapping]] = ...) -> None: ...

class MetamotoExportSettings(_message.Message):
    __slots__ = ("filmbox_settings", "open_drive_settings", "geo_json_settings")
    FILMBOX_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    GEO_JSON_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    filmbox_settings: FilmboxExportSettings
    open_drive_settings: OpenDriveExportSettings
    geo_json_settings: GeoJsonExportSettings
    def __init__(self, filmbox_settings: _Optional[_Union[FilmboxExportSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ..., geo_json_settings: _Optional[_Union[GeoJsonExportSettings, _Mapping]] = ...) -> None: ...

class RFProExportSettings(_message.Message):
    __slots__ = ("filmbox_settings", "open_drive_settings")
    FILMBOX_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    filmbox_settings: FilmboxExportSettings
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, filmbox_settings: _Optional[_Union[FilmboxExportSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class UnityExportSettings(_message.Message):
    __slots__ = ("filmbox_settings", "open_drive_settings")
    FILMBOX_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    filmbox_settings: FilmboxExportSettings
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, filmbox_settings: _Optional[_Union[FilmboxExportSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class UnrealExportSettings(_message.Message):
    __slots__ = ("filmbox_settings", "open_drive_settings")
    FILMBOX_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    filmbox_settings: FilmboxExportSettings
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, filmbox_settings: _Optional[_Union[FilmboxExportSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class DatasmithRoadExportSettings(_message.Message):
    __slots__ = ("unreal_datasmith_settings", "open_drive_settings")
    UNREAL_DATASMITH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    unreal_datasmith_settings: UnrealDatasmithExportSettings
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, unreal_datasmith_settings: _Optional[_Union[UnrealDatasmithExportSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class VtdExportSettings(_message.Message):
    __slots__ = ("open_scene_graph_settings", "open_drive_settings")
    OPEN_SCENE_GRAPH_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    OPEN_DRIVE_SETTINGS_FIELD_NUMBER: _ClassVar[int]
    open_scene_graph_settings: OpenSceneGraphExportSettings
    open_drive_settings: OpenDriveExportSettings
    def __init__(self, open_scene_graph_settings: _Optional[_Union[OpenSceneGraphExportSettings, _Mapping]] = ..., open_drive_settings: _Optional[_Union[OpenDriveExportSettings, _Mapping]] = ...) -> None: ...

class ExportToTiles(_message.Message):
    __slots__ = ("tile_size", "tile_center", "export_individual_tiles")
    TILE_SIZE_FIELD_NUMBER: _ClassVar[int]
    TILE_CENTER_FIELD_NUMBER: _ClassVar[int]
    EXPORT_INDIVIDUAL_TILES_FIELD_NUMBER: _ClassVar[int]
    tile_size: _geometry_pb2.Vector2
    tile_center: _geometry_pb2.Vector2
    export_individual_tiles: _wrappers_pb2.BoolValue
    def __init__(self, tile_size: _Optional[_Union[_geometry_pb2.Vector2, _Mapping]] = ..., tile_center: _Optional[_Union[_geometry_pb2.Vector2, _Mapping]] = ..., export_individual_tiles: _Optional[_Union[_wrappers_pb2.BoolValue, _Mapping]] = ...) -> None: ...

class SyntheticOpenCrg(_message.Message):
    __slots__ = ("road_data_format",)
    ROAD_DATA_FORMAT_FIELD_NUMBER: _ClassVar[int]
    road_data_format: CrgRoadDataFormat
    def __init__(self, road_data_format: _Optional[_Union[CrgRoadDataFormat, str]] = ...) -> None: ...

class Surface2DExportSettings(_message.Message):
    __slots__ = ("type", "cell_size")
    TYPE_FIELD_NUMBER: _ClassVar[int]
    CELL_SIZE_FIELD_NUMBER: _ClassVar[int]
    type: str
    cell_size: _wrappers_pb2.FloatValue
    def __init__(self, type: _Optional[str] = ..., cell_size: _Optional[_Union[_wrappers_pb2.FloatValue, _Mapping]] = ...) -> None: ...
