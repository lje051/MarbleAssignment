//
//  DiaryViewModel.swift
//  MarvelKIS
//
//  Created by 임지은 on 1/24/24.
//
import RxCocoa
import RxSwift
import UIKit

final class DiaryViewModel: ViewModel, ViewModelProtocol {

    struct Input {
    }

    struct Output {
        let myMemoData: BehaviorRelay<[Diary]> = .init(value: [])
        let myMemoText: BehaviorRelay<String> = .init(value: "")
        
     //   let cells: PublishSubject<[CellModel]> = .init()
    }
    let editItem: PublishSubject<MyMemo> = .init()
    let viewDidAppear: PublishSubject<Void> = .init()
    let input: Input = .init()
    
    
    func transform() -> Output {
        let output: Output = .init()
        
        
        editItem.subscribe(onNext: { [weak self] memo in
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let items = try context.fetch(MyMemo.fetchRequest())
                for saveditem in items where saveditem.id == memo.id {
                    context.delete(saveditem)
                }
                try context.save()
                output.myMemoText.accept(memo.context ?? "")
               // output.showToast.onNext("즐겨찾기 삭제되었습니다.")
                self?.viewDidAppear.onNext(())
            }
            catch {

            }
        })
        .disposed(by: disposeBag)

        
        viewDidAppear
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                do {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let items = try context.fetch(MyMemo.fetchRequest())
                    var list: [Diary] = []
                    items.forEach { memo in
                        let memo: Diary =  .init(id: Int(memo.id), contentText: memo.context ?? "")
                      ///  let cell: DiaryCellModel = .init(memo)
                        list.append(memo)
                    }
                    output.myMemoData.accept(list)
                    return
                }
                catch {
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }

    
}
