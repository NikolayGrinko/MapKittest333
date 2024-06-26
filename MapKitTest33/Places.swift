//
//  Places.swift
//  MapKitTest33
//
//  Created by Николай Гринько on 08.02.2024.
//

import Foundation
import MapKit
import Contacts

open class Places: NSObject, MKAnnotation {
	
	public let title: String?
	let locationName: String?
	let discipline: String?
	public let coordinate: CLLocationCoordinate2D
	
	init(title: String?,
		 locationName: String?,
		 discipline: String?,
		 coordinate: CLLocationCoordinate2D) {
		
		self.title = title
		self.locationName = locationName
		self.discipline = discipline
		self.coordinate = coordinate
		
		super.init()
	}
	
	// метод работающий со всеми данными с json formatter
	init?(feature: MKGeoJSONFeature) {
		guard
			let point = feature.geometry.first as? MKPointAnnotation,
			let propertiesData = feature.properties,
			let json = try? JSONSerialization.jsonObject(with: propertiesData),
			let properties = json as? [String: Any]
		else {
			return nil
		}
		title = properties["title"] as? String
		locationName = properties["locationName"] as? String
		discipline = properties["disciple"] as? String
		coordinate = point.coordinate
		super.init()
		
	}
	
	public var subtitle: String? {
		return locationName
	}
	
	var mapItem: MKMapItem? {
		
		guard let location = locationName else {
			return nil
		}
		
		let adressDict = [CNPostalAddressStreetKey: location]
		let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: adressDict)
		
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = title
		return mapItem
	}
}
