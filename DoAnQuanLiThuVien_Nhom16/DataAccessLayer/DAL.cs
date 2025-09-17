using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
    public class DAL
    {
        SqlConnection cnn = null; // ket not SQL server
        SqlCommand cmd = null; // thuc thi cac cau lenh SQL
        SqlDataAdapter adp = null; // dung de do du lieu tu CSDL vao DataSet
        string strConnect = @"Data Source=DANHTRAN\SQLEXPRESS;Initial Catalog=ThuVien;Integrated Security=True;";

        // khoi tao ket noi
        public DAL()
        {
            cnn = new SqlConnection(strConnect);
            cmd = cnn.CreateCommand();
        }

        // thu tuc lay danh sach
        // strSQL: cau lenh SQL
        // ct: kieu cau lenh SQL (Text, StoreProcedure)
        // tra ve mot bang du lieu
        // su dung cho cac lenh select
        public DataSet ExcuteQueryDataSet(string strSQL, string ct)
        {
            if (cnn.State == ConnectionState.Open)
            {
                cnn.Close();
            }
            cnn.Open();
            cmd.CommandText = strSQL;
            cmd.CommandType = ct;
            cmd.Parameters.Clear();
            adp = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            return ds;
        }

        // thuc thi cac cau lenh Insert/Update/Delete
        // strSQL: cau lenh SQL
        // ct: kieu cau lenh SQL (Text, StoreProcedure)
        // param: mang tham so truyen vao neu co
        // error: tham so kieu out, tra ve thong bao loi neu co
        public bool MyExecuteNonQuery(string strSQL, CommandType ct, ref string error, params SqlParameter[] param)
        {
            bool f = false;
            if (cnn.State == ConnectionState.Open)
            {
                cnn.Close();
            }
            cnn.Open();
            cmd.Parameters.Clear();
            cmd.CommandText = strSQL;
            cmd.CommandType = ct;

            foreach (SqlParameter p in param)
                cmd.Parameters.Add(p);

            try
            {
                cmd.ExecuteNonQuery();  // chạy Insert/Update/Delete
                f = true;
            }
            catch (SqlException ex)
            {
                error = ex.Message;
            }
            finally
            {
                cnn.Close();
            }
            return f;
        }

        // thuc thi cac cau lenh tra ve mot gia tri (COUNT, MAX, MIN, ...)
        // strSQL: cau lenh SQL
        // tra ve mot gia tri
        public int MyExecuteScalarFunction(string strSQL)
        {
            if (cnn.State == ConnectionState.Open)
            {
                cnn.Close();
            }
            cnn.Open();
            cmd.Parameters.Clear();
            cmd.CommandText = strSQL;
            cmd.CommandType = CommandType.Text;

            int result = 0;
            int? count = cmd.ExecuteScalar() as int?;
            if (count != null)
                result = count.Value;

            return result;
        }

        // thuc thi cac cau lenh tra ve mot gia tri XML
        // strSQL: cau lenh SQL
        // ct: kieu cau lenh SQL (Text, StoreProcedure)
        // p: mang tham so truyen vao neu co
        // tra ve mot chuoi XML

        public string ExecuteQueryXML(string strSQL, CommandType ct, params SqlParameter[] p)
        {
            cmd.CommandText = strSQL;
            cmd.CommandType = ct;
            adp = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            return ds.GetXml();
        }
    }
}
