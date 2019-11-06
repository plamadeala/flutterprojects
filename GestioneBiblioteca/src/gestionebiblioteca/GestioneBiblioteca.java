/*
 * Connessione al dataBase Biblioteca.accdb e lettura tabella Autori
 */
package gestionebiblioteca;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Stefano Giacomello
 */

public class GestioneBiblioteca {

    static String str;
    static final String SPAZI = "                    ";
    
    public static void main(String[] args) {
        
        // variabili
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        // Step 1: caricamento/registrazione MS Access JDBC driver
        try {
            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        } catch (ClassNotFoundException cnfex) {
            System.out.println("Problema di caricamento/registrazione "
                    + "di MS Access JDBC driver");
            cnfex.printStackTrace();
        }

        // Step 2: apertura della connessione con il database
        try {
            String msAccDB = "Biblioteca.accdb";
            String dbURL = "jdbc:ucanaccess://" + msAccDB;

            // Step 2.A: creazione della connessione
            connection = DriverManager.getConnection(dbURL);

            // Step 2.B: creazione di un'asserzione
            statement = connection.createStatement();

            // Step 2.C: esecuzione di SQL per richiedere un recordset
            resultSet = statement.executeQuery("SELECT Autori.[IdAutore], Autori.[Cognome], Autori.[Nome] FROM Autori ORDER BY Autori.[Cognome], Autori.[Nome]");

            System.out.println("Id     Cognome           Nome");
            System.out.println("---    ----------------  -------------------");

            // scorre i record del set visualizzando i dati
            while (resultSet.next()) {
                str = String.format("%.7s", resultSet.getInt(1)+SPAZI);
                str = str + String.format("%.18s", resultSet.getString(2)+SPAZI);
                str = str + resultSet.getString(3);
                System.out.println(str);
            }
        } catch (SQLException sqlex) {
            sqlex.printStackTrace();
            
        } finally {
            // Step 3: chiusura della connessione
            try {
                if (null != connection) {
                    // chiusura del recordset e dell'asserzione
                    resultSet.close();
                    statement.close();

                    // chiusura della connessione
                    connection.close();
                }
            } catch (SQLException sqlex) {
                sqlex.printStackTrace();
            }
        }
    }
}