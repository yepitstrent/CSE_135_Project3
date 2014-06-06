<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%
ArrayList<Integer> p_list=new ArrayList<Integer>();//product ID, 10
ArrayList<Integer> u_list=new ArrayList<Integer>();//customer ID,20
ArrayList<Integer> u_total_list=new ArrayList<Integer>();//totals by users id, 20
ArrayList<Integer> p_total_list=new ArrayList<Integer>();//totals by products id, 10
ArrayList<String> p_name_list=new ArrayList<String>();//product ID, 10
ArrayList<String> u_name_list=new ArrayList<String>();//customer ID,20
HashMap<Integer, Integer> product_ID_amount	=	new HashMap<Integer, Integer>();
HashMap<Integer, Integer> customer_ID_amount=	new HashMap<Integer, Integer>();
%>
<%
	String  state=null, category=null;
	try { 
			state     =	request.getParameter("state"); 
			category  =	request.getParameter("category"); 
			//age       =	request.getParameter("age"); 			
	}
	catch(Exception e) 
	{ 
       state=null; category=null;
	}
	String  pos_row_str=null, pos_col_str=null;
	int pos_row=0, pos_col=0;
	try { 
			pos_row_str     =	request.getParameter("pos_row"); 
			pos_row=Integer.parseInt(pos_row_str);		
			pos_col_str     =	request.getParameter("pos_col"); 
			pos_col=Integer.parseInt(pos_col_str);		
	}
	catch(Exception e) 
	{ 
       pos_row_str=null; pos_row=0;
       pos_col_str=null; pos_col=0;

	}
%>
<%
Connection	conn=null;
Statement 	stmt,stmt2;
ResultSet 	rs=null;
String  	SQL_1=null,SQL_2=null,SQL_3=null,SQL_ut=null, SQL_pt=null, SQL_row=null, SQL_col=null;
String  	SQL_amount_row=null,SQL_amount_col=null,SQL_amount_cell=null;
int 		p_id=0, p_total, u_id=0;
String		p_name=null,u_name=null;
int 		p_amount_price=0,u_amount_price=0, u_total=0;

