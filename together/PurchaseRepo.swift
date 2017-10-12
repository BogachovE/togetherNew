//
//  PurchaseRepo.swift
//  together
//
//  Created by Bogachov on 05.09.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import StoreKit
import PromiseKit

class PurchaseRepo {
    
//    var context: CreateNewEventViewController!
//    let COINS_PRODUCT_ID = "com.products.attractive.togetherr.wish"
//    var productID = ""
//    
//    init(context: CreateNewEventViewController!) {
//        self.context = context
//    }
//    
//    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
//    func purchaseMyProduct(product: SKProduct) {
//        if self.canMakePurchases() {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(context.self)
//            SKPaymentQueue.default().add(payment)
//            
//            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
//            productID = product.productIdentifier
//            
//            
//            // IAP Purchases dsabled on the Device
//        } else {
//            UIAlertView(title: "IAP Tutorial",
//                        message: "Purchases are disabled in your device!",
//                        delegate: nil, cancelButtonTitle: "OK").show()
//        }
//    }
//    
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction:AnyObject in transactions {
//            if let trans = transaction as? SKPaymentTransaction {
//                switch trans.transactionState {
//                    
//                case .purchased:
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                        UIAlertView(title: "Successfully",
//                                    message: "You've successfully add wishes",
//                                    delegate: nil,
//                                    cancelButtonTitle: "OK").show()
//                    return
//                    break
//                    
//                case .failed:
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    break
//                case .restored:
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    break
//                    
//                default: break
//                }
//        }
//    }
//        
//        
//        func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
//            print("Product request phase")
//            
//            print(response.invalidProductIdentifiers)
//            
//            let myProduct = response.products
//            context.iapProducts.append(myProduct[0])
//            
//            for product in myProduct {
//                print("Товар добавлен")
//                print("Идентификатор продукта: \(product.productIdentifier)")
//                print("\(product.localizedTitle)")
//                print("\(product.localizedDescription)")
//            }
//            
//            
//        }
//    }
//    
//    
}

