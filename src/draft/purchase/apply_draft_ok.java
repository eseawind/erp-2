package draft.purchase;
 
 
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import javax.servlet.*;

import validata.ValidataNumber;

import java.io.* ;
import include.nseer_db.*;
import include.nseer_cookie.exchange;
import include.nseer_cookie.counter;

public class apply_draft_ok extends HttpServlet{

public synchronized void service(HttpServletRequest request,HttpServletResponse response) throws IOException,ServletException{
HttpSession dbSession=request.getSession();
JspFactory _jspxFactory=JspFactory.getDefaultFactory();
PageContext pageContext = _jspxFactory.getPageContext(this,request,response,"",true,8192,true);
ServletContext dbApplication=dbSession.getServletContext();


ServletContext application;
HttpSession session=request.getSession();
counter count=new counter(dbApplication);
ValidataNumber validata = new ValidataNumber();
try{

nseer_db_backup1 purchase_db = new nseer_db_backup1(dbApplication);
if(purchase_db.conn((String)dbSession.getAttribute("unit_db_name"))){

String apply_ID=request.getParameter("apply_ID");
String config_ID=request.getParameter("config_ID");
String designer=request.getParameter("designer") ;
String register=request.getParameter("register") ;
String register_time=request.getParameter("register_time") ;
String register_id=request.getParameter("register_id") ;
String check_time=request.getParameter("check_time") ;
String bodyb = new String(request.getParameter("remark").getBytes("UTF-8"),"UTF-8");
String remark=exchange.toHtml(bodyb);
String[] product_id=request.getParameterValues("product_ID");
String[] amount=request.getParameterValues("amount");
int n=0;
for(int i=0;i<product_id.length;i++){
	if(!validata.validata(amount[i])){
		n++;
	}
}
if(n==0){
	String sql8 = "select * from purchase_apply where apply_ID='"+apply_ID+"' and (check_tag='5' or check_tag='9')" ;
	ResultSet rs8 = purchase_db.executeQuery(sql8) ;
	if(rs8.next()){
	for(int i=0;i<product_id.length;i++){
	if(!amount[i].equals("")){	
	String sql = "update purchase_apply set amount='"+amount[i]+"',designer='"+designer+"',register='"+register+"',register_time='"+register_time+"',remark='"+remark+"',register='"+register+"',register_time='"+register_time+"' where apply_ID='"+apply_ID+"' and product_id='"+product_id[i]+"'" ;
	purchase_db.executeUpdate(sql) ;
	}else{
		String sql = "delete from purchase_apply where apply_ID='"+apply_ID+"' and product_id='"+product_id[i]+"'" ;
		purchase_db.executeUpdate(sql) ;
	}
	}
response.sendRedirect("draft/purchase/apply_ok.jsp?finished_tag=0");
	}else{
response.sendRedirect("draft/purchase/apply_ok.jsp?finished_tag=1");
}
}else{
	response.sendRedirect("draft/purchase/apply_ok.jsp?finished_tag=6");
	}

	purchase_db.commit();
	purchase_db.close();

}else{
	response.sendRedirect("error_conn.htm");
}

}
catch (Exception ex){
ex.printStackTrace();
}
}
} 