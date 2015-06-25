/**
 * 关键字回复管理
 */
var msgActionForm;

$(function () {

    if (actionId) {
        editMsgAction(actionId);
    }

    msgActionForm = $("#msgActionForm").submit(function () {
        $(this).ajaxSubmit({
            url: domain + "/admin/wechat/action/save",
            dataType: 'json',
            beforeSubmit: function () {
                app.loadingModal("数据提交中....");
            },
            success: function (res) {
                app.closeDialog();
                if (res && '1' == res.code) {
                    app.alertModal("保存成功！", {
                        ok: function () {
                            window.location.href = domain + "/admin/wechat/action/keyword";
                        }
                    });
                } else {
                    app.alertModal(res.msg ? res.msg : "保存失败！", {
                        ok: function () {
                            app.closeDialog();
                        }
                    });
                }
            }
        });
        return false;
    });

});

/**
 * 提交响应规则設置
 * @param {} respType 消息响应类型
 */
function submitMsgActionForm(respType) {
    var keyWord = $("#msgKeyWord").val();
    if (!keyWord || '' == $.trim(keyWord)) {
        app.alertModal("请输入关键字");
        return false;
    }
    $("#materiaMsgType").val(respType);		//响应消息类型
    $("#msgReqType").val(req_type);
    if (respType === 'text') {
        $("#msgActionType").val("material");
        var txtContent = $.trim($("#replyText").val());
        if (!txtContent || "" == txtContent) {
            app.alertModal("请输入要回复的内容");
            return false;
        }
        $("#txtContent").val(txtContent);
    }
    if (respType === 'news') {
        $("#msgActionType").val("material");
        var newsId = $("#newsId").val();
        if (!newsId || newsId == '') {
            app.alert("请选择素材");
            return false;
        }
        $("#msgMaterialId").val(newsId);
    }
    if (respType === 'api') {
        $("#msgActionType").val("api");
        var app_id = $.trim($("#busiapp_id").val());
        if (!app_id) {
            app.alertModal("请选择扩展应用");
            return false;
        }
        $("#msgExtAppId").val(app_id);
    }

    msgActionForm.submit();
}

function editMsgAction(id) {
    $.ajax({
        url: domain + "/admin/wechat/action/load",
        type: 'post',
        data: {id: id},
        dataType: "json",
        cache: false,
        async: true,
        success: function (row) {
            if (row) {
                $("#msgActionId").val(row.id);
                $("#editType").val("edit");
                $("#msgKeyWord").val(row.key_word);
                var tabIndex;
                if (row.action_type == 'material') {//数据源从素材读取
                    var json = $.xml2json(row.xml_data);
                    var msgType = json.MsgType;
                    if (msgType == "text") {		//文本消息
                        tabIndex = 0;
                        $("#replyText").val(json.Content);
                    } else if (msgType == "news") {	//图文消息
                        tabIndex = 4;
                    }

                } else if (row.action_type == 'api') {
                    tabIndex = 5;
                    if (row.app_id) {
                        $("#busiapp_id").val(row.app_id)
                    }
                }
                $('#edit_tabs a:eq(' + tabIndex + ')').tab('show');
                $("#msgKeyWord").attr("readonly", "readonly");
                $("ol > li:last").text("修改规则");
            }
        }
    });
}