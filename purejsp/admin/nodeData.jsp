<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@ include file="../fn.jsp"%>


<%
	
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");

	response.setHeader("Pragma","no-cache");   
	response.setHeader("Cache-Control","no-cache");   
	response.setDateHeader("Expires", 0);   
	
	String id = request.getParameter("id");
	
	String sql = "select * from purejsp where id="+id;
	String[] row = query_row(sql);	
	
	if( row != null ) {
		final String[] fields = "id,pid,create_time,update_time,node_name,class,tag,type,flag,url,json_str,ext_str,int_val,float_val,str_val,remark,account,pwd,title,content,sort,valid".split(",");
		
		StringBuilder sb = new StringBuilder(128);
		int n = 0;
		for(String c : row ) {
			sb.append(fields[n++]).append('\t').append(c).append('\t');
		}
		out.println(sb.toString());
	}
	
%>