int show_num_row=20, show_num_col=10;
	
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost:5432/test";
	String user="t-dogg3030";
	String password="password";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	stmt2 =conn.createStatement();
	
	
	if(("All").equals(state) && ("0").equals(category))//0,0
	{
		SQL_1 = "select * from pc_Users order by use_amt desc limit 20";
		SQL_2 = "select * from pc_Prod order by prod_amt desc limit 10";
		SQL_3 = "select * from pc_cust00 order by total desc, prod_total desc";
	}
	
	if(("All").equals(state) && !("0").equals(category))//0,1
	{
		SQL_1 = "SELECT * FROM pc_UseCatAmt desc limit 20";
		SQL_2 = "SELECT * FROM pc_ProdCatAmt desc limit 10";
		SQL_3 = "SELECT * FROM pc_cust01 order by total desc, prod_total desc";
		//SQL_1="select id,name from users order by name asc offset "+pos_row+" limit "+show_num_row;
		//SQL_2="select id,name from products where cid="+category+" order by name asc offset "+pos_col+" limit "+show_num_col;
		//SQL_ut="insert into u_t (id, name) "+SQL_1;
		//SQL_pt="insert into p_t (id, name) "+SQL_2;
		//SQL_row="select count(*) from users";
		//SQL_col="select count(*) from products where cid="+category+"";
	    //SQL_amount_row="select s.uid, sum(s.quantity*s.price) from  u_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by s.uid;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from p_t p, sales s where s.pid=p.id  group by s.pid;";
	}
	
	if(!("All").equals(state) && ("0").equals(category) )//1,0
	{
		SQL_1 = "SELECT * FROM pc_UseStAmt desc limit 20";
		SQL_2 = "SELECT * FROM pc_ProdStAmt desc limit 10";
		SQL_3 = "SELECT * FROM pc_cust10 order by total desc, prod_total desc";
		//SQL_1="select id,name from users where state='"+state+"' order by name asc offset "+pos_row+" limit "+show_num_row;
		//SQL_2="select id,name from products order by name asc offset "+pos_col+" limit "+show_num_col;
		//SQL_ut="insert into u_t (id, name) "+SQL_1;
		//SQL_pt="insert into p_t (id, name) "+SQL_2;
		//SQL_row="select count(*) from users where state='"+state+"' ";
		//SQL_col="select count(*) from products";
		//SQL_amount_row="select s.uid, sum(s.quantity*s.price) from  u_t u, sales s  where s.uid=u.id group by s.uid;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from p_t p, sales s, users u where s.pid=p.id  and s.uid=u.id and u.state='"+state+"'  group by s.pid;";
	}
	
	if(!("All").equals(state) && !("0").equals(category) )//1,1
	{
		SQL_1 = "SELECT * FROM pc_UseStCatAmt desc limit 20";
		SQL_2 = "SELECT * FROM pc_ProdStCatAmt desc limit 10";
		SQL_3 = "SELECT * FROM pc_cust11 order by total desc, prod_total desc";
		//SQL_1="select id,name from users where state='"+state+"' order by name asc offset "+pos_row+" limit "+show_num_row;
		//SQL_2="select id,name from products where cid="+category+" order by name asc offset "+pos_col+" limit "+show_num_col;
		//SQL_ut="insert into u_t (id, name) "+SQL_1;
		//SQL_pt="insert into p_t (id, name) "+SQL_2;
		//SQL_row="select count(*) from users where state='"+state+"' ";
		//SQL_col="select count(*) from products where cid="+category+"";
		//SQL_amount_row="select s.uid, sum(s.quantity*s.price) from  u_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by s.uid;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from p_t p, sales s, users u where s.pid=p.id  and s.uid=u.id and u.state='"+state+"'  group by s.pid;";

	}
	
	

	//customer names and totals for the left column
	rs=stmt.executeQuery(SQL_1);
	while(rs.next())
	{
		//u_id=rs.getInt(1);
		u_id = Integer.parseInt(rs.getString("uid"));
		u_name=rs.getString("name");
		u_total=Integer.parseInt(rs.getString("use_amt"));
		u_list.add(u_id);//user id list
		u_name_list.add(u_name);//users name list
		u_total_list.add(u_total);
		customer_ID_amount.put(u_id, u_total);
		
	}
//	out.println(SQL_1+"<br>"+SQL_2+"<br>"+SQL_pt+"<BR>"+SQL_ut+"<br>"+SQL_row+"<BR>"+SQL_col+"<br>");
	//product name
	rs=stmt.executeQuery(SQL_2);
	while(rs.next())
	{
		p_id=rs.getInt(1);   
		p_name=rs.getString(2);
		p_total=rs.getInt(3);
		p_list.add(p_id);
	    p_name_list.add(p_name);
	    p_total_list.add(p_total);
		product_ID_amount.put(p_id,p_total);
		
	}
	
	
	//temporary table
	//conn.setAutoCommit(false);
	//stmt2.execute("CREATE TEMP TABLE p_t (id int, name text)ON COMMIT DELETE ROWS;");
	//stmt2.execute("CREATE TEMP TABLE u_t (id int, name text)ON COMMIT DELETE ROWS;");
	//customer tempory table
	//stmt2.execute(SQL_ut);
	//product tempory table
	//stmt2.execute(SQL_pt);

	
	//count the total tuples in  usres and products after filterings
	/*int maxUser=0;
	rs=stmt.executeQuery(SQL_row);//if only customer can buy products, then limit to only customers
	if(rs.next())
	{
		maxUser=rs.getInt(1);
	}
	int maxProduct=0;
	rs=stmt.executeQuery(SQL_col);//if only customer can buy products, then limit to only customers
	if(rs.next())
	{
		maxProduct=rs.getInt(1);
	}*/
	
