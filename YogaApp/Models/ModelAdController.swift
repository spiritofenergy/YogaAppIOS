//
//  AdController.swift
//  YogaApp
//
//  Created by Nill Simon on 07.12.2020.
//  Copyright © 2020 Nill Simon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdController: NSObject {
    
    static let ad: AdController = AdController()
    
    var adLoader: GADAdLoader!
    var interstitial: GADInterstitial!

    func getNativeAds(count: Int, view: UIViewController, delegate: GADAdLoaderDelegate) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = count

        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: view,
            adTypes: [GADAdLoaderAdType.unifiedNative],
            options: [multipleAdsOptions])
        adLoader.delegate = delegate
        adLoader.load(GADRequest())
    }
    
    func getInterstitialAd(delegate: GADInterstitialDelegate) {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = delegate
        interstitial.load(GADRequest())
    }
}
