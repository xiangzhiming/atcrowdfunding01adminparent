<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css" />
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>
<script type="text/javascript" src="/crowd/my-role.js"/>
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>


<script type="text/javascript">
	$(function () {
		// 1.为分页操作准备初始化数据
		window.pageNum = 1;
		window.pageSize = 5;
		window.keyword = "";

		// 2.调用执行分页的函数,显示分页效果
		generatePage();

		// 3.给查询按钮绑定单击响应函数
		$("#searchBtn").click(function () {

			// 获取关键词数据赋值给对应的全局变量
			window.keyword = $("#keywordInput").val();

			// 调用分页函数刷新页面
			generatePage();
		});
		
		// 点击新增按钮打开模态框
		$("#showAddModalBtn").click(function () {
			$("#addModal").modal("show");
		});

		// 给新增模态框中的保存按钮绑定单击响应函数
		$("#saveRoleBtn").click(function () {
			// 获取用户在文本框中输入的角色名称
			// #addModal表示找到整个模态框
			// 空格表示在后代元素中继续查找
			// [name=roleName]表示匹配name属性等于roleMame的元素
			// $.trim：去前后空格
			var roleName = $.trim($("#addModal [name=roleName]").val());

			// 发送ajax请求
			$.ajax({
				url: "role/save.json",
				type: "post",
				data: {
					name: roleName,
				},
				dataType: "json",
				success: function (resp) {

					var result = resp.result;
					if (result == "SUCCESS") {
						console.log("成功方法接收");
						console.log(resp);
						// 重新加载分页数据
						window.pageNum = 999999;
						generatePage();

					}
					if (result == "FAILED") {
						layer.msg("操作失败",resp.message)
					}

				},
				error: function (resp) {
					layer.msg(resp.status+" "+resp.statusText);
				}
			});

			// 关闭模态框
			$('#addModal').modal('hide')

			// 清理模态框
			var roleName = $.trim($("#addModal [name=roleName]").val(""));

		});

		// 给页面上的“铅笔”按钮绑定单击响应函数，目的是打开模态框
		// 传统的事件绑定方式，只能在第一个页面有效，翻页后失效了。
		// $(".pencilBtn").click(function () {
		// 	alert("aaaa")
		// });

		// 使用jQuery对象的on()函数可以解决上面问题
		// 首先找到所有动态生成的元素所附着的静态元素
		// on()函数的第一个参数是事件类型
		// on()函数的第二个参数是找到真正要绑定事件的元素选择器
		// on()函数的第三个参数是事件的响应函数
		$("#rolePageBody").on("click",".pencilBtn",function () {
			// 打开模态框
			$("#editModal").modal("show");

			// 获取表格中当前行中的角色名称
			var roleName = $(this).parent().prev().text();

			// 获取当前角色id
			// 依据是：var pencilBtn = "<button id='"+roleId+"'/>这段代码中我们把roleId设置到id属性了
			// 为了让执行更新的按钮能够获取到roleId的值，把它放在全局变量上
			window.roleId = this.id;

			// 使用roleName的值设置模态框中的文本框
			$("#editModal [name=roleName]").val(roleName);
		});

		// 给更新模态框中的更新按钮绑定单击响应函数
		$("#updateRoleBtn").click(function () {

			// 1.从文本框中获取新的角色名称
			var roleName = $("#editModal [name=roleName]").val();
			
			// 2.发送ajax请求执行更新
			$.ajax({
				url: "role/update.json",
				type: "post",
				data: {
					id: window.roleId,
					name: roleName,
				},
				dataType: "json",

				success: function (resp) {

					var result = resp.result;
					if (result == "SUCCESS") {
						// 重新加载分页数据
						generatePage();

					}
					if (result == "FAILED") {
						layer.msg("操作失败",resp.message)
					}

				},
				error: function (resp) {
					layer.msg(resp.status+" "+resp.statusText);
				}
			});
			// 3.关闭模态框
			$("#editModal").modal("hide");
		});

		// 点击确定模态框中的确认删除按钮执行删除
		$("#removeRoleBtn").click(function () {
			// 从全局变量范围
			var requestBody = JSON.stringify(window.roleIdArray);
			$.ajax({
				url: "/role/remove/by/role/id/array.json",
				type: "post",
				data: requestBody,
				contentType: "application/json;charset=UTF-8",
				dataType: "json",
				success: function (resp) {

					var result = resp.result;
					if (result == "SUCCESS") {
						// 重新加载分页数据
						generatePage();

					}
					if (result == "FAILED") {
						layer.msg("操作失败",resp.message)
					}

				},
				error: function (resp) {
					layer.msg(resp.status+" "+resp.statusText);
				}
			});

			$("#summaryBox").prop("checked", false);

			// 关闭模态框
			$("#confirmModal").modal("hide");
		});
		// 给单条删除按钮绑定单击响应函数
		$("#rolePageBody").on("click",".removeBtn",function () {

			// 从当前按钮出发获取角色名称
			var roleName = $(this).parent().prev().text();

			// 创建role对象存入数组
			var roleArray = [{
				roleId: this.id,
				roleName: roleName
			}];

			// 调用专门的函数打开模态框
			showConfirmModal(roleArray);
		});
		
		// 给总的多选框按钮绑定单击响应函数
		$("#summaryBox").click(function () {

			// 获取当前多选框自身的状态
			var currentStatus = this.checked;

			// 用当前多选框的状态设置其他的多选框
			$(".itemBox").prop("checked", currentStatus);

		});

		// 全选、全不选的反向操作
		$("#rolePageBody").on("click",".itemBox",function () {
			// 获取当前已经选中的itemBox的数量
			var checkedBoxCount = $(".itemBox:checked").length;

			// 获取全不itemBox的数量
			var totalBoxCount = $(".itemBox").length;

			// 使用二者的比较结果设置总的checkbox
			$("#summaryBox").prop("checked", checkedBoxCount == totalBoxCount);
		});

		// 给批量删除的按钮绑定单击响应函数
		$("#batchRemoveBtn").click(function () {

			// 创建一个数组对象，用来存放后面获取到的角色对象
			var roleArray = [];

			// 遍历当前选中的多选框
			$(".itemBox:checked").each(function () {

				// 使用this引用当前遍历得到的多选框
				var roleId = this.id;

				// 通过DOM操作获取角色名称
				// parent：获取父元素。next:获取兄弟元素中的下一个元素
				var roleName = $(this).parent().next().text();

				roleArray.push({
					roleId: roleId,
					roleName: roleName
				});
			});

			if (roleArray.length == 0) {
				layer.msg("请至少选择一个执行删除！");
				return;
			};

			// 调用专门的函数打开模态框
			showConfirmModal(roleArray);

		});

		// 给分配权限按钮绑定单机响应函数
		$("#rolePageBody").on("click",".checkBtn",function () {

			$("#assignModal").modal("show");

		})

	});
