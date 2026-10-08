/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package MyPack;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.DriverManager;
public class ABC{
    Connection con=null;
    PreparedStatement pd=null;
    ResultSet rs=null;
    public ABC() throws Exception{
        Class.forName("com.mysql.jdbc.Driver");
    }
    // code for connection
    public Connection getCon() throws Exception{
        con=DriverManager.getConnection("jdbc:mysql://localhost:3306/attendance","root","");
        return con;
    }
    // code for insert update delete command
    public boolean MyInsertUpdateDelete(String command) throws Exception{
        pd=getCon().prepareStatement(command);
        int n=pd.executeUpdate();
        if(n>0)
            return true;
        else
            return false;
    }
    // code for display record
    public ResultSet DisplayRecord(String command) throws Exception{
        pd=getCon().prepareStatement(command);
        rs=pd.executeQuery();
        return rs;
    }
}
