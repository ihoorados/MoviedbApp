//
//  ApplicationCoordinator.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit

final class ApplicationCoordinator{

    var navigationController: UINavigationController
    private let applicationDIContainer: ApplicationDIContainer

    init(navigationController: UINavigationController, applicationDIContainer: ApplicationDIContainer) {
        
        self.navigationController = navigationController
        self.applicationDIContainer = applicationDIContainer
    }

    func start() {
        
        let moviesSceneDIContainer = applicationDIContainer.makeMoviesSceneDIContainer()
        let flow = moviesSceneDIContainer.makeMoviesSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
}

