//
//  DiaryViewController.swift
//  MarvelKIS
//
//  Created by 임지은 on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DiaryViewController: ViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: IntrinsicSizeCollectionView!
    
    private let input = DiaryViewModel.Input()
    private var output: DiaryViewModel.Output!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        var ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        var btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .bordered, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        textView.inputAccessoryView = ViewForDoneButtonOnKeyboard
        //collectionView.register(DiaryCell.self, forCellWithReuseIdentifier: "DiaryCell")
     //   collectionView.contentInset = .zero
        collectionView.delegate = self
        collectionView.dataSource = self
        textView.delegate = self
        
    }

    
    @IBAction func doneBtnFromKeyboardClicked (sender: Any) {
       print("Done Button Clicked.")
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let items = try context.fetch(MyMemo.fetchRequest())
            var randomNumber = Int(arc4random_uniform(UInt32(100000000+1)))
            let newMemo = MyMemo(context: context)
            var uniqueFlag = false
            
            repeat {
                for saveditem in items where saveditem.id == Int64(randomNumber) {
                    uniqueFlag = false
                }
                if !uniqueFlag {
                    randomNumber = Int(arc4random_uniform(UInt32(100000000+1)))
                }
              
                
            }
            while !uniqueFlag
            
           
           
            newMemo.id = Int64(randomNumber)
            newMemo.context = self.textView.text
         

//            let newItem = MyFavorite(context: context)
//            newItem.id = Int64(favorite.item.id)
//         
//            newItem.name = favorite.item.name
            try context.save()
        }
        catch {

        }
      self.view.endEditing(true)
        
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel as? DiaryViewModel else { return }
        let output = viewModel.transform()
     //   output.cells.bind(to: collectionView.rx.cells).disposed(by: disposeBag)
        output.myMemoText
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
        output.myMemoData.accept([.init(id: 1, contentText: "글을 써보아요~"), .init(id: 2, contentText: "글을 써보아요~"), .init(id: 3, contentText: "글을 써보아요~"), .init(id: 4, contentText: "글을 써보아요~"),.init(id: 5, contentText: "글을 써보아요~"), .init(id: 6, contentText: "글을 써보아요~")])
        rx.viewDidAppear.map { _ in }.bind(to: viewModel.viewDidAppear).disposed(by: disposeBag)
        self.output = output
      
    }

}


extension DiaryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let width = (screenWidth - 40) / 2
        return .init(width: CGFloat(width), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell {
            let item = output.myMemoData.value[indexPath.row]
            cell.bindData(item)
            return cell

        } else {
            return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let totalCnt = output.resultBannerData.value.count
//        let nowIndex = (indexPath.row % totalCnt)
//        input.bannerSelectedCell.onNext(nowIndex)
    }
}
