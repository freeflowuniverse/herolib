module qdrant

// import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
// import json
// import os

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct QDrantClient {
pub mut:
	name   string = 'default'
	secret string
	url    string = 'http://localhost:6333/'
}

// your checking & initialization code if needed
fn obj_init(mycfg_ QDrantClient) !QDrantClient {
	mut mycfg := mycfg_
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj QDrantClient) !string {
	return encoderhero.encode[QDrantClient](obj)!
}

pub fn heroscript_loads(heroscript string) !QDrantClient {
	mut obj := encoderhero.decode[QDrantClient](heroscript)!
	return obj
}

// // Base response structure
// pub struct BaseResponse {
// pub mut:
// 	time   f32
// 	status string
// }

// // Operation response
// pub struct OperationResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result bool
// }

// // Collections response
// pub struct CollectionsResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result []string
// }

// // Collection info response
// pub struct CollectionInfoResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result CollectionInfo
// }

// // Collection info
// pub struct CollectionInfo {
// pub mut:
// 	status        string
// 	optimizer_status OptimizersStatus
// 	vectors_count u64
// 	indexed_vectors_count ?u64
// 	points_count u64
// 	segments_count u64
// 	config        CollectionConfig
// 	payload_schema map[string]PayloadIndexInfo
// }

// // Optimizers status
// pub struct OptimizersStatus {
// pub mut:
// 	status string
// }

// // Collection config
// pub struct CollectionConfig {
// pub mut:
// 	params CollectionParams
// 	hnsw_config ?HnswConfig
// 	optimizer_config ?OptimizersConfig
// 	wal_config ?WalConfig
// 	quantization_config ?QuantizationConfig
// }

// // Collection params
// pub struct CollectionParams {
// pub mut:
// 	vectors VectorsConfig
// 	shard_number ?int
// 	replication_factor ?int
// 	write_consistency_factor ?int
// 	on_disk_payload ?bool
// 	hnsw_config ?HnswConfig
// 	optimizers_config ?OptimizersConfig
// 	wal_config ?WalConfig
// 	quantization_config ?QuantizationConfig
// 	init_from ?InitFrom
// }

// // Vectors config
// pub struct VectorsConfig {
// pub mut:
// 	size int
// 	distance Distance
// 	hnsw_config ?HnswConfig
// 	quantization_config ?QuantizationConfig
// 	on_disk ?bool
// }

// // Distance type
// pub enum Distance {
// 	cosine
// 	euclid
// 	dot
// }

// // Convert Distance enum to string
// pub fn (d Distance) str() string {
// 	return match d {
// 		.cosine { 'cosine' }
// 		.euclid { 'euclid' }
// 		.dot { 'dot' }
// 	}
// }

// // HNSW config
// pub struct HnswConfig {
// pub mut:
// 	m int
// 	ef_construct int
// 	full_scan_threshold ?int
// 	max_indexing_threads ?int
// 	on_disk ?bool
// 	payload_m ?int
// }

// // Optimizers config
// pub struct OptimizersConfig {
// pub mut:
// 	deleted_threshold f32
// 	vacuum_min_vector_number int
// 	default_segment_number int
// 	max_segment_size ?int
// 	memmap_threshold ?int
// 	indexing_threshold ?int
// 	flush_interval_sec ?int
// 	max_optimization_threads ?int
// }

// // WAL config
// pub struct WalConfig {
// pub mut:
// 	wal_capacity_mb ?int
// 	wal_segments_ahead ?int
// }

// // Quantization config
// pub struct QuantizationConfig {
// pub mut:
// 	scalar ?ScalarQuantization
// 	product ?ProductQuantization
// 	binary ?BinaryQuantization
// }

// // Scalar quantization
// pub struct ScalarQuantization {
// pub mut:
// 	type_ string
// 	quantile ?f32
// 	always_ram ?bool
// }

// // Product quantization
// pub struct ProductQuantization {
// pub mut:
// 	compression string
// 	always_ram ?bool
// }

