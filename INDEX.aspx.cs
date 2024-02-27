using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

public partial class INDEX : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string InsertImage(string byteData, string imageName)
    {
        string filepath = HttpContext.Current.Server.MapPath("~/UserImages/") + imageName;
        using (FileStream fs = new FileStream(filepath, FileMode.Create))
        {
            using (BinaryWriter bw = new BinaryWriter(fs))
            {
                byte[] data = Convert.FromBase64String(byteData);
                bw.Write(data);
                bw.Close();
            }
        }
        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand("INSERT INTO Image VALUES(@Name)"))
            {
                cmd.Parameters.AddWithValue("@Name", imageName);
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }

        return "Success";
    }
}