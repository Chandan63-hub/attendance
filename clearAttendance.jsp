<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<%

    String attendanceIdText =
        request.getParameter("attendanceId");

    String selectedDate =
        request.getParameter("attendanceDate");

    String selectedSubject =
        request.getParameter("subject");


    if (attendanceIdText != null &&
        !attendanceIdText.trim().equals("")) {

        try {

            int attendanceId =
                Integer.parseInt(attendanceIdText);


            ABC db = new ABC();

            Connection con =
                db.getCon();


            /*
             * Only ACCEPTED attendance can be cleared.
             */

            PreparedStatement ps =
                con.prepareStatement(
                    "DELETE FROM attendance " +
                    "WHERE id = ? " +
                    "AND status = 'ACCEPTED'"
                );


            ps.setInt(
                1,
                attendanceId
            );


            ps.executeUpdate();


            ps.close();

            con.close();


            /*
             * Return to history
             * with same filters.
             */

            String redirectURL =
                "history.jsp?attendanceDate="
                + java.net.URLEncoder.encode(
                    selectedDate == null
                        ? ""
                        : selectedDate,
                    "UTF-8"
                  )
                + "&subject="
                + java.net.URLEncoder.encode(
                    selectedSubject == null
                        ? ""
                        : selectedSubject,
                    "UTF-8"
                  );


            response.sendRedirect(
                redirectURL
            );

            return;


        } catch (Exception e) {

            out.println(
                "Error: " + e.getMessage()
            );

        }

    } else {

        response.sendRedirect(
            "history.jsp"
        );

        return;

    }

%>