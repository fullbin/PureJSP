<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%@ include file="fn.jsp"%>

<%

	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");

	response.setHeader("Pragma","no-cache");   
	response.setHeader("Cache-Control","no-cache");   
	response.setDateHeader("Expires", 0);   
	response.setHeader("Cache-Control", "no-store"); 

	Map<String,String> lang = getCfgLang();
	String desc = lang.get("index_desc");
%>

<!DOCTYPE html> 
<html>
<head>
	<title>PureJsp</title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<link rel="stylesheet" type="text/css" href="layui/layui.all.js" />
	<link rel="stylesheet" type="text/css" href="layui/css/layui.css" />

</head>

<body style='margin:auto'>

<br>
<br>

<div class="layui-container" style="font-size:16px">
	<%=desc %>
	
	<br>
	
	<a class="layui-btn layui-btn-primary"  href="admin/login.jsp" >Login</a>&nbsp;	
	<a class="layui-btn" href="oa/oa.jsp" target=_blank ><%=lang.get("login_btn_oa")%></a>&nbsp;
	<a class="layui-btn layui-btn-normal" target=_blank href="cms/cms.jsp" ><%=lang.get("login_btn_cms")%></a>&nbsp;
	
	
</div>

<script>
if( top.location.href.indexOf('index.jsp') == -1 ) {
	top.location.href = 'index.jsp';
}
</script>

</body>

</html>

