<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="/WEB-INF/view/common/inc/path.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>菜单管理</title>
    <link href="<%=resourceUrl%>/css/menu.css?v=2014111501" rel="stylesheet" type="text/css"/>
    <link href="<%=resourceUrl%>/css/material.css?v=2014030901" rel="stylesheet" type="text/css"/>
    <link href="<%=resourceUrl%>/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
    <jsp:include page="/WEB-INF/view/common/inc/admin.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/inc/admin-header.jsp"></jsp:include>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/view/wechat/admin/inc_menu.jsp">
            <jsp:param name="index" value="2"/>
        </jsp:include>
        <div id="context" class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <ol class="breadcrumb">
                <li><a href="<%=domain %>/admin">后台管理</a></li>
                <li><a href="<%=domain %>/admin/wechat">平台管理</a></li>
                <li class="active">菜单管理</li>
            </ol>
            <div class="container-fluid" style="margin-top: -18px;" >
                <div class="row" >
                    <h4>可创建最多3个一级菜单，每个一级菜单下可创建最多5个二级菜单。编辑中的菜的那不会马上被用户看到，请放心调试。</h4>
                </div>
                <div class="row" style="border:1px solid #ddd;min-height: 530px;">
                    <div class="col-md-3 nopadding" style="border-right:1px solid #ddd;min-height: 530px;">
                        <div style="text-align: left;">
                            <button type="button" onclick="append(1)" class="btn btn-default btn-sm sorted" title="添加">
                                <i class="glyphicon glyphicon-plus"></i>
                            </button>
                            <button type="button" onclick="updatedMenu()" class="btn btn-default btn-sm sorted" title="修改">
                                <i class="glyphicon glyphicon-edit"></i>
                            </button>
                            <button type="button" onclick="removeMenu()" class="btn btn-default btn-sm sorted" title="删除">
                                <i class="glyphicon glyphicon-trash"></i>
                            </button>
                            <button type="button" onclick="release()" class="btn btn-default btn-sm sorted" title="发布">
                                <i class="glyphicon glyphicon-phone"></i>
                            </button>
                            <button type="button" onclick="sort();" class="btn btn-default btn-sm sorted" title="排序">
                                <i class="glyphicon glyphicon-align-justify"></i>
                            </button>
                            <button type="button" onclick="saveSort();" class="btn btn-success btn-sm hide sort" title="完成排序">
                                完成
                            </button>
                            <button type="button" onclick="cancelSort();" class="btn btn-default btn-sm hide sort" title="完成排序">
                                取消
                            </button>
                        </div>
                        <div class="dd" id="nestable">
                            <ol id="menu_tree" class="dd-list">
                            </ol>
                        </div>

                    </div>
                    <div class="col-md-9">
                        <div id="action_setting">
                            <div class="action_content default jsMain" id="action_none" style="display: block;">
                                <p class="action_tips">你可以先添加一个菜单，然后开始为其设置响应动作</p>
                            </div>
                            <div class="action_content init jsMain" style="display: none;" id="action_index">
                                <p class="action_tips">请选择订阅者点击菜单后，公众号做出的相应动作</p>
                                <a href="javascript:void(0);" id="sendMsg" onclick="showActionContent('action_edit');">
                                    <i class="icon_menu_action send"></i>
                                    <strong>发送信息</strong></a>
                                <a href="javascript:void(0);" id="goPage" onclick="showActionContent('action_url');">
                                    <i class="icon_menu_action url"></i>
                                    <strong>跳转到页面</strong>
                                </a>
                            </div>

                            <div class="action_content send jsMain" id="action_edit"  style="display: none;">
                                <!-- 菜单点击消息动作 -->
                                <jsp:include page="/WEB-INF/view/wechat/admin/inc_action.jsp">
                                    <jsp:param name="req_type" value="event"/>
                                    <jsp:param name="event_type" value="CLICK"/>
                                </jsp:include>
                            </div>

                            <div class="action_content url jsMain" id="action_url" style="display: none;">
                                <%--<p class="action_tips">订阅者点击该子菜单会跳到以下链接</p>--%>
                                <p class="action_tips">订阅者点击该子菜单会跳转到以下链接</p>
                                <div class="frm_control_group">
                                    <table>
                                        <tr>
                                            <td>
                                            <span class="">
                                                链接地址：
                                                <jsp:include page="/admin/wechat/ext/selecter">
                                                    <jsp:param name="showAll" value="1"/>
                                                    <jsp:param name="id" value="busiapp_url"/>
                                                    <jsp:param name="name" value="busiapp_url"/>
                                                    <jsp:param name="app_type" value="web"/>
                                                    <jsp:param name="msg_type" value=""/>
                                                    <jsp:param name="event_type" value=""/>
                                                </jsp:include>
                                            </span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="tool_bar">
                                    <span class="btn btn_input btn_default">
                                        <button onclick="showActionContent('action_index')">返回</button>
                                     </span>
                                     <span class="btn btn_input btn_primary">
                                        <button onclick="submitMsgActionForm('url');">保存</button>
                                     </span>
                                </div>
                            </div>


                            <div class="action_content sended jsMain" id="view" style="display: none;">
                                <div style="float: left; width: 100%">
                                    <div class="action_tips" style="float: left;">
                                        订阅者点击该子菜单会受到以下信息
                                    </div>
                                    <div style="float:right;">
                                        <button onclick="updateMsgView();" type="button" class="btn btn-success">修&nbsp;&nbsp;改</button>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="msg_wrp" id="viewDiv">
                                    <!-- js加载预览效果 -->
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

<script src="<%=resourceUrl%>/js/jquery.json-2.4.min.js" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl%>/js/jquery.xml2json.js" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl%>/js/jquery.form.js" type="text/javascript"></script>
<script src="<%=resourceUrl%>/jquery-ui/jquery-ui.min.js" type="text/javascript"></script>
<script src="<%=resourceUrl%>/script/wechat/admin/material_util.js?v=2014091101" type="text/javascript" charset="UTF-8"></script>
<script src="<%=resourceUrl %>/script/wechat/admin/menu.js?v=2015061701" type="text/javascript" charset="UTF-8"></script>
</body>
</html>