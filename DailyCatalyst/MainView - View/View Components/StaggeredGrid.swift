//
//  StaggeredGrid.swift
//  StaggeredGrid (iOS)
//
//  Created by 李宇鸿 on 2022/8/13.
//

import SwiftUI
// 自定义视图构建器…… Content 外界传递的视图
// T -> 是用来保存可识别的数据集合… 外界传递的列表模型数据

struct StaggeredGrid<Content: View, T : Identifiable>: View where T: Hashable {
    // 它将从集合中返回每个对象来构建视图…
    var content: (T) -> Content
    var list : [T]
    // 列……
    var columns : Int
    // 属性
    var showsIndicators : Bool
    var spacing : CGFloat
    // 提供构造函数的闭包
    init(columns: Int, showsIndicators: Bool = false,spacing : CGFloat = 10, list:[T], @ViewBuilder content: @escaping(T)->Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.columns = columns
    }
    // 交错网格功能…
    func setUpList()->[[T]] {
        // 创建列的空子数组计数…
        var gridArray : [[T]] = Array(repeating: [], count: columns)
        // 用于Vstack导向视图的拆分数组…
        var currentIndex : Int = 0
        for object in list{
            gridArray[currentIndex].append(object)
            // increasing index count
            // and resetting fi overbounds the columns count...
            //增加索引计数
            //和重置fi越界列计数…
            if currentIndex == (columns - 1) {
                currentIndex = 0
            }
            else {
                currentIndex += 1
            }
        }
        return gridArray
    }
    var body: some View {
        ScrollView(.vertical,showsIndicators: showsIndicators) {
            HStack(alignment:.top){
                ForEach(setUpList(),id:\.self){ columnsData in
                    // 优化使用LazyStack…
                    LazyVStack(spacing:spacing){
                        ForEach(columnsData) { object in
                            content(object)
                        }
                    }
                }
            }
            //只有垂直填充…
            //水平填充将是用户可选的…
            .padding(.vertical)
        }
    }
}