</script>

<body>
	<%@ include file="/WEB-INF/include-nav.jsp" %>
	<div class="container-fluid">
		<div class="row">
			<%@ include file="/WEB-INF/include-sidebar.jsp" %>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
					</div>
					<div class="panel-body">
						<form class="form-inline" role="form" style="float:left;">
							<div class="form-group has-feedback">
								<div class="input-group">
									<div class="input-group-addon">查询条件</div>
									<input id="keywordInput" class="form-control has-success" type="text" placeholder="请输入查询条件">
								</div>
							</div>
							<button id="searchBtn" type="button" class="btn btn-warning">
								<i class="glyphicon glyphicon-search"></i> 查询
							</button>
						</form>
						<button type="button" id="batchRemoveBtn" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
						<button type="button" id="showAddModalBtn" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
						<%--<button type="button" id="showEditModalBtn" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 更新</button>--%>
						<br>
						<hr style="clear:both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
								<tr>
									<th width="30">ID</th>
									<th width="30"><input id="summaryBox" type="checkbox"></th>
									<th>名称</th>
									<th width="100">操作</th>
								</tr>
								</thead>
								<tbody id="rolePageBody">
								</tbody>
								<tfoot>
								<tr>
									<td colspan="6" align="center">
                                        <div id="Pagination" class="pagination"><!-- 这里显示分页 --></div>
									</td>
								</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@include file="/WEB-INF/modal-role-add.jsp" %>
	<%@include file="/WEB-INF/modal-role-edit.jsp" %>
	<%@include file="/WEB-INF/modal-role-confirm.jsp" %>
	<%@include file="/WEB-INF/modal-role-assign-auth.jsp" %>
</body>
</html>