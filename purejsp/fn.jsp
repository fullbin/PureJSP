<%--
/**
 * @Name PuseJsp 
 * @Author sinmax32
 * @Project https://github.com/sinmax32/purejsp/
 */
--%>
 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.*"%>
<%@page import="java.security.MessageDigest"%>

<%!
	public String getLv3menu(List<String[]> list, String lv, int pid) {
		StringBuilder sb = new StringBuilder();
		for(String[] row : list) {
			if( lv.equals(row[3]) && toInt(row[1]) == pid ) {
				sb.append("<dd><a href='#'>");
				sb.append(row[2]);
				sb.append("</a></dd>");
			}
		}
		if( sb.length() > 0 ) {
			return "<dl class='layui-nav-child'>" + sb.append("</dl>").toString();
		}
		return "";
	}
			
	public int toInt(String s) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			//System.err.println(e.toString());
		}
		return -999;
	}

	public String getDateStr(java.util.Date d) {
		if( d == null ) {
			d = Calendar.getInstance().getTime();
		}
		
		return new StringBuilder(12)
				.append( (d.getYear()+1900) ).append('-')
				.append( (d.getMonth()+1) )
				.append('-').append(d.getDate())
				.toString();
	}

	public String returnStr(int flag, String hint, String addrHref) {
		StringBuilder sb = new StringBuilder();
		sb.append("<title>Pure Jsp</title>");
		sb.append("<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1'>");
		sb.append("<center>");
		sb.append("<br>");
		sb.append(hint);
		sb.append("<br><br>");
	
		if (flag == 1) {
			sb.append("<a href='javascript:history.back();' style='border:1px solid blue;color:blue;text-decoration:none;padding:2px 8px;'>OK</a>");
			
		} else if (flag == 2) {
			sb.append("<a href='javascript:window.close();' style='border:1px solid blue;color:blue;text-decoration:none;padding:2px 8px;'>OK</a>");
			
		} else if (flag == 3) {
			sb.append("<a href='"+addrHref+"' style='border:1px solid blue;color:blue;text-decoration:none;padding:2px 8px;'>OK</a>");
			
		}
	
		sb.append("</center>");
		return sb.toString();
	}

	public Map<String,String> getCfgLang() {
		if( this.getServletContext().getAttribute("CFG_LANG") != null ) {
			//reload for debug 
			//return (Map)this.getServletContext().getAttribute("CFG_LANG");
		}
		
		FileInputStream fis = null;
		
		try {
			String lang = Locale.getDefault().toString();
			//lang = "en";
			
			String config = this.getServletContext().getRealPath("/WEB-INF/config/"+lang+"/lang.txt");
			
			File file = new File(config);
			if( !file.exists() ) {
				config = this.getServletContext().getRealPath("/WEB-INF/config/en/lang.txt");
			}			
			
			fis = new FileInputStream(config);
			Properties p = new Properties();
			p.load(new InputStreamReader(fis, "utf-8"));
			
			Map<String,String> map = new HashMap<String,String>(p.size());
			for (Map.Entry<Object, Object> entry : p.entrySet()) {
				map.put(entry.getKey().toString(), entry.getValue().toString());
			}
			
			this.getServletContext().setAttribute("CFG_LANG", map);
			
			return map;
		} catch ( Exception e ) {
			e.printStackTrace();
			
		} finally {
			if( fis != null ) {
				try {
					fis.close();	
				} catch (Exception e2 ) {
					e2.printStackTrace();
				}				
			}				
		}
		return null;
	}

	public Properties getCfgDb() {
		if( this.getServletContext().getAttribute("CFG_DB") != null ) {
			return (Properties)this.getServletContext().getAttribute("CFG_DB");
		}
		
		FileInputStream fis = null;
		
		try {
			String config = this.getServletContext().getRealPath("/WEB-INF/config/db_config.txt");
			fis = new FileInputStream(config);
			Properties p = new Properties();
			p.load(fis);
			
			this.getServletContext().setAttribute("CFG_DB", p);
			
			return p;
		} catch ( Exception e ) {
			e.printStackTrace();
			
		} finally {
			if( fis != null ) {
				try {
					fis.close();	
				} catch (Exception e2 ) {
					e2.printStackTrace();
				}				
			}				
		}
		return null;
	}
	
	public Connection getCon() {
		Properties p = getCfgDb();
		if( p == null )
			return null;
		
		String DbUrl = p.getProperty("db_url");
		String DbUsr = p.getProperty("db_usr");
		String DbPwd = p.getProperty("db_pwd");
		String driver = p.getProperty("db_driver");
	
		try {
			Class.forName(driver);
			return DriverManager.getConnection(DbUrl, DbUsr, DbPwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int execUpdate(String sql) {
		Connection con = null;
		Statement stm = null;
	
		try {
			con = getCon();
			stm = con.createStatement();
			stm.setQueryTimeout(20); // set timeout to 20 sec.
			return stm.executeUpdate(sql);
	
		} catch (Exception e) {
			e.printStackTrace();
	
		} finally {
			try {
				if (stm != null)
					stm.close();
				if (con != null)
					con.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1;
	}
	
	public List<String[]> query(String sql) {
		Connection con = getCon();
		if (con == null)
			return null;

		Statement stm = null;
		try {
			stm = con.createStatement();
			ResultSet rs = stm.executeQuery(sql);

			List<String[]> list = new ArrayList<String[]>();

			int colcnt = rs.getMetaData().getColumnCount();
			while (rs.next()) {
				String[] row = new String[colcnt];

				for (int i = 0; i < colcnt; i++) {
					row[i] = rs.getString(i + 1);
					if( row[i] == null ) {
						row[i] = "";
					}
				}
				list.add(row);
			}
			rs.close();
			return list;

		} catch (Exception e) {
			e.printStackTrace();

		} finally {
			try {
				if (stm != null)
					stm.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return null;

	}	
	
	public boolean query_exist(String sql) {
		List<String[]> list = query(sql);
		if( list != null ) {
			return !list.isEmpty();
		}
		return false;
	}
	
	public String query_one(String sql) {
		String[] row = query_row(sql);
		if( row != null && row.length > 0  ) {
			return row[0];
		}
		return "";
	}
	
	public String[] query_row(String sql) {
		List<String[]> list = query(sql);
		if( list != null && !list.isEmpty() ) {
			return list.get(0);
		}
		return null;
		
	}
    

	
   
%>