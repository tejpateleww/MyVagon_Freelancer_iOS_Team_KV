//
//  NewLoginResModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on March 08, 2022
//
import Foundation

struct NewLoginResModel: Codable {

	var status: Bool?
	var message: String?
	var data: LoginData?

	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case message = "message"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(LoginData.self, forKey: .data)
	}

}

struct LoginData: Codable {

    var id: Int?
    var name: String?
    var email: String?
    var profile: String?
    var type: String?
    var countryCode: String?
    var mobileNumber: String?
    var licenceNumber: String?
    var licenceExpiryDate: String?
    var vehicle: LoginVehicle?
    var permissions: Permissions?
    var token: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case profile = "profile"
        case type = "type"
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case licenceNumber = "licence_number"
        case licenceExpiryDate = "licence_expiry_date"
        case vehicle = "vehicle"
        case permissions = "permissions"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber)
        licenceNumber = try values.decodeIfPresent(String.self, forKey: .licenceNumber)
        licenceExpiryDate = try values.decodeIfPresent(String.self, forKey: .licenceExpiryDate)
        vehicle = try values.decodeIfPresent(LoginVehicle.self, forKey: .vehicle)
        permissions = try values.decodeIfPresent(Permissions.self, forKey: .permissions)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}

struct LoginVehicle: Codable {

    var id: Int?
    var userId: Int?
    var dispatcherVehicleId: Int?
    var truckType: TruckType?
    var truckSubCategory: TruckSubCategory?
    var weight: String?
    var weightUnit: WeightUnit?
    var loadCapacity: String?
    var loadCapacityUnit: LoadCapacityUnit?
    var brand: String?
    var capacityPallets: String?
    var pallets: Int?
    var fuelType: String?
    var truckFeatures: [TruckFeatures]?
    var registrationNo: String?
    var trailerRegistrationNo: String?
    var images: [String]?
    var idProof: String?
    var license: String?
    var isAssing: Int?
    var createdAt: String?
    var truckDetails: [TruckDetails]?
    var brands: Brands?
    

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case dispatcherVehicleId = "dispatcher_vehicle_id"
        case truckType = "truck_type"
        case truckSubCategory = "truck_sub_category"
        case weight = "weight"
        case weightUnit = "weight_unit"
        case loadCapacity = "load_capacity"
        case loadCapacityUnit = "load_capacity_unit"
        case brand = "brand"
        case capacityPallets = "capacity_pallets"
        case pallets = "pallets"
        case fuelType = "fuel_type"
        case truckFeatures = "truck_features"
        case registrationNo = "registration_no"
        case trailerRegistrationNo = "trailer_registration_no"
        case images = "images"
        case idProof = "id_proof"
        case license = "license"
        case isAssing = "is_assing"
        case createdAt = "created_at"
        case truckDetails = "truck_details"
        case brands = "brands"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        dispatcherVehicleId = try values.decodeIfPresent(Int.self, forKey: .dispatcherVehicleId)
        truckType = try values.decodeIfPresent(TruckType.self, forKey: .truckType)
        truckSubCategory = try values.decodeIfPresent(TruckSubCategory.self, forKey: .truckSubCategory)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        weightUnit = try values.decodeIfPresent(WeightUnit.self, forKey: .weightUnit)
        loadCapacity = try values.decodeIfPresent(String.self, forKey: .loadCapacity)
        loadCapacityUnit = try values.decodeIfPresent(LoadCapacityUnit.self, forKey: .loadCapacityUnit)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        capacityPallets = try values.decodeIfPresent(String.self, forKey: .capacityPallets)
        pallets = try values.decodeIfPresent(Int.self, forKey: .pallets)
        fuelType = try values.decodeIfPresent(String.self, forKey: .fuelType)
        truckFeatures = try values.decodeIfPresent([TruckFeatures].self, forKey: .truckFeatures)
        registrationNo = try values.decodeIfPresent(String.self, forKey: .registrationNo)
        trailerRegistrationNo = try values.decodeIfPresent(String.self, forKey: .trailerRegistrationNo)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        idProof = try values.decodeIfPresent(String.self, forKey: .idProof)
        license = try values.decodeIfPresent(String.self, forKey: .license)
        isAssing = try values.decodeIfPresent(Int.self, forKey: .isAssing)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        truckDetails = try values.decodeIfPresent([TruckDetails].self, forKey: .truckDetails)
        brands = try values.decodeIfPresent(Brands.self, forKey: .brands)
        
    }

}

