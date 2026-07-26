//
//  Coordinator.swift
//  MovieVault
//
//  Created by Faruk on 19.07.2026.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }

    func start()
}