%>	
<%	

	
	
	
//	out.println(SQL_amount_row+"<br>"+SQL_amount_col+"<br>"+SQL_amount_cell+"<BR>");
	
	/*rs=stmt.executeQuery(SQL_amount_row);
	while(rs.next())
	{
		u_id=rs.getInt(1);
		u_amount_price=rs.getInt(2);
		if(customer_ID_amount.get(u_id)!=null)
		{
			customer_ID_amount.put(u_id,u_amount_price);
		}
    }*/
	/*rs=stmt.executeQuery(SQL_amount_col);
	while(rs.next())
	{
		p_id=rs.getInt(1);   
		p_amount_price=rs.getInt(2);
		if(product_ID_amount.get(p_id)!=null)
		{
			product_ID_amount.put(p_id,p_amount_price);
		}
	}*/

   
    /*int i=0,j=0;
	HashMap<String, String> pos_idPair=new HashMap<String, String>();
	HashMap<String, Integer> idPair_amount=new HashMap<String, Integer>();	
	int amount=0;*/
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#FF00FF">CUSTOMER</font></strong></td></tr></table></td>
			<td width="88%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
    int i = 0;
    int j = 0;
	int amount_show=0;
	for(i=0;i<p_list.size();i++)
	{
		p_id			=   p_list.get(i);
		p_name			=	p_name_list.get(i);
		p_total         =   p_total_list.get(i);
		out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#0000ff'>$"+p_total+"</font>)</strong></td>");
		
	}
%>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<table align="center" width="100%" border="1">
<tr><td width="12%">
	<table align="center" width="100%" border="1">
	<%	
	    
		for(i=0;i<u_list.size();i++)
		{
			u_id			=	u_list.get(i);
			u_name			=	u_name_list.get(i);
			u_total         =   u_total_list.get(i);
			out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#0000ff'>$"+u_total+"</font>)</strong></td></tr>");
			
			
			
			/*if(customer_ID_amount.get(u_id)!=null)
			{
				amount_show=(Integer)customer_ID_amount.get(u_id);
				if(amount_show!=0)
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td></tr>");
				}
				else
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
				}	
			}
			else
			{
				out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
			}
			for(j=0;j<p_list.size();j++)
			{
				p_id	=   p_list.get(j);
				pos_idPair.put(i+"_"+j, u_id+"_"+p_id);
				idPair_amount.put(u_id+"_"+p_id,0);
			}*/
		}
	%>
	</table>
</td>
<td width="88%">	
	<%	
		/*SQL_amount_cell="select s.uid, s.pid, sum(s.quantity*s.price) from u_t u,p_t p, sales s where s.uid=u.id and s.pid=p.id group by s.uid, s.pid;";
		 rs=stmt.executeQuery(SQL_amount_cell);
		 while(rs.next())
		 {
			 u_id=rs.getInt(1);
			 p_id=rs.getInt(2);
			 amount=rs.getInt(3);
			 idPair_amount.put(u_id+"_"+p_id, amount);
		 }*/
		
	%>	 
	<table align="center" width="100%" border="1">
	<%	/*for(j=0;j<p_list.size();j++)
	{
	out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
}*/
        rs=stmt.executeQuery(SQL_3);
		String idPair="";
		for(i=0;i<u_list.size();i++)
		{
			out.println("<tr  align='center'>");
			for(j=0;j<p_list.size();j++)
			{   
				rs.next();
				out.println("<td width=\"10%\"><font color='#ff0000'>"+rs.getString("coalesce")+"</font></td>");
				/*idPair=(String)pos_idPair.get(i+"_"+j);
				amount=(Integer)idPair_amount.get(idPair);
				if(amount==0)
				{
					out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
				}
				else
				{
					out.println("<td width=\"10%\"><font color='#0000ff'><b>"+amount+"</b></font></td>");
				}*/
			}
			out.println("</tr>");
		}
	%>
	</table>
	
</td>
</tr>
</table>	
	<table width="100%">
	<tr><td align="left">
		
		</td>
		<td align="right">
			
		</td>
		</tr>
	</table>
<%
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
catch(Exception e)
{
  out.println("Fail! Please connect your database first.");
}
%>	

</body>
</html>