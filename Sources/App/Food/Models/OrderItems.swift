

import Foundation

struct OrderItem: Codable {
    let id: String?
    let amountRefunded: Int?
    let baseAmountRefunded: Int?
    let baseCost: Int?
    let baseDiscountAmount: Int?
    let baseDiscountInvoice: Int?
    let baseDiscountRefunded: Int?
    let baseOriginalPrice: Int?
    let basePrice: Int?
    let basePriceInclTax: Int?
    let baseRowInvoiced: Int?
    let baseRowTotal: Int?
    let baseRowTotalInclTax: Int?
    let baseTaxAmount: Int?
    let baseTaxBeforeDiscount: Int?
    let baseTaxInvoiced: Int?
    let baseTaxRefunded: Int?
    let description: String?
    let finalPrice: Int?
    let discountAmount: Int?
    let discountInvoiced: Int?
    let discountPercent: Int?
    let discountRefunded: Int?
    let storeId: Int?
    let qty: Int?
    let productId: Int?
    let name: String?
    let images: String?
    let nameStore: String?
    let addressStore: String?
    let phoneStore: String?
    let available: Bool?
//    let createdBy: Double?
//    let updatedBy: Double?
//    let createdAt: String?
//    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case amountRefunded = "amountRefunded"
        case baseAmountRefunded = "baseAmountRefunded"
        case baseCost = "baseCost"
        case baseDiscountAmount = "baseDiscountAmount"
        case baseDiscountInvoice = "baseDiscountInvoice"
        case baseDiscountRefunded = "baseDiscountRefunded"
        case baseOriginalPrice = "baseOriginalPrice"
        case basePrice = "basePrice"
        case basePriceInclTax = "basePriceInclTax"
        case baseRowInvoiced = "baseRowInvoiced"
        case baseRowTotal = "baseRowTotal"
        case baseRowTotalInclTax = "baseRowTotalInclTax"
        case baseTaxAmount = "baseTaxAmount"
        case baseTaxBeforeDiscount = "baseTaxBeforeDiscount"
        case baseTaxInvoiced = "baseTaxInvoiced"
        case baseTaxRefunded = "baseTaxRefunded"
        case description = "description"
        case finalPrice = "finalPrice"
        case discountAmount = "discountAmount"
        case discountInvoiced = "discountInvoiced"
        case discountPercent = "discountPercent"
        case discountRefunded = "discountRefunded"
        case storeId = "storeId"
        case qty = "qty"
        case productId = "productId"
        case name = "name"
        case images = "images"
        case nameStore = "nameStore"
        case addressStore = "addressStore"
        case phoneStore = "phoneStore"
        case available = "available"
//        case createdBy = "createdBy"
//        case updatedBy = "updatedBy"
//        case createdAt = "createdAt"
//        case updatedAt = "updatedAt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        amountRefunded = try values.decodeIfPresent(Int.self, forKey: .amountRefunded)
        baseAmountRefunded = try values.decodeIfPresent(Int.self, forKey: .baseAmountRefunded)
        baseCost = try values.decodeIfPresent(Int.self, forKey: .baseCost)
        baseDiscountAmount = try values.decodeIfPresent(Int.self, forKey: .baseDiscountAmount)
        baseDiscountInvoice = try values.decodeIfPresent(Int.self, forKey: .baseDiscountInvoice)
        baseDiscountRefunded = try values.decodeIfPresent(Int.self, forKey: .baseDiscountRefunded)
        baseOriginalPrice = try values.decodeIfPresent(Int.self, forKey: .baseOriginalPrice)
        basePrice = try values.decodeIfPresent(Int.self, forKey: .basePrice)
        basePriceInclTax = try values.decodeIfPresent(Int.self, forKey: .basePriceInclTax)
        baseRowInvoiced = try values.decodeIfPresent(Int.self, forKey: .baseRowInvoiced)
        baseRowTotal = try values.decodeIfPresent(Int.self, forKey: .baseRowTotal)
        baseRowTotalInclTax = try values.decodeIfPresent(Int.self, forKey: .baseRowTotalInclTax)
        baseTaxAmount = try values.decodeIfPresent(Int.self, forKey: .baseTaxAmount)
        baseTaxBeforeDiscount = try values.decodeIfPresent(Int.self, forKey: .baseTaxBeforeDiscount)
        baseTaxInvoiced = try values.decodeIfPresent(Int.self, forKey: .baseTaxInvoiced)
        baseTaxRefunded = try values.decodeIfPresent(Int.self, forKey: .baseTaxRefunded)
        finalPrice = try values.decodeIfPresent(Int.self, forKey: .finalPrice)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        discountAmount = try values.decodeIfPresent(Int.self, forKey: .discountAmount)
        discountInvoiced = try values.decodeIfPresent(Int.self, forKey: .discountInvoiced)
        discountPercent = try values.decodeIfPresent(Int.self, forKey: .discountPercent)
        discountRefunded = try values.decodeIfPresent(Int.self, forKey: .discountRefunded)
        storeId = try values.decodeIfPresent(Int.self, forKey: .storeId)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
        productId = try values.decodeIfPresent(Int.self, forKey: .productId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        images = try values.decodeIfPresent(String.self, forKey: .images)
        nameStore = try values.decodeIfPresent(String.self, forKey: .nameStore)
        addressStore = try values.decodeIfPresent(String.self, forKey: .addressStore)
        phoneStore = try values.decodeIfPresent(String.self, forKey: .phoneStore)
        available = try values.decodeIfPresent(Bool.self, forKey: .available)
//        createdBy = try values.decodeIfPresent(Double.self, forKey: .createdBy)
//        updatedBy = try values.decodeIfPresent(Double.self, forKey: .updatedBy)
//        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
//        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
    
}


struct FoodOderModel: Codable {
    let id: String?
    let code: String?
    let orderItems: [OrderItem]?
    let grandTotal: Int64?
    let feeShip: Int64?
    let discountAmount: Int64?
    let discountShippingFee: Int64?
    let createdAt: String?
    let customerNote: String?
    let baseGrandTotal: Int64?
    let merchantFinalPrice: Int64?
    let vatoAppliedRuleIds: String?
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case code = "code"
        case orderItems = "orderItems"
        case grandTotal = "grandTotal"
        case feeShip = "feeShip"
        case discountAmount = "discountAmount"
        case discountShippingFee = "discountShippingFee"
        case createdAt = "createdAt"
        case customerNote = "customerNote"
        case baseGrandTotal = "baseGrandTotal"
        case merchantFinalPrice = "merchantFinalPrice"
        case vatoAppliedRuleIds = "vatoAppliedRuleIds"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        orderItems = try values.decodeIfPresent([OrderItem].self, forKey: .orderItems)
        grandTotal = try values.decodeIfPresent(Int64.self, forKey: .grandTotal)
        feeShip = try values.decodeIfPresent(Int64.self, forKey: .feeShip)
        discountAmount = try values.decodeIfPresent(Int64.self, forKey: .discountAmount)
        discountShippingFee = try values.decodeIfPresent(Int64.self, forKey: .discountShippingFee)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        customerNote = try values.decodeIfPresent(String.self, forKey: .customerNote)
        baseGrandTotal = try values.decodeIfPresent(Int64.self, forKey: .baseGrandTotal)
        merchantFinalPrice = try values.decodeIfPresent(Int64.self, forKey: .merchantFinalPrice)
        vatoAppliedRuleIds = try values.decodeIfPresent(String.self, forKey: .vatoAppliedRuleIds)
        
    }
    
    static func decodeFromString(string: String?) -> FoodOderModel? {
        guard let string = string else { return nil }
        if let data = string.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(FoodOderModel.self, from: data)
            } catch let err {
                print(err.localizedDescription)
            }
            
        }
        return nil
    }
    var getPrice: Int64? {
        guard let grandTotal = self.baseGrandTotal else {
            return nil
        }
        
        guard let feeShip = self.feeShip else {
            return grandTotal
        }
        
        return grandTotal - feeShip
    }
    var discountPromtion: Int64? {
        if self.vatoAppliedRuleIds != nil {
            return 0
        }
        return self.discountAmount
    }
}

