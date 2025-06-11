using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web.UI;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Xml.Linq;
namespace Rentas 
{
    public partial class Formulario : Page
    {
        protected void ddlContacto_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        public class Item
        {
            public string ItemNombre { get; set; }
            public decimal Precio { get; set; }
            public int Cantidad { get; set; }
            public int Descuento { get; set; }
            public decimal Total => Precio * Cantidad * (1 - Descuento / 100m);
        }





        protected void btnVaciar_Click(object sender, EventArgs e)
        {
            hfCarritoJSON.Value = "[]";
            lblSubtotal.Text = "$0.00";
            lblIVA.Text = "$0.00";
            lblTotal.Text = "$0.00";

          



        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
         try
        {
             var carrito = JsonConvert.DeserializeObject<List<Item>>(hfCarritoJSON.Value);

                if (carrito == null || carrito.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('El carrito está vacío.');", true);
                    return;
              }

                string connStr =ConfigurationManager.ConnectionStrings["MyConexion"].ConnectionString;
                using (var conn =new MySqlConnection(connStr))
                {
                    conn.Open();
                    string idCliente = Guid.NewGuid().ToString("N").Substring(0, 12);

                    var cmdCliente = new MySqlCommand("INSERT INTO Clientes (id_cliente, nombre, lugar) VALUES (@id, @nombre, @lugar);", conn);
                    cmdCliente.Parameters.AddWithValue("@id", idCliente);
                   cmdCliente.Parameters.AddWithValue("@nombre", txtNombre.Text);
                    cmdCliente.Parameters.AddWithValue("@lugar", txtLugar.Text);
                    cmdCliente.ExecuteNonQuery();

                    var cmdCot = new MySqlCommand("INSERT INTO Cotizaciones (id_cliente, fecha) VALUES (@id_cliente, NOW()); SELECT LAST_INSERT_ID();", conn);
                    cmdCot.Parameters.AddWithValue("@id_cliente", idCliente);
                    int idCotizacion = Convert.ToInt32(cmdCot.ExecuteScalar());

                    foreach (var item in carrito)
                 {
                        var cmdDet = new MySqlCommand("INSERT INTO Conceptos (id_cotizacion, item, precio_unitario, dias, total) VALUES (@id, @item, @precio, @dias, @total);", conn);
                        cmdDet.Parameters.AddWithValue("@id", idCotizacion);
                       cmdDet.Parameters.AddWithValue("@item", item.ItemNombre);
                      cmdDet.Parameters.AddWithValue("@precio", item.Precio);
                      cmdDet.Parameters.AddWithValue("@dias", item.Cantidad);
                      cmdDet.Parameters.AddWithValue("@total", item.Total);
                      cmdDet.ExecuteNonQuery();
                    }
                }

                hfCarritoJSON.Value = "[]";
                txtNombre.Text = "";
                txtLugar.Text = "";
                ddlContacto.ClearSelection();
                ddlVendedor.ClearSelection();
                txtComision.Text = "0";
                lblSubtotal.Text = "$0.00";
                lblIVA.Text = "$0.00";
                lblTotal.Text = "$0.00";

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cotización guardada correctamente.'); limpiarVistaPrevia();", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Error al guardar: {ex.Message}');", true);
            }
        }

        protected void btnPDF_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text;
            string lugar = txtLugar.Text;
            string carritoJson = hfCarritoJSON.Value;

            if (string.IsNullOrWhiteSpace(carritoJson))
            {
                Response.Write("No hay datos en el carrito.");
                return;
            }

            var carrito = JsonConvert.DeserializeObject<List<Item>>(carritoJson);

            if (carrito == null || carrito.Count == 0)
            {
                Response.Write("El carrito está vacío o los datos son inválidos.");
                return; }

            using (MemoryStream ms = new MemoryStream())
            {Document doc = new Document(PageSize.A4, 40, 40, 40, 40);
             PdfWriter.GetInstance(doc, ms);
             doc.Open();
             var titleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.BLACK);
             var normalFont = FontFactory.GetFont(FontFactory.HELVETICA, 12, BaseColor.BLACK);

                doc.Add(new Paragraph("COTIZACIÓN DE RENTA DE EQUIPOS", titleFont));
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph($"Solicitante: {nombre}", normalFont));
                doc.Add(new Paragraph($"Lugar: {lugar}", normalFont));
                doc.Add(new Paragraph($"Fecha: {DateTime.Now:dd/MM/yyyy}", normalFont));
                doc.Add(new Paragraph(" "));

                // Tabla de cotización
                PdfPTable table = new PdfPTable(4);
                table.WidthPercentage = 100;
                table.SetWidths(new float[] { 4, 1, 1, 2 });

                table.AddCell("Equipo");
                table.AddCell("Días");
                table.AddCell("Desc.");
                table.AddCell("Total");

                decimal subtotal = 0;
                foreach (var item in carrito)
                {
                    decimal total = item.Precio * item.Cantidad * (1 - item.Descuento / 100m);
                    subtotal += total;

                    table.AddCell(item.ItemNombre);
                    table.AddCell(item.Cantidad.ToString());
                    table.AddCell(item.Descuento + "%");
                    table.AddCell("$" + total.ToString("0.00"));
                }

                doc.Add(table);
                doc.Add(new Paragraph(" "));

                decimal iva = subtotal * 0.16m;
                decimal totalFinal = subtotal + iva;

                string contacto = ddlContacto.SelectedValue;
                string vendedor = ddlVendedor.SelectedValue;
                int comision = int.TryParse(txtComision.Text, out int c) ? c : 0;
                decimal ganancia = subtotal * comision / 100m;

                doc.Add(new Paragraph($"Subtotal: ${subtotal:0.00}", normalFont));
                doc.Add(new Paragraph($"IVA (16%): ${iva:0.00}", normalFont));
                doc.Add(new Paragraph($"Total: ${totalFinal:0.00}", titleFont));
                doc.Add(new Paragraph(" "));

                doc.Add(new Paragraph($"Contacto Inicial: {contacto}", normalFont));
                doc.Add(new Paragraph($"Vendedor: {vendedor}", normalFont));
                doc.Add(new Paragraph($"Comisión del Contacto: {comision}%", normalFont));
                doc.Add(new Paragraph($"Ganancia del Contacto: ${ganancia:0.00}", normalFont));


                doc.Close();

                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "attachment;filename=Factura.pdf");
                Response.BinaryWrite(ms.ToArray());
                Response.End();
        }
        }}
}
