//
//  ViewController.swift
//  MapKitTest33
//
//  Created by Николай Гринько on 07.02.2024.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	
	var places: [Places] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		mapView.delegate = self
		// координаты положения юзера
		let initialLocation = CLLocation(latitude: 59.929691, longitude: 30.362239)
		mapView.centerLocation(initialLocation)
		
		// граница увеличения карты
		let cameraCenter = CLLocation(latitude: 59.929691, longitude: 30.362239)
		let region = MKCoordinateRegion(center: cameraCenter.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
		mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
		
		// с какого и по какой масштаб сможет увеличивать
		let zoomRage = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
		mapView.setCameraZoomRange(zoomRage, animated: true)
		
		// переменная с json files
		let kC = Places(
			title: "Казанский собор",
			locationName: "Казанская пл. 2",
			discipline: "Cathedral",
			coordinate: CLLocationCoordinate2D(latitude: 59.934257, longitude: 30.324495))
		
//		let kCS = Places(
//			title: "Дом Зингер",
//			locationName: "Невский пр-т 28",
//			discipline: "Home",
//			coordinate: CLLocationCoordinate2D(latitude: 59.935851, longitude: 30.326103))
//		
		//mapView.addAnnotation(kCS)
		  mapView.addAnnotation(kC)
		
		loadInitialData()
		mapView.addAnnotations(places)
	}

	// метод берет данные с json с проекта
	func loadInitialData() {
		guard let fileName = Bundle.main.url(forResource: "Places", withExtension: "geojson"),
			 
		let placesData = try? Data(contentsOf: fileName)
		else {
			return
		}
		do {
			let features = try MKGeoJSONDecoder()
				.decode(placesData)
				.compactMap {$0 as? MKGeoJSONFeature}
			let validWorks = features.compactMap(Places.init)
			places.append(contentsOf: validWorks)
			print(places[0].coordinate)
			print(validWorks)
		} catch {
			print(placesData)
			print(fileName)
			print("\(error)")
		}
	}
}

// локация положения юзера
extension MKMapView {
	func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		setRegion(coordinateRegion, animated: true)
	}
}

extension ViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? Places else {
			return nil
		}
		let identifier = "places"
		let view: MKMarkerAnnotationView
		
		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "places") as? MKMarkerAnnotationView {
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		return view
	}
	
	// пользователь нажимает на правую кнопку описания - вывод
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		guard let places = view.annotation as? Places else {
			return
		}
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
		
		places.mapItem?.openInMaps(launchOptions: launchOptions)
	}
}
