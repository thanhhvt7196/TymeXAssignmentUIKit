//
//  Controller.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 5/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class Controller<VM: ViewModel>: UIViewController {
    private let viewModel: VM!

    var vm: VM {
        return viewModel
    }

    let disposeBag = DisposeBag()
    
    private let defaultBackButton = UIButton(type: .custom)
    var backAction: (() -> Void)?
        
    private lazy var defaultBackBarButton: UIBarButtonItem = {
        let containerView = UIView()
        containerView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let backImage = UIImageView(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate))
        backImage.contentMode = .scaleAspectFit
        backImage.tintColor = .baseText
        backImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backImage)
        
        backImage.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        containerView.addSubview(defaultBackButton)
        defaultBackButton.backgroundColor = .clear
        defaultBackButton.setTitle(nil, for: .normal)
        
        defaultBackButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        defaultBackButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
        let customBackButton = UIBarButtonItem(customView: containerView)
        return customBackButton
    }()
    
    @objc private func pop() {
        if let backAction = backAction {
            backAction()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    required init(vm: VM, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        viewModel = vm
        let resourceName = nibNameOrNil ?? String(describing: Self.self)
        if Bundle.main.path(forResource: resourceName, ofType: "xib") == nil {
            super.init(nibName: nil, bundle: nil)
        } else {
            super.init(nibName: resourceName, bundle: nibBundleOrNil)
        }
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.lifeCycle.accept(.didLoad)
        setupDefaultBackButton()
        setup()
    }
    
    private func setupDefaultBackButton() {
        if self != navigationController?.viewControllers.first {
            navigationController?.navigationBar.tintColor = Asset.Colors.baseText.color
            navigationItem.leftBarButtonItem = defaultBackBarButton
        }
    }
    
    func setDefaultBackButtonColor(color: UIColor) {
        if navigationItem.leftBarButtonItem == defaultBackBarButton {
            navigationController?.navigationBar.tintColor = color
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.lifeCycle.accept(.willAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.lifeCycle.accept(.willDisappear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.lifeCycle.accept(.didAppear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        vm.lifeCycle.accept(.didDisappear)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vm.lifeCycle.accept(.didLayoutSubviews)
        updateConstraints()
    }

    func setup() {
        view.backgroundColor = .white
    }
    
    func updateConstraints() {
        
    }

    deinit {
        print("\(String(describing: self)) deinit")
    }
}
