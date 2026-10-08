<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<%

    String idParam =
        request.getParameter("attendanceId");


    if (idParam == null || idParam.equals("")) {

        out.print("ERROR");

        return;
    }


    try {

        int attendanceId =
            Integer.parseInt(idParam);


        ABC db = new ABC();

        Connection con =
            db.getCon();


        PreparedStatement ps =
            con.prepareStatement(
                "SELECT status " +
                "FROM attendance " +
                "WHERE id=?"
            );


        ps.setInt(
            1,
            attendanceId
        );


        ResultSet rs =
            ps.executeQuery();


        if (rs.next()) {

            out.print(
                rs.getString("status")
            );

        } else {

            out.print("ERROR");

        }


        rs.close();

        ps.close();

        con.close();


    } catch (Exception e) {

        out.print("ERROR");

    }

%>