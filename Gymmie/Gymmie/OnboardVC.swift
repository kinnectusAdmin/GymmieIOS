//
//  OnboardVC.swift
//  Gymmie
//
//  Created by Blake Rogers on 10/3/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class OnboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tutorialCollectionView.register(TutorialCell.self, forCellWithReuseIdentifier: "TutorialCell")
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
       UserDefaults.standard.set(true, forKey: "tutorialViewed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

lazy var tutorialCollectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: 350, height: 500)
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: self.view.frame.width, height: 400)
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.backgroundColor = UIColor.clear
    collection.decelerationRate = UIScrollView.DecelerationRate.fast
            collection.showsHorizontalScrollIndicator = false
            collection.isScrollEnabled = false
        return collection
    }()
    
    var tutorials: [UIImage]{
        return [#imageLiteral(resourceName: "onboard1"),#imageLiteral(resourceName: "onboard2"),#imageLiteral(resourceName: "onboard3"),#imageLiteral(resourceName: "onboard4"),#imageLiteral(resourceName: "onboard5"),#imageLiteral(resourceName: "onboard6")]
    }
    
    @objc func startTutorialHandler(_ sender: UIButton){
        startButton.alpha = 0
        let nextPage = IndexPath(item: 1, section: 0)
        currentPage = 1
        tutorialCollectionView.scrollToItem(at: nextPage, at: .centeredHorizontally, animated: true)
    }
    let startButton: UIButton = {
        let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "onboardGetStarted"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func skipTutorialHandler(_ sender: UIButton){
        skipButton.alpha = 0
        let end = IndexPath(item: 5, section: 0)
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
//                appDel.skippedTutorial(from: currentPage )
        }
        currentPage = 5
        tutorialCollectionView.scrollToItem(at: end, at: .centeredHorizontally, animated: true)
       
    }
    
    let skipButton: UIButton = {
        let button = UIButton()
            button.setTitle("Skip", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(gymmieOrange(), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
            label.text = "GymmieTest"
            label.alpha = 0
            label.textColor = gymmieOrange()
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    let tutorialLine: UIView = {
        let line = UIView()
            line.alpha = 0
            line.backgroundColor = gymmieOrange()
            line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    let pageIndicator: UIPageControl = {
       
        let control = UIPageControl()
            control.currentPage = 0
            control.alpha = 0
            control.numberOfPages = 6
            control.currentPageIndicatorTintColor = gymmieOrange()
            control.pageIndicatorTintColor = gymmieOrange().withAlphaComponent(0.7)
        
            control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    var currentPage: Int = 0{
        didSet{
            print(currentPage)
            pageIndicator.currentPage = currentPage
            switch currentPage {
            case 1,2,3,4:
                descriptionLabel.alpha = 1.0
                descriptionLabel.text = "How it Works"
                tutorialLine.alpha = 1.0
                startButton.alpha = 0
                pageIndicator.alpha = 1.0
            case 5:
                descriptionLabel.alpha = 1.0
                descriptionLabel.text = "You're Ready!"
                pageIndicator.alpha = 0
                startButton.alpha = 0
            default:
                descriptionLabel.text = "Gymmie"
                descriptionLabel.alpha = 0
                tutorialLine.alpha = 0
                startButton.alpha = 1.0
                pageIndicator.alpha = 0
            }
        }
    }
    
    func setupViews(){
        let margins = view.layoutMarginsGuide
        view.add(views: pageIndicator,tutorialCollectionView,descriptionLabel,tutorialLine,startButton,skipButton)
      
        tutorialCollectionView.delegate = self
        tutorialCollectionView.dataSource = self
        
      
        //constrain description label
        descriptionLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        //constrain tutorial line
        tutorialLine.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        tutorialLine.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        tutorialLine.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 8).isActive = true
        tutorialLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        //constrain page indicator
        pageIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        pageIndicator.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50).isActive = true
        view.addVisualConstraints("H:[v0(50)]", views: pageIndicator)
        view.addVisualConstraints("V:[v0(10)]", views: pageIndicator)
        //constrain start button
        startButton.centerXAnchor.constraint(equalTo: tutorialCollectionView.centerXAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: tutorialCollectionView.bottomAnchor).isActive = true
        startButton.addTarget(self, action: #selector(OnboardVC.startTutorialHandler(_:)), for: .touchUpInside)
        
        //constrain tutorial collection to bottom of description label
        tutorialCollectionView.setXTo(con: view.x(), by: 0)
        tutorialCollectionView.setWidthTo(constant: view.frame.width)
        tutorialCollectionView.topAnchor.constraint(equalTo: tutorialLine.bottomAnchor, constant: 0).isActive = true
        tutorialCollectionView.bottomAnchor.constraint(equalTo: pageIndicator.topAnchor, constant: 0).isActive = true
        //constrain skipButton and add selector
        skipButton.rightAnchor.constraint(equalTo: margins.rightAnchor,constant: 0).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        skipButton.addTarget(self, action: #selector(OnboardVC.skipTutorialHandler(_:)), for: .touchUpInside)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OnboardVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.isScrollEnabled = false
        if let cell = tutorialCollectionView.cellForItem(at: IndexPath(item: 5, section: 0)) as? TutorialCell{
            cell.goHomeButton.alpha = 1.0
            descriptionLabel.text = "You're Ready!"
            descriptionLabel.alpha = 1.0
            tutorialLine.alpha = 1.0
            pageIndicator.alpha = 1.0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"TutorialCell", for: indexPath) as! TutorialCell
            cell.tutorialDelegate = self
            cell.tutorialImage.image = tutorials[indexPath.item]
        cell.goHomeButton.alpha = indexPath.item != 5 ? 0.0 : 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextItem = indexPath.item+1
        let nextCellPath = IndexPath(item: nextItem, section: indexPath.section)
        if nextItem < collectionView.numberOfItems(inSection: indexPath.section){
            currentPage += 1
            collectionView.isScrollEnabled = true
            collectionView.scrollToItem(at: nextCellPath, at: .centeredHorizontally, animated: true)
        }
    }

}
extension OnboardVC: TutorialDelegate{
    func signUp() {
      let signUp = SignInVC()
        present(signUp, animated: true , completion: nil)
    }
}

