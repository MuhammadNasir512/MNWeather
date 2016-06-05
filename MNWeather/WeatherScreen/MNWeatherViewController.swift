//
//  MNWeaterhViewController.swift
//  MNWeather
//
//  Created by Muhammad Nasir on 04/06/2016.
//  Copyright © 2016 Muhammad Nasir. All rights reserved.
//

import UIKit

class MNWeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherDescriptionLabel:UILabel?
    @IBOutlet weak var maxTemperatureLabel:UILabel?
    @IBOutlet weak var minTemperatureLabel:UILabel?
    @IBOutlet weak var temperatureLabel:UILabel?
    @IBOutlet weak var humidityLabel:UILabel?
    @IBOutlet weak var cityNameLabel:UILabel?
    @IBOutlet weak var backgroundImageView:UIImageView?
    @IBOutlet weak var activityIndicatorView:UIActivityIndicatorView?

    private var presenter: MNWeatherPresenter {
        let presenter = MNWeatherPresenter()
        presenter.viewController = self
        return presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        showActivityIndicator()
        presenter.startLoadingWeatherInformation()
    }
    
    func updateUIWithData(model :MNWeatherModel) {
        weatherDescriptionLabel?.text = model.weatherDescription
        minTemperatureLabel?.text = model.minTemperature
        maxTemperatureLabel?.text = model.maxTemperature
        temperatureLabel?.text = model.temperature
        humidityLabel?.text = model.humidity
        cityNameLabel?.text = model.cityName
        if let bgImageName = model.backgroundImageName {
            backgroundImageView?.image = UIImage(named: bgImageName)
        }
        hideActivityIndicator()
    }
    
    func handleErrorWithMessage(message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        hideActivityIndicator()
    }
    
    private func showActivityIndicator () {
        activityIndicatorView?.startAnimating()
    }
    
    private func hideActivityIndicator () {
        activityIndicatorView?.stopAnimating()
    }
    
}

