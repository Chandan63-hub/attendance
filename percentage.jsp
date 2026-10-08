<%@ page import="java.sql.*" %>
<%@ page import="MyPack.ABC" %>

<!DOCTYPE html>
<html>
<head>

    <title>Attendance Percentage</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            padding: 30px;
        }

        .box {
            max-width: 1000px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        th {
            background: #222;
            color: white;
        }

        .back {
            display: block;
            width: 180px;
            margin: 25px auto 0;
            padding: 10px;
            text-align: center;
            background: #222;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

    </style>

</head>

<body>

<div class="box">

    <h2>Attendance Percentage</h2>

    <table>

        <tr>
            <th>Roll No</th>
            <th>Name</th>
            <th>Subject</th>
            <th>Total Classes</th>
            <th>Present</th>
            <th>Percentage</th>
        </tr>

<%

try {

    ABC db = new ABC();

    Connection con = db.getCon();


    /*
       Sirf wahi subjects select honge
       jinke class sessions teacher ne conduct kiye hain.
    */

    String sql =
        "SELECT " +
        "s.roll_no, " +
        "s.name, " +
        "cs.subject, " +

        "COUNT(DISTINCT cs.id) AS total_classes, " +

        "COUNT(DISTINCT a.session_id) AS present " +

        "FROM students s " +

        "CROSS JOIN " +

        "(SELECT DISTINCT subject FROM class_sessions) subjects " +

        "INNER JOIN class_sessions cs " +
        "ON cs.subject = subjects.subject " +

        "LEFT JOIN attendance a " +
        "ON a.student_id = s.id " +
        "AND a.session_id = cs.id " +

        "GROUP BY " +
        "s.id, s.roll_no, s.name, cs.subject " +

        "ORDER BY s.roll_no, cs.subject";


    PreparedStatement ps =
        con.prepareStatement(sql);

    ResultSet rs =
        ps.executeQuery();


    while (rs.next()) {

        int rollNo =
            rs.getInt("roll_no");

        String name =
            rs.getString("name");

        String subject =
            rs.getString("subject");

        int totalClasses =
            rs.getInt("total_classes");

        int present =
            rs.getInt("present");


        double percentage = 0;

        if (totalClasses > 0) {

            percentage =
                ((double) present / totalClasses) * 100;

        }

%>

        <tr>

            <td>
                <%= rollNo %>
            </td>

            <td>
                <%= name %>
            </td>

            <td>
                <%= subject %>
            </td>

            <td>
                <%= totalClasses %>
            </td>

            <td>
                <%= present %>
            </td>

            <td>
                <%= String.format("%.2f", percentage) %> %
            </td>

        </tr>

<%

    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {

%>

        <tr>

            <td colspan="6">

                Error:
                <%= e.getMessage() %>

            </td>

        </tr>

<%

}

%>

    </table>


    <a href="attendance.jsp" class="back">
        Back to Attendance
    </a>

</div>

</body>
</html>