
package com.fengjx.modules.sys.model;

import com.fengjx.commons.plugin.cache.IDataLoader;
import com.fengjx.commons.plugin.cache.ehcache.EhCacheUtil;
import com.fengjx.commons.plugin.db.Mapper;
import com.fengjx.commons.plugin.db.Model;
import com.fengjx.commons.plugin.db.Record;
import com.fengjx.commons.plugin.db.page.AdapterPage;
import com.fengjx.commons.plugin.freemarker.FreemarkerUtil;
import com.fengjx.commons.utils.JsonUtil;
import com.fengjx.commons.utils.StrUtil;
import com.fengjx.modules.common.constants.AppConfig;
import com.fengjx.modules.common.constants.FtlFilenameConstants;
import com.google.common.collect.Maps;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Created by FengJianxin on 2015/8/22.
 * @Email xd-fjx@qq.com
 */
@Mapper(table = "sys_dict")
@Component
public class Dict extends Model {

    public static final String DICT_JSON_MAP = "dictJsonMap";

    private static final String ORDER_BY = " order by in_time desc, order_no desc";

    /**
     * 根据字典值获得字典名称
     *
     * @param value
     * @param group
     * @return
     */
    public String getDictLabel(String value, String group) {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("dict_value", value);
        attrs.put("group_code", group);
        Record record = findOne(attrs);
        if(record.isEmpty()){
            return "";
        }
        return StringUtils.defaultIfEmpty(record.getStr("dict_name"), "");
    }

    /**
     * 根据指点标签和分组获得字典值
     *
     * @param label
     * @param group
     * @return
     */
    public String getDictValue(String label, String group) {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("dict_name", label);
        attrs.put("group_code", group);
        return findOne(attrs).getStr("dict_name");
    }

    /**
     * 根据字典分组获得字典列表
     *
     * @param group
     * @return
     */
    public List<Map<String, Object>> findDictList(String group) {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("group_code", group);
        return findList(attrs, ORDER_BY);
    }

    /**
     * 分页查询
     *
     * @param record 查询参数
     * @return
     */
    public AdapterPage page(Record record) {
        StringBuilder sql = new StringBuilder(getSelectSql("a"));
        sql.append(" where 1 = 1");
        List<Object> qryParams = new ArrayList<>();
        if (StringUtils.isNoneBlank(record.getStr("group_code"))) {
            sql.append(" and group_code like CONCAT('%',?,'%')");
            qryParams.add(record.get("group_code"));
        }
        if (StringUtils.isNoneBlank(record.getStr("dict_desc"))) {
            sql.append(" and dict_desc like CONCAT('%',?,'%')");
            qryParams.add(record.get("dict_desc"));
        }
        if (null != record.get("is_valid")) {
            sql.append(" and is_valid = ?");
            qryParams.add(record.get("is_valid"));
        }
        sql.append(ORDER_BY);
        return paginate(sql.toString(), qryParams.toArray()).convert();
    }

    public String jsTemplate() {
        return EhCacheUtil.get(AppConfig.EhcacheName.DICT_CACHE, DICT_JSON_MAP,
                new IDataLoader<String>() {
                    @Override
                    public String load() {
                        StringBuilder groupSql = new StringBuilder(
                                "select distinct(group_code) group_code from ");
                        groupSql.append(getTableName());
                        List<Map<String, Object>> groupList = findList(groupSql.toString());
                        if (CollectionUtils.isEmpty(groupList)) {
                            return "{}";
                        }
                        Map<String, Object> res = Maps.newHashMap();
                        for (Map<String, Object> group : groupList) {
                            String groupCode = (String) group.get("group_code");
                            List<Map<String, Object>> dataList = findList(createSql(), groupCode);
                            res.put(groupCode, dataList);
                        }
                        Map<String, String> attr = Maps.newHashMap();
                        attr.put("data", StrUtil.replaceBlank(JsonUtil.toJson(res)));
                        return FreemarkerUtil.process(attr, FtlFilenameConstants.DICT_JS);
                    }
                });
    }

    private String createSql() {
        StringBuilder sql = new StringBuilder(getSelectSql());
        sql.append(" where group_code = ? ").append(" order by order_no , in_time desc");
        return sql.toString();
    }

}
