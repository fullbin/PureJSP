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
		
	String account = request.getParameter("account");
	
	if( account != null ) {
		request.getSession().setAttribute("Account", account);
		//response.sendRedirect("admin.jsp");
		response.sendRedirect("purejsp_spirit.jsp");
		return;
	} else {
		//logout
		request.getSession().removeAttribute("Account");
	}
	

	Map<String,String> lang = getCfgLang();
	
	String s_title = lang.get("login_title");
	String s_usr = lang.get("login_account");
	String s_pwd = lang.get("login_pwd");
	String s_btn = lang.get("login_btn");
	
	
%>
<!DOCTYPE html> 
<html>
<head>
	<title>PureJsp</title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
	<meta name="apple-mobile-web-app-capable" content="yes">

	<link rel="stylesheet" type="text/css" href="../layui/css/layui.css" />


</head>

<body>

<div class="layui-container">
	<blockquote class="layui-elem-quote">
		<a class="layui-btn layui-btn-primary" href="../index.jsp" ><%=lang.get("login_btn_index")%></a>&nbsp;
		<a class="layui-btn" href="../oa/oa.jsp" target=_blank><%=lang.get("login_btn_oa")%></a>&nbsp;
		<a class="layui-btn layui-btn-normal" target=_blank href="../cms/cms.jsp" ><%=lang.get("login_btn_cms")%></a>&nbsp;
	</blockquote>

	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
	  <legend><%=s_title %></legend>
	</fieldset>

	<form class="layui-form layui-form-pane" action="?" method="post" >
	  <div class="layui-form-item">
	    <label class="layui-form-label"><%=s_usr %></label>
	    <div class="layui-input-block">
	      <input type="text" name="account" lay-verify="account" autocomplete="off" placeholder="<%=s_usr %>" class="layui-input">
	    </div>
	  </div>
	  <div class="layui-form-item">
	    <label class="layui-form-label"><%=s_pwd %></label>
	    <div class="layui-input-block">
	      <input type="pwd" name="username" lay-verify="required" placeholder="<%=s_pwd %>" autocomplete="off" class="layui-input">
	    </div>
	  </div>
	  
	<div class="layui-form-item" style="text-align: center">
		<button class="layui-btn" lay-submit="" lay-filter="demo2"><%=s_btn %></button>
	</div>
	
  	  
	</form>


</div>

</body>

</html>

