<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%--各种外部框架的导入--%>
<%@include file="/WEB-INF/include-head.jsp" %>
<body>
<%--顶部标签--%>
<%@include file="/WEB-INF/include-nav.jsp" %>

<script type="text/javascript">
    $(function () {
        $("#toRigthBtn").click(function () {

            // select是标签选择器
            // eq(0)表示选择页面上的第一个
            // eq(1)表示选择页面上的第二个
            // > 表示选择子元素
            // selected表示被选中的option
            // appendTO能够将jquery对象追加到指定位置
            $("select:eq(0)>option:selected").appendTo("select:eq(1)");
        });

        $("#toLeftBtn").click(function () {
            $("select:eq(1)>option:selected").appendTo("select:eq(0)");
        });

        $("#submitBtn").click(function () {
            $("select:eq(1)>option").prop("selected", "selected");
        })
    })
</script>

<div class="container-fluid">
    <div class="row">
        <%--左边菜单栏标签--%>
        <%@include file="/WEB-INF/include-sidebar.jsp" %>
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                <ol class="breadcrumb">
                    <li><a href="#">首页</a></li>
                    <li><a href="#">数据列表</a></li>
                    <li class="active">分配角色</li>
                </ol>
                <div class="panel panel-default">
                    <div class="panel-body">

                        <form action="/a/b/c.html" method="post" role="form" class="form-inline">
                            <input type="hidden" name="adminId" value="${param.adminId}">
                            <input type="hidden" name="pageNum" value="${param.pageNum}">
                            <input type="hidden" name="keyword" value="${param.keyword}">
                            <div class="form-group">
                                <label for="exampleInputPassword1">未分配角色列表</label><br>
                                <select class="form-control" multiple="multiple" size="10" style="width:100px;overflow-y:auto;">
                                    <c:forEach items="${requestScope.unAssignedRoleList}" var="role">
                                        <option value="${role.id}">${role.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <ul>
                                    <li id="toRigthBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                                    <br>
                                    <li id="toLeftBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                                </ul>
                            </div>
                            <div class="form-group" style="margin-left:40px;">
                                <label for="exampleInputPassword1">已分配角色列表</label><br>
                                <select name="roleIdList" class="form-control" multiple="multiple" size="10" style="width:100px;overflow-y:auto;">
                                    <c:forEach items="${requestScope.assignedRoleList}" var="role">
                                        <option value="${role.id}">${role.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                           <%-- <button  type="submit" style="width: 150px" class="btn btn-lg btn-success btn-block">保存1</button>--%>
                            <button id="submitBtn" type="submit" style="width: 150px" class="btn btn-lg btn-success btn-block">保存</button>
                        </form>
                    </div>
                </div>
            </div>
    </div>
</div>
</body>
</html>