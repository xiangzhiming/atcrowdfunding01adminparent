<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="UTF-8">
<%--各种外部框架的导入--%>
<%@include file="WEB-INF/include-head.jsp" %>
<script type="text/javascript">
    $(function () {
        $("#asyncBtn").click(function () {

            console.log("ajax函数之前")
            $.ajax({
                url: "/test/ajax/async.html",
                type: "post",
                dataType: "text",
                async: false,    // 关闭异步工作模型，使用同步方式工作，此时：所有操作在同一个线程内，按顺序完成
                success: function (response) {
                    console.log("ajax函数内部的success函数"+response)
                }
            });

            console.log("ajax函数之后")
            // setTimeout(function () {
            //
            // },5000)
        });
    });
</script>
<body>
<%--顶部标签--%>
<%@include file="WEB-INF/include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%--左边菜单栏标签--%>
        <%@include file="WEB-INF/include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <button id="asyncBtn">发送Ajax请求</button>
        </div>
    </div>
</div>
</body>
</html>