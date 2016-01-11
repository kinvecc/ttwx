package com.fengjx.commons.utils;

import org.apache.commons.lang3.StringUtils;

import com.fengjx.commons.config.PropertiesHolder;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

/**
 * 自定义GetPropertiesVal返回properties内容
 *
 * @author donglg 2013-03-20
 * @createDate 2013-3-15 上午08:20:00
 */
public final class GetPropertiesVal {

    //该对象不支持实例化
    private GetPropertiesVal() {

    }

    static {
    }

    public static String getLabel(String key) {
    	String res = "";
        try {
        	Properties properties= PropertiesHolder.INSTANCE.getAppConfig();
        	res=new String(properties.getProperty(key).getBytes("ISO-8859-1"),"UTF-8");
        	//res = new String(statusRes.getString(key).getBytes("ISO-8859-1"),"UTF-8");
		} catch (UnsupportedEncodingException e) {
            // 异常代表无配置，这里什么也不做
		}
        return res;
    }

    public static String getProTheme(String themeKey) {
        return StringUtils.isBlank(getLabel(themeKey)) ? "default" : getLabel(themeKey);
    }

    public static void main(String[] args) {
        System.out.println(GetPropertiesVal.getProTheme("domain.page"));
    }

}