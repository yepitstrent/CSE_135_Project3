<%@ page contentType="text/html; charset=utf-8" language="java"
	import="java.sql.*" import="database.*" import="java.util.*"
	errorPage=""%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
	<%
		ArrayList<Integer> p_list = new ArrayList<Integer>();//product ID, 10
		ArrayList<Integer> u_list = new ArrayList<Integer>();//customer ID,20
		ArrayList<Integer> u_total_list = new ArrayList<Integer>();//totals by users id, 20
		ArrayList<Integer> p_total_list = new ArrayList<Integer>();//totals by products id, 10
		ArrayList<String> p_name_list = new ArrayList<String>();//product ID, 10
		ArrayList<String> u_name_list = new ArrayList<String>();//customer ID,20
		HashMap<Integer, Integer> product_ID_amount = new HashMap<Integer, Integer>();
		HashMap<Integer, Integer> customer_ID_amount = new HashMap<Integer, Integer>();
	%>
	<%
		String state = null, category = null;
		try {
			state = request.getParameter("state");
			category = request.getParameter("category");
			//age       =	request.getParameter("age"); 			
		} catch (Exception e) {
			state = null;
			category = null;
		}
		String pos_row_str = null, pos_col_str = null;
		int pos_row = 0, pos_col = 0;
		try {
			pos_row_str = request.getParameter("pos_row");
			pos_row = Integer.parseInt(pos_row_str);
			pos_col_str = request.getParameter("pos_col");
			pos_col = Integer.parseInt(pos_col_str);
		} catch (Exception e) {
			pos_row_str = null;
			pos_row = 0;
			pos_col_str = null;
			pos_col = 0;

		}
	%>
	<%
		Connection conn = null;
		Statement stmt1, stmt2, stmt3, stmt4;
		ResultSet rs1 = null, rs2 = null, rs3 = null;
		String SQL_1 = null, SQL_2 = null, SQL_3 = null, SQL_4 = null, SQL_pt = null, SQL_row = null, SQL_col = null;
		String SQL_amount_row = null, SQL_amount_col = null, SQL_amount_cell = null;
		int p_id = 0, p_total, u_id = 0;
		String p_name = null, u_name = null;
		int p_amount_price = 0, u_amount_price = 0, u_total = 0;

		int show_num_row = 20, show_num_col = 10;

		try {
			try {
				Class.forName("org.postgresql.Driver");
			} catch (Exception e) {
				System.out.println("Driver error");
			}
			String url = "jdbc:postgresql://localhost:5432/test";
			String user = "t-dogg3030";
			String password = "password";
			conn = DriverManager.getConnection(url, user, password);
			stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_UPDATABLE);
			stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_UPDATABLE);
			stmt3 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_UPDATABLE);
			stmt4 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_UPDATABLE);

			if (("All").equals(state) && ("0").equals(category))//0,0
			{
				SQL_1 = "SELECT * FROM pc_UsersAmt ORDER BY total desc LIMIT 20";
				SQL_2 = "SELECT * FROM pc_ProdAmt ORDER BY total desc LIMIT 10";
				SQL_4 = "DROP TABLE IF EXISTS temp1; CREATE TABLE temp1 (u_rank SERIAL PRIMARY KEY, uid INT); "
						+ "INSERT INTO temp1(uid) select pua.uid from pc_UsersAmt as pua order by pua.total desc limit 20; "
						+ "DROP TABLE IF EXISTS temp2; CREATE TABLE temp2 (p_Rank SERIAL PRIMARY KEY, pid INT); "
						+ "INSERT INTO temp2(pid) select ppa.pid from pc_ProdAmt as ppa order by ppa.total desc limit 10; "
						+ "DROP TABLE IF EXISTS temp3; CREATE TABLE temp3 (t_rank SERIAL PRIMARY KEY, uid INT, pid INT); "
						+ "INSERT INTO temp3(uid, pid) select t1.uid, t2.pid from temp1 as t1, temp2 as t2";
				SQL_3 = "select t3.t_rank, t3.uid, t3.pid, coalesce(pc_UserProdAmt.total,0) as total "
						+ "from temp3 as t3 "
						+ "left outer join pc_UserProdAmt on t3.uid = pc_UserProdAmt.uid "
						+ "AND t3.pid = pc_UserProdAmt.pid "
						+ "order by t3.t_rank";
			}

			if (("All").equals(state) && !("0").equals(category))//0,1
			{
				SQL_1 = "select * from pc_UseCatAmt where cid = "
						+ category
						+ " order by total desc, uid, cid limit 20";
				SQL_2 = "select ppa.pid, ppa.name, ppa.total from pc_ProdAmt as ppa, products as p where p.cid = "
						+ category
						+ " and ppa.pid = p.id order by ppa.total desc limit 10";

				SQL_4 = "DROP TABLE IF EXISTS temp1; CREATE TABLE temp1 (u_rank SERIAL PRIMARY KEY, uid INT); "
						+ "INSERT INTO temp1(uid) select uid from pc_UseCatAmt where cid = "
						+ category
						+ " order by total desc limit 20; DROP TABLE IF EXISTS temp2; "
						+ "CREATE TABLE temp2 (p_Rank SERIAL PRIMARY KEY, pid INT); "
						+ "INSERT INTO temp2(pid) select ppa.pid from pc_ProdAmt as ppa, products as p where p.cid = "
						+ category
						+ " and ppa.pid = p.id order by ppa.total desc limit 10; DROP TABLE IF EXISTS temp3; "
						+ "CREATE TABLE temp3 (t_rank SERIAL PRIMARY KEY, uid INT, pid INT); "
						+ "INSERT INTO temp3(uid, pid) select t1.uid, t2.pid from temp1 as t1, temp2 as t2;";

				SQL_3 = "select t3.t_rank, t3.uid, t3.pid, coalesce(pc_UserProdAmt.total,0) as total "
						+ "from temp3 as t3 "
						+ "left outer join pc_UserProdAmt on t3.uid = pc_UserProdAmt.uid "
						+ "AND t3.pid = pc_UserProdAmt.pid "
						+ "order by t3.t_rank";
			}

			if (!("All").equals(state) && ("0").equals(category))//1,0
			{
				SQL_1 = "select pc.uid, pc.name, pc.total from pc_UsersAmt as pc, users as u "+
			            "where pc.uid = u.id and u.state = '"+ state +
						"' order by pc.total desc limit 20";
				SQL_2 = "SELECT state as name, pid, total FROM pc_StateProdAmt as pc where state = '"
						+ state + "' order by total desc limit 10";
				SQL_4 = "DROP TABLE IF EXISTS temp1; CREATE TABLE temp1 (u_rank SERIAL PRIMARY KEY, uid INT); "+
						"INSERT INTO temp1(uid) select pc.uid from pc_UsersAmt as pc, users as u "+
				        "where pc.uid = u.id and u.state = '"+state+"' order by pc.total desc limit 20; "+
						"DROP TABLE IF EXISTS temp2; CREATE TABLE temp2 (p_Rank SERIAL PRIMARY KEY, pid INT); "+
				        "INSERT INTO temp2(pid) SELECT pspa.pid FROM pc_StateProdAmt as pspa where state = '"+state+
				        "' order by total desc limit 10; DROP TABLE IF EXISTS temp3; "+
				        "CREATE TABLE temp3 (t_rank SERIAL PRIMARY KEY, uid INT, pid INT); "+
				        "INSERT INTO temp3(uid, pid) select t1.uid, t2.pid from temp1 as t1, temp2 as t2;";
				SQL_3 = "select t3.t_rank, t3.uid, t3.pid, coalesce(pc_UserProdAmt.total,0) as total "
						+ "from temp3 as t3 "
						+ "left outer join pc_UserProdAmt on t3.uid = pc_UserProdAmt.uid "
						+ "AND t3.pid = pc_UserProdAmt.pid "
						+ "order by t3.t_rank";
			}

			if (!("All").equals(state) && !("0").equals(category))//1,1
			{
				System.out.println("IN STRING CAT");
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
			System.out.println("IN SQL_1 EXE");
			rs1 = stmt1.executeQuery(SQL_1);
			while (rs1.next()) {
				System.out.println("IN WHILE 1");
				//u_id=rs.getInt(1);
				u_id = Integer.parseInt(rs1.getString("uid"));
				u_name = rs1.getString("name");
				u_total = Integer.parseInt(rs1.getString("total"));
				u_list.add(u_id);//user id list
				u_name_list.add(u_name);//users name list
				u_total_list.add(u_total);
				customer_ID_amount.put(u_id, u_total);

			}
			//	out.println(SQL_1+"<br>"+SQL_2+"<br>"+SQL_pt+"<BR>"+SQL_ut+"<br>"+SQL_row+"<BR>"+SQL_col+"<br>");
			//product name
			System.out.println("SQL_2 EXE");
			rs2 = stmt2.executeQuery(SQL_2);
			while (rs2.next()) {
				System.out.println("IN WHILE 2");
				p_id = rs2.getInt("pid"); //pid
				p_name = rs2.getString("name");//prod name
				p_total = rs2.getInt("total");//prod total
				p_list.add(p_id);
				p_name_list.add(p_name);
				p_total_list.add(p_total);
				product_ID_amount.put(p_id, p_total);

			}
	%>

	<table align="center" width="100%" border="1">
		<tr align="center">
			<td><strong><font size="+2" color="#FF00FF">CUSTOMER</font></strong></td>
			<%
				int i = 0;
					int j = 0;
					int amount_show = 0;
					for (i = 0; i < p_list.size(); i++) {
						p_id = p_list.get(i);
						p_name = p_name_list.get(i);
						p_total = p_total_list.get(i);
						out.print("<td width='10%'><strong>" + p_name
								+ "<br>(<font color='#0000ff'>$" + p_total
								+ "</font>)</strong></td>");
					}
			%>
		</tr>

		<%
			    stmt4.executeUpdate(SQL_4);
				rs3 = stmt3.executeQuery(SQL_3);

				for (i = 0; i < u_list.size(); i++) 
				{

					u_id = u_list.get(i);
					u_name = u_name_list.get(i);
					u_total = u_total_list.get(i);
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"
							+ u_name
							+ "(<font color='#0000ff'>$"
							+ u_total
							+ "</font>)</strong></td>");

					for (j = 0; j < p_list.size(); j++) 
					{
						rs3.next();
						out.println("<td width=\"10%\"><font color='#ff0000'>"
								+ rs3.getString("total") + "</font></td>");
					}

					out.println("</tr>");
				}
		%>
	</table>
	<%
		conn.commit();
			conn.setAutoCommit(true);
			conn.close();
		} catch (Exception e) {
			out.println("Fail! Please connect your database first.");
		}
	%>

</body>
</html>