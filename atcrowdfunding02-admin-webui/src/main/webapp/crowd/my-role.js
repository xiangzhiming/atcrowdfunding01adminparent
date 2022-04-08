// 执行分页，生成页面效果，任何时候调用这个函数都会重新加载页面
function generatePage() {

    // 1.获取分页数据
    var pageInfo = getPageInfoRemote();

    // 2.填充表格
    fillTableBody(pageInfo);
}

// 远程访问服务器端程序获取pageInfo数据
function getPageInfoRemote() {

    //调用$.ajax()函数发送请求并接受$.ajax()函数的返回值
    var ajaxResult = $.ajax({
        url: "role/get/page/info.json",
        type: "post",
        data: {
            pageNum: window.pageNum,
            pageSize: window.pageSize,
            keyword: window.keyword
        },
        async: false,
        dataType: "json",
        // success: function (resp) {
        //     var pageInfo = resp.data;
        //     fillTableBody(pageInfo);
        //
        // },
        // error: function (resp) {
        //
        // }
    });
    console.log(ajaxResult)

    // 判断当前相应状态码是否为200
    var statusCode = ajaxResult.status;

    // 如果当前响应状态码不是200，说明发生了错误或其他意外情况，显示提示消息，让当前函数停止执行
    if (statusCode != 200) {
        layer.msg("服务器端程序调用失败！响应状态码时="+statusCode+"说明信息"+ajaxResult.statusText)
        return null;
    }

    // 如果当前响应码是200，说明请求处理成功，获取pageInfo
    var resultEntity = ajaxResult.responseJSON;


    // 从resultEntity中获取result属性
    var result = resultEntity.result;

    // 判断result是否成功
    if (result == "FAILED") {
        layer.msg(resultEntity.message);
        return null;
    }

    // 确认result为成功后获取pageInfo
    var pageInfo = resultEntity.data;



    // 返回pageInfo
    return pageInfo
}

// 填充表格
function fillTableBody(pageInfo) {

    // 清除tbody中的旧的内容
    $("#rolePageBody").empty();

    // 这里清空是为了没有搜索结果时不显示页码导航条
    $("#Pagination").empty();

    // 判断pageInfo对象是否有效
    if (pageInfo == null || pageInfo == undefined || pageInfo.list == null || pageInfo.list.length == 0) {
        $("#rolePageBody").append("<tr><td colspan='4'>抱歉！没有查询到您搜索的数据</td></tr>")
        return null;
    }
    console.log("data=:"+pageInfo.list[0].name);


    // 使用pageInfo的list属性填充tbody
    for (var i = 0; i < pageInfo.list.length; i++) {
        var role = pageInfo.list[i];
        var roleId = role.id;
        var roleName = role.name;
        var numberId = "<td>"+(i+1)+"</td>";
        var checkboxTd = "<td><input type='checkbox'></td>"
        var roleNameTd = "<td>"+roleName+"</td>";

        var checkBtn = "<button type='button' class='btn btn-success btn-xs'><i class=' glyphicon glyphicon-check'></i></button>";
        var pencilBtn = "<button type='button' class='btn btn-primary btn-xs'><i class=' glyphicon glyphicon-pencil'></i></button>";
        var removeBtn = "<button type='button' class='btn btn-danger btn-xs'><i class=' glyphicon glyphicon-remove'></i></button>"

        var buttonTd = "<td>"+checkBtn+" "+pencilBtn+" "+removeBtn+"</td>";

        var tr = "<tr>"+numberId+checkboxTd+roleNameTd+buttonTd+"</tr>"
        $("#rolePageBody").append(tr);
    }

    // 生成分页页码导航条
    generateNavigator(pageInfo)
}

// 生成分页页码导航条
function generateNavigator(pageInfo) {
    // 获取总记录数
    var totalRecord = pageInfo.total;

    // 声明相关属性
    var properties = {
        num_edge_entries: 3,								// 边缘页数
        num_display_entries: 5,								// 主体页数
        callback: pageinationCallBack,						// 指定用户点击“翻页”的按钮时跳转页面的回调函数
        items_per_page: pageInfo.pageSize,	// 每页要显示的数据的数量
        current_page: pageInfo.pageNum - 1,	// Pagination内部使用pageIndex来管理页码，pageIndex从0开始，pageNum从1开始，所以要减一
        prev_text: "上一页",									// 上一页按钮上显示的文本
        next_text: "下一页"									// 下一页按钮上显示的文本
    };

    //调用Pagination()函数
    $("#Pagination").pagination(totalRecord, properties);
}

// 翻页时的回调函数
function pageinationCallBack(pageIndex,jQuery) {

    //修改window对象的pageNum属性
    window.pageNum = pageIndex + 1;

    //调用分页函数
    generatePage();

    // 取消页码超链接的默认行为
    return false;
}