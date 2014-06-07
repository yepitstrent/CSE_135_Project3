<%@ page contentType="text/html; charset=utf-8" language="java"
	import="java.sql.*" import="database.*" import="java.util.*"
	errorPage=""%>
<%@include file="welcome.jsp"%>
<%
	if (session.getAttribute("name") != null) {
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

	<div
		style="width: 20%; position: absolute; top: 50px; left: 0px; height: 90%; border-bottom: 1px; border-bottom-style: solid; border-left: 1px; border-left-style: solid; border-right: 1px; border-right-style: solid; border-top: 1px; border-top-style: solid;">
		<table width="100%">
			<tr>
				<td><a href="products_browsing.jsp" target="_self">Show
						Produts</a></td>
			</tr>
			<tr>
				<td><a href="buyShoppingCart.jsp" target="_self">Buy
						Shopping Cart</a></td>
			</tr>
		</table>
	</div>
	<div
		style="width: 79%; position: absolute; top: 50px; right: 0px; height: 90%; border-bottom: 1px; border-bottom-style: solid; border-left: 1px; border-left-style: solid; border-right: 1px; border-right-style: solid; border-top: 1px; border-top-style: solid;">
		<p>
		<table align="center" width="80%"
			style="border-bottom-width: 2px; border-top-width: 2px; border-bottom-style: solid; border-top-style: solid">
			<tr>
				<td align="left"><font size="+3"> <%
 	System.out.println("IN DO PURCHASE!!!!!!!!!");
 		String uName = (String) session.getAttribute("name");
 		int userID = (Integer) session.getAttribute("userID");
 		String role = (String) session.getAttribute("role");
 		String card = null;
 		int card_num = 0;
 		try {
 			card = request.getParameter("card");
 		} catch (Exception e) {
 			card = null;
 		}
 		try {
 			card_num = Integer.parseInt(card);
 			card_num = 3;
 			if (card_num > 0) {

 				Connection conn = null;
 				Statement stmt = null;

 				Statement stm2 = null;
 				try {

 					String SQL_copy = "INSERT INTO sales (uid, pid, quantity, price) select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="
 							+ userID + ";";
 					String SQL = "delete from carts where uid= "
 							+ userID + ";";

 					/* new queries go here*/

 					try {
 						Class.forName("org.postgresql.Driver");
 					} catch (Exception e) {
 						System.out.println("Driver error");
 					}
 					String url = "jdbc:postgresql://localhost:5432/test";
 					String user = "t-dogg3030";
 					String password = "password";
 					conn = DriverManager.getConnection(url, user,
 							password);
 					stmt = conn.createStatement();
 					stm2 = conn.createStatement();

 					try {
 						System.out.println("=======================");
 						System.out.println("==> In Try");

 						conn.setAutoCommit(false);
 						/**record log,i.e., sales table**/
 						stmt.execute(SQL_copy); /*insert into sales*/

 						/*-----------------------------*/
 						ResultSet rs = null;
 						String getCart = "select u.id, u.name, u.state, p.id, p.name, p.cid,"
 								+ " c.quantity, c.price from products p,"
 								+ " users u, carts c where c.uid=u.id and c.pid=p.id and c.uid="
 								+ userID;

 						rs = stmt.executeQuery(getCart);

 						int pid, cid, quantity = 0;
 						String state, pname = "";
 						float price = 0, total = 0;

 						String check = "UPDATE Carts SET quantity = quantity + 1 where uid = 102;";

 						while (rs.next()) {

 							System.out.println("==> In While");

 							state = rs.getString(3);
 							pid = rs.getInt(4);
 							pname = rs.getString(5);
 							cid = rs.getInt(6);
 							quantity = rs.getInt(7);
 							price = rs.getInt(8);
 							total = quantity * price;

 							System.out.println("[state: " + state
 									+ "] " + "[pid: " + pid + "] "
 									+ "[p name: " + pname + "] "
 									+ "[cid:" + cid + "] " + "[qua:"
 									+ quantity + "] " + "[pri: "
 									+ price + "] " + "[total: " + total
 									+ "] ");

 							System.out.println("==> got result set");
 							//System.out.println("+++++" + stm2.executeUpdate(check));

 							// PC_PRODAMT
 							String pc_ProdAmt_UPDATE = "UPDATE pc_ProdAmt SET total = total + "
 									+ total + " WHERE pid= " + pid;

 							String pc_ProdAmt_INSERT = "INSERT INTO pc_ProdAmt VALUES ("
 									+ pid
 									+ ",'"
 									+ pname
 									+ "',"
 									+ total
 									+ ");";
 									
 	
 							if (stm2.executeUpdate(pc_ProdAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_ProdAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_ProdAmt_INSERT);

 							} else {
 								System.out.println("update: "
 										+ pc_ProdAmt_UPDATE);
 							}

 							// pc_UsersAmt
 							String pc_UsersAmt_UPDATE = "UPDATE pc_UsersAmt SET total = total + "
 									+ total + " WHERE uid= " + userID;

 							String pc_UsersAmt_INSERT = "INSERT INTO pc_UsersAmt VALUES ("
 									+ userID
 									+ ",'"
 									+ uName
 									+ "',"
 									+ total + ");";

 							if (stm2.executeUpdate(pc_UsersAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_UsersAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_UsersAmt_INSERT);
 							}

 							else {
 								System.out.println("update: "
 										+ pc_UsersAmt_UPDATE);
 							}

 							// pc_StateAmt
 							String pc_StateAmt_UPDATE = "UPDATE pc_StateAmt SET total = total + "
 									+ total + " WHERE state= '" + state + "'";

 							String pc_StateAmt_INSERT = "INSERT INTO pc_StateAmt VALUES ('"
 									+ state + "'," + total + ");";

 							if (stm2.executeUpdate(pc_StateAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_StateAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_StateAmt_INSERT);
 							}

 							else {
 								System.out.println("update: "
 										+ pc_StateAmt_UPDATE);
 							}

 							// pc_UserProdAmt

 							// UPDATE pc_UserProdAmt SET total = total + "+amount_price+" WHERE uid="+uid+" AND pid="+pid;
 							// INSERT INTO pc_UserProdAmt VALUES ("+userID+", "+pid.get(i)+", "+total.get(i)+");

 							String pc_UserProdAmt_UPDATE = "UPDATE pc_UserProdAmt SET total = total + "
 									+ total
 									+ " WHERE uid= "
 									+ userID
 									+ " AND pid=" + pid;

 							String pc_UserProdAmt_INSERT = "INSERT INTO pc_UserProdAmt VALUES ("
 									+ userID
 									+ ","
 									+ pid
 									+ ","
 									+ total
 									+ ");";

 							if (stm2.executeUpdate(pc_UserProdAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_UserProdAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_UserProdAmt_INSERT);
 							}

 							else {
 								System.out.println("update: "
 										+ pc_UserProdAmt_UPDATE);
 							}

 							// pc_UseCatAmt

 							// UPDATE pc_UseCatAmt SET total = total + "+amount_price+" WHERE uid="+uid+" AND cid="+cid; 
 							// INSERT INTO pc_UseCatAmt VALUES ("+userID+", "+uName+", "+cid.get(i)+", "+total.get(i)+");

 							String pc_UseCatAmt_UPDATE = "UPDATE pc_UseCatAmt SET total = total + "
 									+ total
 									+ " WHERE uid= "
 									+ userID
 									+ " AND cid=" + cid;

 							String pc_UseCatAmt_INSERT = "INSERT INTO pc_UseCatAmt VALUES ("
 									+ userID
 									+ ",'"
 									+ uName
 									+ "',"
 									+ cid
 									+ "," + total + ");";

 							if (stm2.executeUpdate(pc_UseCatAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_UseCatAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_UseCatAmt_INSERT);
 							}

 							else {
 								System.out.println("update: "
 										+ pc_UseCatAmt_UPDATE);
 							}

 							// pc_StateProdAmt

 							// UPDATE pc_StateProdAmt SET total = total + "+amount_price+" WHERE state="+state+" AND pid="+pid; 
 							// INSERT INTO pc_StateProdAmt VALUES ("+state.get(i)+", "+cid.get(i)+", "+total.get(i)+");

 							String pc_StateProdAmt_UPDATE = "UPDATE pc_StateProdAmt SET total = total + "
 									+ total
 									+ " WHERE state= '"
 									+ state
 									+ "' AND pid=" + pid;

 							String pc_StateProdAmt_INSERT = "INSERT INTO pc_StateProdAmt VALUES ('"
 									+ state
 									+ "',"
 									+ cid
 									+ ","
 									+ total + ");";

 							if (stm2.executeUpdate(pc_StateProdAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_StateProdAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_StateProdAmt_INSERT);
 							}

 							else {
 								System.out.println("update: "
 										+ pc_StateProdAmt_UPDATE);
 							}
 							
 						  // pc_StateCatAmt

							// UPDATE pc_StateCatAmt SET total = total + "+amount_price+" WHERE state="+state+" AND cid="+cid;
							// INSERT INTO pc_StateCatAmt VALUES ("+state.get(i)+", "+cid.get(i)+", "+total.get(i)+");
							
 							String pc_StateCatAmt_UPDATE = "UPDATE pc_StateCatAmt SET total = total + "
 									+ total
 									+ " WHERE state= '"
 									+ state
 									+ "' AND cid=" + cid;

 							String pc_StateCatAmt_INSERT = "INSERT INTO pc_StateCatAmt VALUES ('"
 									+ state
 									+ "',"
 									+ cid
 									+ ","
 									+ total + ");";

 							if (stm2.executeUpdate(pc_StateCatAmt_UPDATE) == 0) {
 								stm2.executeUpdate(pc_StateCatAmt_INSERT);
 								System.out.println("insert: "
 										+ pc_StateCatAmt_INSERT);
 							}

 							else {
 								System.out.println("update: "
 										+ pc_StateCatAmt_UPDATE);
 							}

 						}

 						System.out.println("==> While Done.");

 						/*-----------------------------*/

 						stmt.execute(SQL); /*delete from cart*/
 						conn.commit();

 						conn.setAutoCommit(true);
 						out.println("Dear customer '"
 								+ uName
 								+ "', Thanks for your purchasing.<br> Your card '"
 								+ card
 								+ "' has been successfully proved. <br>We will ship the products soon.");
 						out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
 					} catch (Exception e) {
 						out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");

 					}
 					conn.close();
 				} catch (Exception e) {
 					out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");

 				}
 			} else {

 				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
 			}
 		} catch (Exception e) {
 			out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
 		}
 %>

				</font><br></td>
			</tr>
		</table>
	</div>
</body>
</html>
<%
	}
%>