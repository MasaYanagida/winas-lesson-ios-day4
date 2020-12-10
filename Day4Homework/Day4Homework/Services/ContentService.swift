//
//  ContentService.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import Foundation

import SwiftyJSON
import ObjectMapper

class ContentService {
    
    func getSingle(
        completion: ((_ data: Content) -> Void)? = { _ in },
        failure: ((_ error: NSError?, _ statusCode: Int?) -> Void)? = { _, _ in }
        )
    {
        
    }
    
    func getList(
        completion: ((_ dataArray: [Content]) -> Void)? = { _ in },
        failure: ((_ error: NSError?, _ statusCode: Int?) -> Void)? = { _, _ in }
        )
    {
        // TODO
    }
}
