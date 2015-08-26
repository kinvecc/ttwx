<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/view/common/inc/path.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta name="decorator" content="sys"/>
	<title>字典管理</title>
	<link href="<%=resourceUrl%>/bootstrap-table/bootstrap-table.min.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<ol class="breadcrumb">
		<li><a href="<%=domain %>/admin">后台管理</a></li>
		<li><a href="<%=domain %>/admin/sys">系统管理</a></li>
		<li class="active">字典管理</li>
	</ol>

	<div id="toolbar">
		<div class="form-inline" role="form">
			<fieldset>
				<div class="form-group">
					<div class="control-group">
						<label class="control-label">openid：</label>
						<input name="qry_openid" class="form-control" type="text" placeholder="用户发送的文字">
                        <span class="columns-right pull-right">
                            <button onclick="searchDatagrid();" type="button" class="btn">
								<i class="glyphicon glyphicon-search"></i>
								查询
							</button>
                            <button onclick="clearDatagrid();" type="button" class="btn">
								<i class="glyphicon glyphicon-transfer"></i>
								重置
							</button>
                        </span>
					</div>
				</div>
			</fieldset>
		</div>
	</div>
	<table id="data-table"></table>


	<div id="modal" style="display: none;">
		ssssssssssssssssssssssss
	</div>



<script src="<%=resourceUrl%>/bootstrap-table/bootstrap-table.min.js" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl%>/bootstrap-table/bootstrap-table-option.js" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl%>/bootstrap-table/locale/bootstrap-table-zh-CN.min.js" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl%>/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl %>/script/sys/dict.js?v=2015072601" type="text/javascript" charset="UTF-8"></script>
</body>
</html>