struct TruckType: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct TruckSubCategory: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct WeightUnit: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct LoadCapacityUnit: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct TruckFeatures: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct TruckDetails: Codable {

    var id: Int?
    var userId: Int?
    var truckType: TruckType?
    var truckSubCategory: TruckSubCategory?
    var truckFeatures: String?
    var weight: String?
    var weightUnit: WeightUnit?
    var loadCapacity: String?
    var loadCapacityUnit: LoadCapacityUnit?
    var plateNumber: String?
    var images: [String]?
    var defaultTruck: Int?
    var createdAt: String?
    var updatedAt: String?
    var vehicleCapacity: [VehicleCapacity]?
    var trash: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case truckType = "truck_type"
        case truckSubCategory = "truck_sub_category"
        case truckFeatures = "truck_features"
        case weight = "weight"
        case weightUnit = "weight_unit"
        case loadCapacity = "load_capacity"
        case loadCapacityUnit = "load_capacity_unit"
        case plateNumber = "plate_number"
        case images = "images"
        case defaultTruck = "default_truck"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case trash = "trash"
        case vehicleCapacity = "vehicle_capacity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        truckType = try values.decodeIfPresent(TruckType.self, forKey: .truckType)
        truckSubCategory = try values.decodeIfPresent(TruckSubCategory.self, forKey: .truckSubCategory)
        truckFeatures = try values.decodeIfPresent(String.self, forKey: .truckFeatures)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        weightUnit = try values.decodeIfPresent(WeightUnit.self, forKey: .weightUnit)
        loadCapacity = try values.decodeIfPresent(String.self, forKey: .loadCapacity)
        loadCapacityUnit = try values.decodeIfPresent(LoadCapacityUnit.self, forKey: .loadCapacityUnit)
        plateNumber = try values.decodeIfPresent(String.self, forKey: .plateNumber)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        defaultTruck = try values.decodeIfPresent(Int.self, forKey: .defaultTruck)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        trash = try values.decodeIfPresent(Int.self, forKey: .trash)
        vehicleCapacity = try values.decodeIfPresent([VehicleCapacity].self, forKey: .vehicleCapacity)
    }

}

struct Brands: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct VehicleCapacity: Codable {

    var id: Int?
    var driverVehicleId: Int?
    var driverTruckDetailsId: Int?
    var packageTypeId: PackageTypeId?
    var value: String?
    var createdAt: String?
    var updatedAt: String?
    
    init(id: Int, value: String){
        self.packageTypeId = PackageTypeId()
        self.value = value
    }
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case driverVehicleId = "driver_vehicle_id"
        case driverTruckDetailsId = "driver_truck_details_id"
        case packageTypeId = "package_type_id"
        case value = "value"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        driverVehicleId = try values.decodeIfPresent(Int.self, forKey: .driverVehicleId)
        driverTruckDetailsId = try values.decodeIfPresent(Int.self, forKey: .driverTruckDetailsId)
        packageTypeId = try values.decodeIfPresent(PackageTypeId.self, forKey: .packageTypeId)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}

struct PackageTypeId: Codable {

    var id: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    init(){
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}

struct Permissions: Codable {

    var id: Int?
    var userId: Int?
    var searchLoads: Int?
    var myLoads: Int?
    var myProfile: Int?
    var setting: Int?
    var statistics: Int?
    var changePassword: Int?
    var allowBid: Int?
    var viewPrice: Int?
    var postAvailibility: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case searchLoads = "search_loads"
        case myLoads = "my_loads"
        case myProfile = "my_profile"
        case setting = "setting"
        case statistics = "statistics"
        case changePassword = "change_password"
        case allowBid = "allow_bid"
        case viewPrice = "view_price"
        case postAvailibility = "post_availibility"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        searchLoads = try values.decodeIfPresent(Int.self, forKey: .searchLoads)
        myLoads = try values.decodeIfPresent(Int.self, forKey: .myLoads)
        myProfile = try values.decodeIfPresent(Int.self, forKey: .myProfile)
        setting = try values.decodeIfPresent(Int.self, forKey: .setting)
        statistics = try values.decodeIfPresent(Int.self, forKey: .statistics)
        changePassword = try values.decodeIfPresent(Int.self, forKey: .changePassword)
        allowBid = try values.decodeIfPresent(Int.self, forKey: .allowBid)
        viewPrice = try values.decodeIfPresent(Int.self, forKey: .viewPrice)
        postAvailibility = try values.decodeIfPresent(Int.self, forKey: .postAvailibility)
    }

}
