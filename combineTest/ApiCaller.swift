//
//  ApiCaller.swift
//  combineTest
//
//  Created by Pavel Andreev on 3/9/23.
//

import Foundation
import Combine

class APIcaller {
    
    static let shared = APIcaller()
    
    func fetchCompanies() -> Future<[String], Error> {
            return Future { promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success(["Apple", "Google", "Amazon", "Facebook"]))
            }
        }
    }
    
    
}
