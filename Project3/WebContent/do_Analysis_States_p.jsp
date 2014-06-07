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
ArrayList<String> p_name_list=new ArrayList<String>();//product ID, 10
ArrayList<String> s_name_list=new ArrayList<String>();//customer ID,20
ArrayList<Integer> s_total_list=new ArrayList<Integer>();//product ID, 10
ArrayList<Integer> p_total_list=new ArrayList<Integer>();//totals by products id, 10
HashMap<Integer, Integer> product_ID_amount	=	new HashMap<Integer, Integer>();
HashMap<String, Integer> state_name_amount=	new HashMap<String, Integer>();
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
Statement 	stmt1,stmt2,stmt3,stmt4;
ResultSet 	rs1=null,rs2=null,rs3=null;
String  	SQL_1=null,SQL_2=null,SQL_3=null,SQL_4=null, SQL_pt=null, SQL_row=null, SQL_col=null;
String  	SQL_amount_row=null,SQL_amount_col=null,SQL_amount_cell=null;
int p_id=0,u_id=0,s_total=0,p_total=0;
String	p_name=null,s_name=null;
int p_amount_price=0,s_amount_price=0;

int show_num_row=20, show_num_col=10;
	
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost:5432/test";
	String user="t-dogg3030";
	String password="password";
	conn =DriverManager.getConnection(url, user, password);
	stmt1 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt2 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt3 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt4 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	
	
	if(("All").equals(state) && ("0").equals(category) )//0,0
	{
		//names from pc tables
		SQL_1="select states.name, psa.total from states, pc_StateAmt as psa WHERE states.name = psa.state order by psa.total desc limit 20";
		SQL_2="select pspa.pid, p.name, pspa.total from pc_StateProdAmt as pspa, products as p where p.id = pspa.pid order by pspa.total desc limit 10";
		SQL_4="DROP TABLE IF EXISTS temp1; CREATE TABLE temp1 (u_rank SERIAL PRIMARY KEY, sid INT); INSERT INTO temp1(sid) select states.id from states, pc_StateAmt as psa WHERE states.name = psa.state order by psa.total desc limit 20; DROP TABLE IF EXISTS temp2; CREATE TABLE temp2 (p_Rank SERIAL PRIMARY KEY, pid INT); INSERT INTO temp2(pid) select pspa.pid from pc_StateProdAmt as pspa order by pspa.total desc limit 10; DROP TABLE IF EXISTS temp3; CREATE TABLE temp3 (t_rank SERIAL PRIMARY KEY, sid INT, pid INT); INSERT INTO temp3(sid, pid) select t1.sid, t2.pid from temp1 as t1, temp2 as t2;";
		SQL_3="select t3.t_rank, t3.sid, t3.pid, coalesce(pc_StateProdAmt.total,0) as total from temp3 as t3 join states on t3.sid = states.id left outer join pc_StateProdAmt on states.name = pc_StateProdAmt.state AND t3.pid = pc_StateProdAmt.pid order by t3.t_rank";
		//SQL_ut="insert into us_t (id, state) select u2.id, u.state from ("+SQL_1+") as u left outer join users u2 on u2.state=u.state order by u.state";
		//SQL_pt="insert into ps_t (id, name) "+SQL_2;
		//SQL_row="select count(distinct state) from users";
		//SQL_col="select count(*) from products";
		//SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s  where s.uid=u.id group by u.state;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s where s.pid=p.id  group by s.pid;";
	}
	
	if(("All").equals(state) && !("0").equals(category) )//0,1
	{
		SQL_1="select state from users  group by state order by state asc offset "+pos_row+" limit "+show_num_row;
		SQL_2="select id,name from products where cid="+category+" order by name asc offset "+pos_col+" limit "+show_num_col;
		//SQL_ut="insert into us_t (id, state) select u2.id, u.state from ("+SQL_1+") as u left outer join users u2 on u2.state=u.state order by u.state";
		//SQL_pt="insert into ps_t (id, name) "+SQL_2;
		//SQL_row="select count(distinct state) from users";
		//SQL_col="select count(*) from products where cid="+category+"";
		//SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by u.state;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s  where s.pid=p.id group by s.pid;";
	}
	
	if(!("All").equals(state) && ("0").equals(category) )//1,0
	{
		SQL_1="select state from users where state='"+state+"'  group by state order by state asc offset "+pos_row+" limit "+show_num_row;
		SQL_2="select id,name from products order by name asc offset "+pos_col+" limit "+show_num_col;
		///SQL_ut="insert into us_t (id, state) select u2.id, u.state from ("+SQL_1+") as u left outer join users u2 on u2.state=u.state order by u.state";
		//SQL_pt="insert into ps_t (id, name) "+SQL_2;
		//SQL_row="select count(distinct state) from users where state='"+state+"'";
		//SQL_col="select count(*) from products";
		//SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s  where s.uid=u.id group by u.state;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s, users u where s.pid=p.id  and s.uid=u.id and u.state='"+state+"'  group by s.pid;";
	}
	
	if(!("All").equals(state) && !("0").equals(category))//1,1
	{
		SQL_1="select state from users where state='"+state+"'  group by state order by state asc offset "+pos_row+" limit "+show_num_row;
		SQL_2="select id,name from products where cid="+category+" order by name asc offset "+pos_col+" limit "+show_num_col;
		//SQL_ut="insert into us_t (id, state) select u2.id, u.state from ("+SQL_1+") as u left outer join users u2 on u2.state=u.state order by u.state";
		//SQL_pt="insert into ps_t (id, name) "+SQL_2;
		//SQL_row="select count(distinct state) from users where state='"+state+"'";
		//SQL_col="select count(*) from products where cid="+category+"";
		//SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by u.state;";
		//SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s, users u where s.pid=p.id  and s.uid=u.id and u.state='"+state+"' group by s.pid;";

	}
	
	
	

	//customer name
	rs1=stmt1.executeQuery(SQL_1);
	while(rs1.next())
	{
		System.out.println("IN WHILE 1 STATE");
		s_name=rs1.getString("name");
		s_total=rs1.getInt("total");
		s_name_list.add(s_name);
		s_total_list.add(s_total);
		state_name_amount.put(s_name, 0);
		
	}
