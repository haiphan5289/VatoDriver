//
//  Product.swift
//  Vato
//
//  Created by khoi tran on 11/21/19.
//  Copyright © 2019 Vato. All rights reserved.
//

import Foundation


enum ProductType: String {
    case SIMPLE = "SIMPLE"
}

struct DisplayProductCategory: Codable {
    var name: String?
    var id: Int?
    var products: [DisplayProduct]?
}

struct DisplayProduct : Codable, Equatable, StoreProductDisplayProtocol, Hashable {
    let productId : Int?
    let productName : String?
    var productPrice : Double?
    let images : [String]?
    let productDescription : String?
    let productIsOpen : Bool?
    let category : Int?
    let sku : String?
    let specialPrice : Double?
    let finalPrice : Double?
    let isPromo : Bool?
    let specialFromDate : String?
    let specialToDate : String?
    let qty : Int?
    let status : Int?
    
    var name: String? {
        return productName
    }
    var price: Double? {
        return self.isAppliedSpecialPrice ? self.finalPrice : self.productPrice
    }
    var description: String? {
        return productDescription
    }
    var imageURL: String? {
        return images?.first
    }
    
    func hash(into hasher: inout Hasher) {
        hasher = Hasher()
        let id = productId ?? 0
        hasher.combine(id)
    }
    
    
    enum CodingKeys: String, CodingKey {
        
        case productId = "productId"
        case productName = "productName"
        case productPrice = "productPrice"
        case images = "images"
        case productDescription = "productDescription"
        case productIsOpen = "productIsOpen"
        case category = "category"
        case sku = "sku"
        case specialPrice = "specialPrice"
        case finalPrice = "finalPrice"
        case isPromo = "isPromo"
        case specialFromDate = "specialFromDate"
        case specialToDate = "specialToDate"
        case qty = "qty"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decodeIfPresent(Int.self, forKey: .productId)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        productPrice = try values.decodeIfPresent(Double.self, forKey: .productPrice)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        productDescription = try values.decodeIfPresent(String.self, forKey: .productDescription)
        productIsOpen = try values.decodeIfPresent(Bool.self, forKey: .productIsOpen)
        category = try values.decodeIfPresent(Int.self, forKey: .category)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        specialPrice = try values.decodeIfPresent(Double.self, forKey: .specialPrice)
        finalPrice = try values.decodeIfPresent(Double.self, forKey: .finalPrice)
        isPromo = try values.decodeIfPresent(Bool.self, forKey: .isPromo)
        specialFromDate = try values.decodeIfPresent(String.self, forKey: .specialFromDate)
        specialToDate = try values.decodeIfPresent(String.self, forKey: .specialToDate)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
    static func == (lhs: DisplayProduct, rhs: DisplayProduct) -> Bool {
        return lhs.productId == rhs.productId
    }
    
    
    var isAppliedSpecialPrice: Bool {
        guard let specialFromDate = Date.date(from: self.specialFromDate, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") else { return false }
        
        if let specialToDate = Date.date(from: self.specialToDate, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {

            let date = Date().toGMT()
            let result = specialFromDate > specialToDate ? false : specialFromDate...specialToDate ~= date
            let different = productPrice != finalPrice
            return result && different
            
        } else {
            return true
        }
    }
}

