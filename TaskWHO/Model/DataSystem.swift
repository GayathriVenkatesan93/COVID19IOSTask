//
//  DataSystem.swift
//  TaskWHO
//
//  Created by Gayathri on 26/11/20.
//  Copyright © 2020 Gayathri. All rights reserved.
//

import UIKit

class DataSystem: NSObject {
    
    static let sharedInstance = DataSystem()
    
    var strCountry = String()
    var arrresult = NSArray()
    var dicValue = NSDictionary()
    let  displayDataModel = DataModel()
    
    func get(completition: @escaping (_ response: NSDictionary) -> Void){
        strCountry = Utils.getPreferenceValue(ForKey: Constant.COUNTRYCODE)
        let Url = "https://services.arcgis.com/5T5nSi527N4F7luB/arcgis/rest/services/COVID19_hist_cases_adm0_v5_view/FeatureServer/0/query?where=ISO_2_CODE+%3D+%27"+strCountry+"%27+&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=CumCase%2CCumDeath&returnHiddenFields=false&returnGeometry=false&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=date_epicrv+DESC&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=1&returnZ=false&returnM=false&returnExceededLimitFeatures=false&quantizationParameters=&sqlFormat=none&f=pjson&token="
        guard let loanUrl = URL(string: Url) else { return }
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {( data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                print(data)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    self.arrresult = jsonResult!["features"] as! NSMutableArray
                    for i in 0..<self.arrresult.count{
                        let dictTktLst:NSDictionary = self.arrresult.object(at: i) as! NSDictionary
                        self.dicValue = dictTktLst["attributes"] as! NSDictionary
                    }
                    DispatchQueue.main.async {
                        completition(self.dicValue)
                    }
                } catch {print(error)}
            }
        })
        task.resume()
    }
}