//	out.println(SQL_1+"<br>"+SQL_2+"<br>"+SQL_pt+"<BR>"+SQL_ut+"<br>"+SQL_row+"<BR>"+SQL_col+"<br>");
	//product name
	rs2=stmt2.executeQuery(SQL_2);
	while(rs2.next())
	{
		System.out.println("IN WHILE 2 STATE");
		p_id=rs2.getInt(1);   
		p_name=rs2.getString("name");
		p_total=rs2.getInt("total");
		p_list.add(p_id);
	    p_name_list.add(p_name);
	    p_total_list.add(p_total);
		product_ID_amount.put(p_id,0);
		
	}
	//conn.setAutoCommit(false);
    //stmt2.execute("CREATE TEMP TABLE us_t (id int, state text)ON COMMIT DELETE ROWS;");
	//stmt2.execute("CREATE TEMP TABLE ps_t (id int, name text)ON COMMIT DELETE ROWS;");
	//temporary table
	//customer tempory table
	//stmt2.execute(SQL_ut);
	//product tempory table
	//stmt2.execute(SQL_pt);
	
%>	
<%	

	
	
	
//	out.println(SQL_amount_row+"<br>"+SQL_amount_col+"<br>"+SQL_amount_cell+"<BR>");
	
	

   
    int i=0,j=0;
	HashMap<String, String> pos_idPair=new HashMap<String, String>();
	HashMap<String, Integer> idPair_amount=new HashMap<String, Integer>();	
	int amount=0;
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#9933CC">STATE</font></strong></td></tr></table></td>
			<td width="88%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
    i = 0;
    j = 0;
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
	
	    for(i=0;i<s_name_list.size();i++)
	    {
		    //u_id			=	u_list.get(i);
		    s_name			=	s_name_list.get(i);
		    s_total         =   s_total_list.get(i);
		    out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#0000ff'>$"+s_total+"</font>)</strong></td></tr>");
	    }
	
	%>
	</table>
</td>
<td width="88%">	
 
	<table align="center" width="100%" border="1">
	<%	
	        stmt4.executeUpdate(SQL_4);
        rs3=stmt3.executeQuery(SQL_3);

	    
		for(i=0;i<s_name_list.size();i++)
		{
			out.println("<tr  align='center'>");
			for(j=0;j<p_list.size();j++)
			{   
				rs3.next();
				out.println("<td width=\"10%\"><font color='#ff0000'>"+rs3.getString("total")+"</font></td>");
			}
			out.println("</tr>");
		}
	%>
	</table>
	
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