// // Binary quantization
// pub struct BinaryQuantization {
// pub mut:
// 	binary bool
// 	always_ram ?bool
// }

// // Init from
// pub struct InitFrom {
// pub mut:
// 	collection string
// 	shard ?int
// }

// // Payload index info
// pub struct PayloadIndexInfo {
// pub mut:
// 	data_type string
// 	params ?map[string]string
// 	points int
// }

// // Points operation response
// pub struct PointsOperationResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result OperationInfo
// }

// // Operation info
// pub struct OperationInfo {
// pub mut:
// 	operation_id int
// 	status string
// }

// // Point struct
// pub struct PointStruct {
// pub mut:
// 	id string
// 	vector []f32
// 	payload ?map[string]string
// }

// // Points selector
// pub struct PointsSelector {
// pub mut:
// 	points ?[]string
// 	filter ?Filter
// }

// // Filter
// pub struct Filter {
// pub mut:
// 	must ?[]Condition
// 	must_not ?[]Condition
// 	should ?[]Condition
// }

// // Filter is serialized directly to JSON

// // Condition interface
// pub interface Condition {}

// // Field condition
// pub struct FieldCondition {
// pub mut:
// 	key string
// 	match ?string @[json: match]
// 	match_integer ?int @[json: match]
// 	match_float ?f32 @[json: match]
// 	match_bool ?bool @[json: match]
// 	range ?Range
// 	geo_bounding_box ?GeoBoundingBox
// 	geo_radius ?GeoRadius
// 	values_count ?ValuesCount
// }

// // FieldCondition is serialized directly to JSON

// // Range
// pub struct Range {
// pub mut:
// 	lt ?f32
// 	gt ?f32
// 	gte ?f32
// 	lte ?f32
// }

// // Range is serialized directly to JSON

// // GeoBoundingBox
// pub struct GeoBoundingBox {
// pub mut:
// 	top_left GeoPoint
// 	bottom_right GeoPoint
// }

// // GeoBoundingBox is serialized directly to JSON

// // GeoPoint
// pub struct GeoPoint {
// pub mut:
// 	lon f32
// 	lat f32
// }

// // GeoPoint is serialized directly to JSON

// // GeoRadius
// pub struct GeoRadius {
// pub mut:
// 	center GeoPoint
// 	radius f32
// }

// // GeoRadius is serialized directly to JSON

// // ValuesCount
// pub struct ValuesCount {
// pub mut:
// 	lt ?int
// 	gt ?int
// 	gte ?int
// 	lte ?int
// }

// // ValuesCount is serialized directly to JSON

// // WithPayloadSelector
// pub struct WithPayloadSelector {
// pub mut:
// 	include ?[]string
// 	exclude ?[]string
// }

// // WithPayloadSelector is serialized directly to JSON

// // WithVector
// pub struct WithVector {
// pub mut:
// 	include ?[]string
// }

// // WithVector is serialized directly to JSON

// // Get point response
// pub struct GetPointResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result ?PointStruct
// }

// // Search params configuration
// pub struct SearchParamsConfig {
// pub mut:
// 	hnsw_ef ?int
// 	exact ?bool
// }

// // SearchParamsConfig is serialized directly to JSON

// // Search response
// pub struct SearchResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result []ScoredPoint
// }

// // Scored point
// pub struct ScoredPoint {
// pub mut:
// 	id string
// 	version int
// 	score f32
// 	payload ?map[string]string
// 	vector ?[]f32
// }

// // Write ordering
// pub struct WriteOrdering {
// pub mut:
// 	type_ string
// }

// // WriteOrdering is serialized directly to JSON

// // Service info response
// pub struct ServiceInfoResponse {
// pub mut:
// 	time   f32
// 	status string
// 	result ServiceInfo
// }

// // Service info
// pub struct ServiceInfo {
// pub mut:
// 	version string
// 	commit ?string
// }
