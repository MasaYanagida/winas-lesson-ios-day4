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
        _ = SampleNetwork.request(
            target: .getList,
            success: { json, _ in
                guard let safeJson = json else { return }
                // run in main => UI thread
                DispatchQueue.main.async { [weak self] in
                    if let dataArray = Mapper<Content>().mapArray(JSONObject: safeJson.arrayObject) {
                        completion?(dataArray)
                    } else {
                        failure?(nil, nil)
                    }
                }
            },
            error: { /*statusCode*/_ in
                failure?(nil, nil)
            },
            failure: { /*error*/_ in
                failure?(nil, nil)
            }
        )
    }
}
