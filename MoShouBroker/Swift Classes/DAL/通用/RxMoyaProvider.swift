//
//  RxMoyaProvider.swift
//  MoShou2
//  扩展Moay网络数据请求对象，新增rxRequest方法用来返回一个包含数据结果的可被订阅对象
//  Created by NiLaisong on 2018/3/20.
//  Copyright © 2018年 5i5j. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift

typealias RxMoyaCompletion = (_ result:Result<Moya.Response, Moya.MoyaError>) -> ResponseResult

extension MoyaProvider
{
        func rxRequest(_ target: Target, completion: @escaping RxMoyaCompletion) -> PublishSubject<ResponseResult>
        {
            let subject = PublishSubject<ResponseResult>()
//            let observable = Observable.create{(sbuscribe:AnyObserver<ResponseResult>) -> Disposable in
                let provider = MoyaProvider<Target>()
                provider.request(target)
                    { result in
                        let resResult = completion(result)
                        subject.onNext(resResult)
                        subject.onCompleted()
                    }
                
//                return Disposables.create()
//            }
            return subject
        }
}
