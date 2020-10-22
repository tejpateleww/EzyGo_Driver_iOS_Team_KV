//
//  ActionSheet+Presenter.swift
//  Sheeeeeeeeet
//
//  Created by Daniel Saidi on 2018-04-27.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

public extension ActionSheet {
    
    static var defaultPresenter: ActionSheetPresenter {
        return UIDevice.current.userInterfaceIdiom.defaultPresenter
    }
}


// MARK: - Internal Extensions

extension UIUserInterfaceIdiom {
    
    var defaultPresenter: ActionSheetPresenter {
        switch self {
        case .pad: return ActionSheetPopoverPresenter()
        default: return ActionSheetStandardPresenter()
        }
    }
}
