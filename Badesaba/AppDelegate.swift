//
//  AppDelegate.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var language = "fa"

    var window: UIWindow?
    lazy var container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ThemeManager.applyTheme(theme: .light)
        
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        
        setupModules()
        
        let viewController = (container.resolve(UserSettingLocationView.self) as! UIViewController)
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupModules() {
        // Setup app dependencies
        self.container.register(CoreDataStack.self) { (_) in
            return CoreDataStack()
        }
        
        setupUserSetting()
    }
    
    func setupUserSetting() {
        typealias Presenter = UserSettingLocationPresentation & UserSettingInteractorOutput
        
        container.register(UserSettingLocationView.self) { (_) in
            return UserSettingLocationViewController()
        }
            .initCompleted { (resolver, view) in
                (view as? UserSettingLocationViewController)?.presenter = resolver.resolve(Presenter.self)
        }
        
        container.register(Presenter.self) { (_) in
            return UserSettingPresenter()
        }
            .initCompleted { (resolver, presenter) in
                (presenter as? UserSettingPresenter)?.view = resolver.resolve(UserSettingLocationView.self)
                (presenter as? UserSettingPresenter)?.interactor = resolver.resolve(UserSettingInteractorType.self)
        }
        
        container.register(UserSettingInteractorType.self) { (_) in
            return UserSettingInteractor()
        }
            .initCompleted { (resolver, interactor) in
                (interactor as? UserSettingInteractor)?.output = resolver.resolve(Presenter.self)
                (interactor as? UserSettingInteractor)?.locationRepository = resolver.resolve(LocationDataProvider.self)
        }
        
        container.register(LocationDataProvider.self) { (_) in
            return LocationUserSettingRepository()
        }
            .initCompleted { (resolver, provider) in
                (provider as? LocationUserSettingRepository)?.localService = resolver.resolve(LocationUserSettingLocalService.self)
        }
        
        container.register(LocationUserSettingLocalService.self) { (_) in
            return ILocationUserSettingLocalService()
        }
            .initCompleted { (resolver, localService) in
                (localService as? ILocationUserSettingLocalService)?.coreDataStack = self.container.resolve(CoreDataStack.self)
        }
    }
}

