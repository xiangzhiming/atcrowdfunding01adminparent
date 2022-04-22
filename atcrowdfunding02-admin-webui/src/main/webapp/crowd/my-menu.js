// 生成树型结构的函数
function generateTree() {
    // 1准备生成树形结构的json数据，数据的来源是发送ajax请求得到
    $.ajax({
        url: "/menu/get/whole/tree.json",
        type: "post",
        dataType: "json",
        success: function (resp) {
            var result = resp.result;
            if (result == "SUCCESS") {

                // 2创建json对象用于存储zTree所做的设置
                var setting = {
                    view: {
                        addDiyDom: myAddDiyDom,
                        addHoverDom: myAddHoverDom,
                        removeHoverDom: myRemoveHoverDom
                    },
                    data: {
                        key: {
                            url: "Xurl"
                        }
                    }
                };

                // 3从响应体中获取用来生成树形结构的json数据
                var zNodes = resp.data;

                // 4初始化树形结构
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            }
            if (result == "FAILED") {
                layer.msg(resp.message)
            }
        },
        error: function (resp) {
            layer.msg(resp.message)
        }
    })
}

// 鼠标离开节点范围时删除按钮组
function myRemoveHoverDom(treeId, treeNode) {

    // 拼接按钮组的id
    var btnGroupId = treeNode.tId + "btnGrp";

    // 移除对应的元素
    $("#" + btnGroupId).remove();

}

// 鼠标移入节点范围时添加按钮组
function myAddHoverDom(treeId, treeNode) {

    // 按钮组的结构：<span><a><i></i></a><a><i></i></a></span>
    // 按钮组出现的位置：节点中treeDemo_n_a超链接的后面

    // 为了在需要移除按钮组的时候能够精确定位到按钮组所在span，需要给span设置有规律的id
    var btnGroupId = treeNode.tId + "btnGrp";

    // 判断一下以前是否已经添加了按钮组
    if ($("#" + btnGroupId).length > 0) {
        return
    }

    // 准备各个按钮的HTML标签
    var addBtn = "<a id='"+treeNode.id+"' class='addBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='添加菜单'>&nbsp;&nbsp;<i class='fa fa-fw fa-plus rbg '></i></a>";
    var removeBtn = "<a id='"+treeNode.id+"' class='removeBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='删除该菜单'>&nbsp;&nbsp;<i class='fa fa-fw fa-times rbg '></i></a>";
    var editBtn = "<a id='"+treeNode.id+"' class='editBtn editBtnbtn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='修改该菜单'>&nbsp;&nbsp;<i class='fa fa-fw fa-edit rbg '></i></a>";

    // 获取当前节点的级别数据
    var level = treeNode.level;

    // 声明变量存储拼接好的按钮代码
    var btmHTML = '';

    // 判断当前节点的级别
    if (level == 0) {
        // 级别为0时是根节点，只能添加子节点和修改节点
        btmHTML = addBtn +" "+editBtn;
    };

    if (level == 1) {
        // 级别为1时是分支节点，可以添加子节点，可以修改
        btmHTML = addBtn+" "+editBtn;

        // 获取当前节点的子节点数量
        var length = treeNode.children.length;

        // 如果没有子节点，可以删除
        if (length == 0) {
            btmHTML = btmHTML +" "+removeBtn;
        }
    }

    if (level == 2) {
        // 级别为2时是叶子节点，可以修改、删除
        btmHTML = editBtn +" "+removeBtn;
    }


    // 找到附着按钮组的超链接
    var anchorId = treeNode.tId + "_a";

    // 执行在超链接后面附加span元素的操作
    $("#" + anchorId).after("<span id='" + btnGroupId + "'>"+btmHTML+"</span>")
}

// 修改默认的图标
function myAddDiyDom(treeId, treeNode) {

    // treeId是整个树形结构附着的ul标签的id
    console.log(treeId);

    // 当前树形节点的全部的数据，包括从后端查询得到的menu对象的全部属性
    console.log(treeNode)

    // zTree生成id的规则
    // 例子:treeDemo_7_ico
    // 解析:ul标签的id_当前节点的序号_功能
    // 提示：“ul标签的id_当前节点的序号"部分可以通过访问treeNode的tId属性得到
    // 根据id的生成规则拼接出来span标签的id
    // 根据id的生成规则拼接出来span标签的id
    var spanId = treeNode.tId + "_ico";

    // 根据控制图标的span标签的id找到这个span标签
    // 删除旧的clas、添加新的class
    $("#" + spanId).removeClass().addClass(treeNode.icon)
}