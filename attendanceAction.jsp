<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<%

    String attendanceIdParam =
        request.getParameter("attendanceId");

    String action =
        request.getParameter("action");


    if (attendanceIdParam != null &&
        action != null) {

        try {

            int attendanceId =
                Integer.parseInt(attendanceIdParam);


            ABC db = new ABC();

            Connection con = db.getCon();


            if ("ACCEPT".equals(action)) {

                PreparedStatement ps =
                    con.prepareStatement(
                        "UPDATE attendance " +
                        "SET status = 'ACCEPTED' " +
                        "WHERE id = ?"
                    );

                ps.setInt(1, attendanceId);

                ps.executeUpdate();

                ps.close();

            }


            else if ("REJECT".equals(action)) {

                PreparedStatement ps =
                    con.prepareStatement(
                        "UPDATE attendance " +
                        "SET status = 'REJECTED' " +
                        "WHERE id = ?"
                    );

                ps.setInt(1, attendanceId);

                ps.executeUpdate();

                ps.close();

            }


            con.close();


            response.sendRedirect("teacher.jsp");


        } catch (Exception e) {

            out.println(
                "Error: " + e.getMessage()
            );

        }

    } else {

        response.sendRedirect("teacher.jsp");

    }

%>