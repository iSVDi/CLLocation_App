//
//  ViewController.swift
//  CLLocationApp
//
//  Created by daniil on 25.10.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let locationLabel = UILabel()
    private let headingDegreesLabel = UILabel()
    private let locationManager = CLLocationManager()
    private let compassNeedle = UIImageView()
    private let signalView = UIView()
    private var didLocationUpdatesCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocation()
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setupView() {
        view.addSubview(locationLabel)
        view.addSubview(headingDegreesLabel)
        view.addSubview(signalView)
        view.addSubview(compassNeedle)
        
        compassNeedle.image = UIImage(systemName: "location.north.line")
        compassNeedle.frame.origin = .init(x: 100, y: 50)
        compassNeedle.frame.size = .init(width: 50, height: 50)
        
        headingDegreesLabel.frame.origin = .init(x: 100, y: 110)
        headingDegreesLabel.frame.size = .init(width: 100, height: 20)
        headingDegreesLabel.textAlignment = .center
        
        locationLabel.text = "No location"
        locationLabel.frame.origin = .init(x: 100, y: 200)
        locationLabel.frame.size = .init(width: 200, height: 200)
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.backgroundColor = .blue
        
        signalView.frame.origin = .init(x: 100, y: 450)
        signalView.frame.size = .init(width: 100, height: 100)
        signalView.layer.cornerRadius = 50
    }
    
    private func blink() {
        signalView.backgroundColor = .green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.signalView.backgroundColor = .white
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didLocationUpdatesCount += 1
        print("didUpdateLocations")
        guard let first = locations.first else {
            locationLabel.text = "fail attempt get first locations'"
            return
        }
        
        locationLabel.text = """
Lat:
\(first.coordinate.latitude)
Long:
\(first.coordinate.longitude)
Location updates \(didLocationUpdatesCount)
"""
        blink()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = newHeading.magneticHeading.toRadians
        
        headingDegreesLabel.text = String(format: "%.3f", newHeading.magneticHeading)
        self.compassNeedle.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted:
            manager.requestAlwaysAuthorization()
        case .denied:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorization is done")
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        @unknown default:
            print("unknown error")
        }
    }
}

extension Double {
    var toRadians: CGFloat { return self * .pi / 180 }
  var toDegrees: Double { return self * 180 / .pi }
}
