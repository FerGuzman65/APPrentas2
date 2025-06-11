<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Formulario.aspx.cs" Inherits="Rentas.Formulario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Formulario Renta de Equipos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
    body {
  font-family: 'Segoe UI', sans-serif;
}

#tablaCatalogo tr:hover {
  background-color: lightgreen;
  transition: background-color 0.2s ease-in-out;
  cursor: pointer;
}

.resultado-item:hover {
  background-color: lightgreen;
  cursor: pointer;
}

.resultado-seleccionado {
  background-color: seagreen;
  color: white;
  font-weight: bold;
}

.section-heading {
  background-color: whitesmoke;
  padding: 12px 16px;
  font-weight: 600;
  border-radius: 4px;
  margin-bottom: 20px;
  font-size: 1.1rem;
}

.subheading-box {
  background-color: aliceblue;
  padding: 16px;
  border: 1px solid lightgray;
  border-radius: 6px;
  margin-bottom: 24px;
}

.table-modern thead {
  background-color: ghostwhite;
  font-weight: 600;
  font-size: 0.95rem;
  color: black;
}

.table-modern th,
.table-modern td {
  vertical-align: middle;
  padding: 12px 10px;
  font-size: 0.92rem;
  border-color: lightgray;
}

.table-modern th {
  border-bottom: 2px solid silver;
}

.table-modern tbody tr:hover {
  background-color: whitesmoke;
}
.table-clean td:first-child,
.table-clean th:first-child {
  max-width: 140px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.table-clean {
  border-collapse: separate;
  border-spacing: 0 6px;
  font-size: 0.92rem;
  color: black;
}
.table-clean thead th {
  background-color: lightgray;
  font-weight: 600;
  color: black;
  padding: 8px 12px;
  border-bottom: 1px solid gray;
}


.table-clean td {
  background-color: white;
  padding: 8px 12px;
  border-top: 1px solid lightgray;
  vertical-align: middle;
}

.btn {
  border-radius: 0.5rem;
  font-weight: 500;
}
.btn-editar {
  background-color: gold;
  color: black;
}

.btn-outline-secondary {
  color: darkslateblue;
  border-color: darkslateblue;
}

.btn-outline-secondary:hover {
  background-color: darkslateblue;
  color: white;
}

.btn-danger {
  background-color: tomato;
  border-color: tomato;
}

.btn-danger:hover {
  background-color: firebrick;
  border-color: firebrick;
}

.form-icon {
  margin-right: 6px;
  color: steelblue;
}

#catalogo {
  max-height: 80vh;
  overflow-y: auto;
}
.catalogo-btn {
  background-color: #e9ecef;
  color: #212529;
  padding: 10px 16px;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s;
  border: 1px solid #ced4da;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}

.catalogo-btn:hover {
  background-color: #d6d8db;
}


.position-sticky {
  position: sticky;
  top: 120px;
}

.bg-light-gray {
  background-color: whitesmoke;
}

.text-dark {
  color: black;
}
#previewItems td:first-child {
  white-space: normal;
  word-break: break-word;
  max-width: 160px;
}

.table-clean th, .table-clean td {
  vertical-align: top;
  font-size: 0.92rem;
}

.card.vista-previa {
  width: 100%;
  min-width: 320px;
}

</style>



<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css" />
<script src="https://cdn.jsdelivr.net/npm/litepicker/dist/bundle.js"></script>

</head>
<body>
<form id="form1" runat="server" class="container mt-4">
  <!-- Encabezado -->
  <div class="d-flex justify-content-end sticky-top bg-white py-3" style="z-index: 1030;">
    <asp:Button ID="Button1" runat="server" Text="Guardar cotización" CssClass="btn btn-outline-secondary me-2" OnClick="btnGuardar_Click" />
    <button type="button" class="btn btn-danger">Enviar factura</button>
  </div>

  <div class="d-flex justify-content-between align-items-center sticky-top bg-white py-3 px-2" style="z-index: 1030;">
    <button type="button" class="btn btn-outline-secondary"> ← Volver al inicio </button>
  </div>

  <div class="row">
    <!-- IZQ Catalogo -->
    <div class="col-lg-3 d-none d-lg-block">
      <div id="catalogoToggle" class="catalogo-btn mb-3 d-flex position-sticky justify-content-between align-items-center" onclick="toggleCatalogo()">
        <span> Catálogo de Equipos</span>
        <span id="flechaCatalogo">▲</span>
      </div>

      <div id="catalogo" class="position-sticky" style="top: 120px;">
        <div class="card p-3 shadow-sm">
          <table class="table table-striped table-hover" style="cursor: pointer;">
            <thead>
              <tr><th>Equipo</th><th>Precio (Día)</th></tr>
            </thead>
            <tbody id="tablaCatalogo"></tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- MEDIO Formulario -->
    <div class="col-lg-5 col-md-12">
      <div class="card p-4 shadow-sm mb-4">
        <h2 class="mb-4">Cotización de Renta</h2>

        <div class="row mb-3">
          <div class="col-md-6">
            <label>Solicitante:</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
          </div>
          <div class="col-md-6">
            <label>Lugar:</label>
            <asp:TextBox ID="txtLugar" runat="server" CssClass="form-control" />
          </div>
        </div>

        <div class="row mb-4">
          <div class="col-md-6">
            <label for="ddlContacto" class="form-label">
              <i class="fas fa-user-circle form-icon"></i>Contacto Inicial:
            </label>
            <asp:DropDownList ID="ddlContacto" runat="server" CssClass="form-control" AutoPostBack="false">
              <asp:ListItem Text="Selecciona..." Value="" />
              <asp:ListItem Text="Fernando Guzmán" Value="Fernando Guzmán" />
              <asp:ListItem Text="Emiliano Corona" Value="Emiliano Corona" />
            </asp:DropDownList>

            <div id="divComision" style="display:none;" class="mt-2">
              <label for="txtComision"><strong>Comisión (%):</strong></label>
              <asp:TextBox ID="txtComision" runat="server" CssClass="form-control" Text="0" />
              <input type="range" min="0" max="100" value="0" class="form-range"
                oninput="document.getElementById('<%= txtComision.ClientID %>').value = this.value; actualizarVistaPrevia();" />
            </div>
          </div>

          <div class="col-md-6">
            <label for="ddlVendedor"><strong>Vendedor:</strong></label>
            <asp:DropDownList ID="ddlVendedor" runat="server" CssClass="form-control">
              <asp:ListItem Text="Selecciona..." Value="" />
              <asp:ListItem Text="Fernando Guzmán" Value="Fernando Guzmán" />
              <asp:ListItem Text="Emiliano Corona" Value="Emiliano Corona" />
            </asp:DropDownList>
          </div>
        </div>
<div class="card p-3 mb-4">
  <h4>Buscar equipo</h4>
  <input type="text" id="buscador" class="form-control mb-3" placeholder="Buscar equipo..." />

  <ul id="resultados" class="list-group mb-3"></ul>

  <div id="detalleEquipoContainer">
    <h5 id="detalleNombrePrecio" class="mb-3"></h5>
    <label>Fechas:</label>
    <input type="text" id="detalleFecha" class="form-control mb-2" placeholder="Seleccionar fechas" readonly />
    <label>Descuento (%):</label>
    <input type="range" class="form-range" min="0" max="100" value="0" id="detalleDescuento"
      oninput="document.getElementById('detalleLabelDesc').innerText = this.value + '%'; calcularTotalDetalle();" />
    <small id="detalleLabelDesc">0%</small>
    <p class="mt-2">Total estimado: <strong><span id="detalleTotal">0.00</span></strong></p>
    <button class="btn btn-success btn-sm mt-2" type="button" onclick="agregarDesdeDetalle()">Agregar</button>
  </div>
</div>


        <div class="card p-3 mb-4">
          <div class="d-flex justify-content-between align-items-center" style="cursor: pointer;" onclick="toggleCarrito()">
            <h4 class="mb-0">🛒 Carrito de Equipos</h4>
            <span id="iconoCarrito">▼</span>
          </div>
          <div id="contenedorCarrito" class="mt-3">
            <table class="table table-bordered table-modern" id="tablaCarrito">
              <thead>
                <tr><th>Item</th><th>Precio</th><th>Días</th><th>Descuento</th><th>Editar</th><th>Borrar</th></tr>
              </thead>
              <tbody></tbody>
            </table>
            <asp:HiddenField ID="hfCarritoJSON" runat="server" />
          </div>
        </div>

        <div class="mt-3">
          <p><strong>Subtotal:</strong> <asp:Label ID="lblSubtotal" runat="server" Text="$0.00" /></p>
          <p><strong>IVA (16%):</strong> <asp:Label ID="lblIVA" runat="server" Text="$0.00" /></p>
          <p class="fs-5 fw-bold">Total: <asp:Label ID="lblTotal" runat="server" Text="$0.00" /></p>
          <asp:Button ID="btnVaciar" runat="server" Text="Vaciar carrito" CssClass="btn btn-danger mt-2" OnClick="btnVaciar_Click" />
        </div>
      </div>
    </div>

    <!-- DER Vista previa -->
    <div class="col-lg-4 d-none d-lg-block">
      <div class="position-sticky" style="top: 120px;">
        <div class="card p-4 shadow-sm bg-light-gray border-0 vista-previa">
          <h4 class="mb-4 text-dark">
            <i class="fas fa-file-invoice-dollar me-2 text-dark"></i>Vista previa 
          </h4>
          <div class="bg-white p-3 rounded shadow-sm">
            <div class="mb-2"><strong>Solicitante:</strong> <span id="previewNombre"></span></div>
            <div class="mb-2"><strong>Lugar:</strong> <span id="previewLugar"></span></div>
            <div class="mb-2"><strong>Contacto Inicial:</strong> <span id="previewContacto"></span></div>
            <div class="mb-2"><strong>Comisión (%):</strong> <span id="previewComision"></span></div>
            <div class="mb-3"><strong>Vendedor:</strong> <span id="previewVendedor"></span></div>

            <table class="table table-sm table-clean mb-4 style="overflow-x: auto;"">
              <thead>
                <tr><th>Equipo</th><th>Días</th><th>Desc.</th><th>Total</th></tr>
              </thead>
              <tbody id="previewItems"></tbody>
            </table>

            <div class="d-flex justify-content-between mb-1">
              <strong>Subtotal:</strong><strong id="previewSubtotal">$0.00</strong>
            </div>
            <div class="d-flex justify-content-between mb-1">
              <strong>IVA (16%):</strong><strong id="previewIVA">$0.00</strong>
            </div>
            <div class="d-flex justify-content-between fs-5 fw-bold border-top pt-2 mt-2">
              <strong>Total:</strong><strong id="previewTotal">$0.00</strong>
            </div>

            <div class="text-end mt-4">
              <asp:Button ID="btnPDF" runat="server" Text="Descargar PDF" CssClass="btn btn-success rounded-pill px-4 fw-semibold" OnClick="btnPDF_Click" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>


   <asp:HiddenField ID="HiddenField1" runat="server" />
<asp:Label ID="Label1" runat="server" style="display:none;" />
<asp:Label ID="Label2" runat="server" style="display:none;" />
<asp:Label ID="Label3" runat="server" style="display:none;" />
<asp:TextBox ID="TextBox1" runat="server" style="display:none;" />
<asp:TextBox ID="TextBox2" runat="server" style="display:none;" />

</form>
    <script>
        const precios = {
            "Cámara Alexa 35": 23500, "Cámara Alexa Mini LF": 18500, "Cámara Alexa Mini": 12500,
            "Set de Lentes Arri Zeiss": 7125,
            "Zoom Optimo 24-290mm": 7125,
            "Monitor Atmos Neon": 2175,
            "Dana Dolly": 0,
            "Dolly Doorway Matthews": 0,
            "Riel Recto para dolly (8)": 420,
            "Grúa CamMate Travel": 6800,
            "Batería Block VCLX": 1200,
            "Batería Aputure Delta": 2000,
            "Teradek SDI/HD": 2500,
            "Follow Focus inalámbrico": 2800,
            "Cables SDI": 3000,
            "Intercomunicadores": 1500,
            "Móvil Express (solo tramoya)": 4500
        };

        const buscador = document.getElementById("buscador");
        const resultados = document.getElementById("resultados");
        const tabla = document.querySelector("#tablaCarrito tbody");
        const hidden = document.getElementById("<%= hfCarritoJSON.ClientID %>");
        let carrito = [];




        buscador.addEventListener("input", () => {
            resultados.innerHTML = "";
            const query = normalizarTexto(buscador.value.trim());

            if (query === "") {
                document.getElementById("detalleNombrePrecio").innerText = "Selecciona un equipo...";
                return;
            }

            Object.keys(precios).forEach(nombre => {
                if (normalizarTexto(nombre).includes(query)) {
                    const li = document.createElement("li");
                    li.className = "list-group-item resultado-item";
                    li.innerText = `${nombre} - ${formatearMoneda(precios[nombre])}`;

                    li.addEventListener("click", () => {
                        mostrarDetalleEquipo(nombre);

                        document.querySelectorAll(".resultado-item").forEach(el =>
                            el.classList.remove("resultado-seleccionado")
                        );
                        li.classList.add("resultado-seleccionado");

                      resultados.innerHTML = "";
                    }

                    );

                    resultados.appendChild(li);
                }
            }
            );
        }
        );



        function normalizarTexto(texto) {
            return texto
                .normalize("NFD")                  
                .replace(/[\u0300-\u036f]/g, "")   
                .toLowerCase();                    }

        function agregarPorFechas(nombre, precio) {
            const rango = document.getElementById(`rango_${nombre}`).value;
            const desc = parseInt(document.getElementById(`desc_${nombre}`).value) || 0;

            let dias = 0;
            if (rango.includes(" - ")) {
                const [inicio, fin] = rango.split(" - ").map(f => f.split('/').reverse().join('-'));
                const d1 = new Date(inicio);
                const d2 = new Date(fin);
                const diff = (d2 - d1) / (1000 * 60 * 60 * 24);
                dias = diff >= 0 ? diff + 1 : 0;
            } else if (rango) {
                dias = 1;
            }

            if (dias > 0) {
                agregar(nombre, precio, dias, desc);
            }
        }

        function actualizarTotal(nombre) {
            const rango = document.getElementById(`rango_${nombre}`).value;
            const desc = parseInt(document.getElementById(`desc_${nombre}`).value) || 0;
            const base = precios[nombre];

            let dias = 0;
            if (rango.includes(" - ")) {
                const [inicio, fin] = rango.split(" - ").map(f => f.split('/').reverse().join('-'));
                const d1 = new Date(inicio);
                const d2 = new Date(fin);
                const diff = (d2 - d1) / (1000 * 60 * 60 * 24);
                dias = diff >= 0 ? diff + 1 : 0;
            } else if (rango) {
                dias = 1;   }

            const total = (base * dias) * (1 - desc / 100);
            document.getElementById(`label_${nombre}`).innerText = desc + "%";
            document.getElementById(`total_${nombre}`).innerText = total.toFixed(2);
        }
        function mostrarCatalogo() {
            const catalogo = document.getElementById("catalogo");
            const tablaCatalogo = document.getElementById("tablaCatalogo");

            tablaCatalogo.innerHTML = "";
            Object.entries(precios).forEach(([nombre, precioBase]) => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
        <td onclick="mostrarDetalleEquipo('${nombre}')">${nombre}</td>
        <td>${formatearMoneda(precioBase)}</td>
    `;
                tablaCatalogo.appendChild(tr);
            });

            catalogo.style.display = "block";
        }

        function agregar(nombre, precio, cantidad, descuento = 0) {
            cantidad = parseInt(cantidad);
            descuento = parseInt(descuento);
            if (cantidad <= 0) return;
            resultados.innerHTML = "";
            buscador.value = "";
            const existente = carrito.find(i => i.ItemNombre === nombre);
            if (existente) {
                existente.Cantidad += cantidad;
                existente.Descuento = descuento;
            } else {
                carrito.push({ ItemNombre: nombre, Precio: precio, Cantidad: cantidad, Descuento: descuento });
            }
            renderizar();
        }
        function eliminar(index) {
            carrito.splice(index, 1);
            renderizar();
        }

        function editar(index) {
            const item = carrito[index];
            const nuevaFila = `
<tr>
    <td colspan="7">
        <div class="d-flex flex-wrap gap-3 align-items-center">
            <strong>${item.ItemNombre}</strong>
            <span>Precio: ${formatearMoneda(item.Precio)}</span>
            <label>
                Días:
                <input type="number" min="1" value="${item.Cantidad}" id="editDias_${index}" class="form-control form-control-sm" style="width: 80px; display: inline-block;">
            </label>
            <label>
                Descuento:
                <input type="number" min="0" max="100" value="${item.Descuento || 0}" id="editDesc_${index}" class="form-control form-control-sm" style="width: 80px; display: inline-block;"
                    oninput="if (this.value > 100) this.value = 100;">
            </label>
            <button class="btn btn-success btn-sm" onclick="guardarEdicion(${index})">Guardar</button>
            <button class="btn btn-danger btn-sm" onclick="eliminar(${index})">Borrar</button>
        </div>
    </td>
</tr>`;
            tabla.rows[index].innerHTML = nuevaFila;
        }

        function toggleCarrito() {
            const contenedor = document.getElementById("contenedorCarrito");
            const icono = document.getElementById("iconoCarrito");

            if (contenedor.style.display === "none") {
                contenedor.style.display = "block";
                icono.textContent = "▼";
            } else {
                contenedor.style.display = "none";
                icono.textContent = "▲";
            }
        }


        function guardarEdicion(index) {
            const dias = parseInt(document.getElementById(`editDias_${index}`).value);
            const desc = parseInt(document.getElementById(`editDesc_${index}`).value);
            if (dias > 0 && desc >= 0) {
                carrito[index].Cantidad = dias;
                carrito[index].Descuento = desc;
                renderizar();
            }
        }

        function renderizar() {
            tabla.innerHTML = "";
            let subtotal = 0;
            carrito.forEach((item, index) => {
              const total = (item.Precio * item.Cantidad) * (1 - (item.Descuento || 0) / 100);
              subtotal += total;
                tabla.innerHTML += `
        <tr>
            <td>${item.ItemNombre}</td>
            <td>${formatearMoneda(item.Precio)}</td>
            <td>${item.Cantidad}</td>
          <td>${item.Descuento || 0}%</td>
          <td${formatearMoneda(total)}
</td>
            <td><button class="btn btn-editar btn-sm" onclick="editar(${index})">Editar</button></td>
<td>
  <button class="btn btn-danger btn-sm" onclick="eliminar(${index})">
    <i class="fas fa-trash-alt"></i>
  </button>
</td>
        </tr>`;
            });

         const iva = subtotal * 0.16;
         const total = subtotal + iva;
            document.getElementById("<%= lblSubtotal.ClientID %>").innerText = formatearMoneda(subtotal);
            document.getElementById("<%= lblIVA.ClientID %>").innerText = formatearMoneda(iva);
            document.getElementById("<%= lblTotal.ClientID %>").innerText = formatearMoneda(total);

    hidden.value = JSON.stringify(carrito);

    actualizarVistaPrevia();
        } function actualizarVistaPrevia() {
            document.getElementById("previewNombre").textContent = document.getElementById("<%= txtNombre.ClientID %>").value;
    document.getElementById("previewLugar").textContent = document.getElementById("<%= txtLugar.ClientID %>").value;

    const tbody = document.getElementById("previewItems");
    tbody.innerHTML = "";

    let subtotal = 0;
    carrito.forEach(item => {
        const total = item.Precio * item.Cantidad * (1 - (item.Descuento || 0) / 100);
        subtotal += total;
        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>${item.ItemNombre}</td>
            <td>${item.Cantidad}</td>
            <td>${item.Descuento || 0}%</td>
            <td>${formatearMoneda(total)}</td>`;
        tbody.appendChild(tr);
    });

    const contacto = document.getElementById("<%= ddlContacto.ClientID %>").value;
    const vendedor = document.getElementById("<%= ddlVendedor.ClientID %>").value;
            const comision = document.getElementById("<%= txtComision.ClientID %>").value;

            document.getElementById("previewContacto").textContent = contacto;
            document.getElementById("previewVendedor").textContent = vendedor;
            document.getElementById("previewComision").textContent = comision + "%";

            const iva = subtotal * 0.16;
            const totalFinal = subtotal + iva;
            document.getElementById("previewSubtotal").textContent = formatearMoneda(subtotal);
            document.getElementById("previewIVA").textContent = formatearMoneda(iva);
            document.getElementById("previewTotal").textContent = formatearMoneda(totalFinal);
        }


         window.addEventListener("DOMContentLoaded", () => {
            actualizarVistaPrevia();

            const ddlContacto = document.getElementById("<%= ddlContacto.ClientID %>");
            const ddlVendedor = document.getElementById("<%= ddlVendedor.ClientID %>");
            const txtComision = document.getElementById("<%= txtComision.ClientID %>");
    const txtNombre = document.getElementById("<%= txtNombre.ClientID %>");
            const txtLugar = document.getElementById("<%= txtLugar.ClientID %>");
            const divComision = document.getElementById("divComision");
            const slider = document.querySelector("input[type='range']");

            ddlContacto.addEventListener("change", () => {
                divComision.style.display = ddlContacto.value ? "block" : "none";
                if (!ddlContacto.value) {
                    txtComision.value = 0;
                    slider.value = 0;
                }
                actualizarVistaPrevia();
            });

            ddlVendedor.addEventListener("change", actualizarVistaPrevia);
            txtNombre.addEventListener("input", actualizarVistaPrevia);
            txtLugar.addEventListener("input", actualizarVistaPrevia);

            txtComision.addEventListener("input", () => {
                slider.value = txtComision.value;
                actualizarVistaPrevia();
            });

            slider.addEventListener("input", () => {
                txtComision.value = slider.value;
                actualizarVistaPrevia();
            });
        });


        let equipoSeleccionado = null;

        function mostrarDetalleEquipo(nombre) {
            const precio = precios[nombre];
            equipoSeleccionado = { nombre, precio };
            document.getElementById("detalleNombrePrecio").innerText = `${nombre} - ${formatearMoneda(precio)}`;
            document.getElementById("detalleDescuento").value = 0;
            document.getElementById("detalleLabelDesc").innerText = "0%";
            document.getElementById("detalleTotal").innerText = "$0.00";
            document.getElementById("detalleFecha").value = "";

            const inputFecha = document.getElementById("detalleFecha");
            if (!inputFecha.dataset.pickerInit) {
                new Litepicker({
                    element: inputFecha,
                    singleMode: false,
                    numberOfMonths: 1,
                    numberOfColumns: 1,
                    format: 'DD/MM/YYYY',
                    setup: (picker) => {
                        picker.on('selected', () => calcularTotalDetalle());
                    }
                });
                inputFecha.dataset.pickerInit = "true";
            }
        }
        function limpiarVistaPrevia() {
            document.getElementById("previewNombre").textContent = "";
            document.getElementById("previewLugar").textContent = "";
            document.getElementById("previewContacto").textContent = "";
            document.getElementById("previewVendedor").textContent = "";
            document.getElementById("previewComision").textContent = "0%";
            document.getElementById("previewSubtotal").textContent = "$0.00";
            document.getElementById("previewIVA").textContent = "$0.00";
            document.getElementById("previewTotal").textContent = "$0.00";
            document.getElementById("previewItems").innerHTML = "";
        }
        function calcularTotalDetalle() {
            if (!equipoSeleccionado) return;

            const rango = document.getElementById("detalleFecha").value;
            const desc = parseInt(document.getElementById("detalleDescuento").value) || 0;

            let dias = 0;
            if (rango.includes(" - ")) {
                const [inicio, fin] = rango.split(" - ").map(f => f.split('/').reverse().join('-'));
                const d1 = new Date(inicio);
                const d2 = new Date(fin);
                const diff = (d2 - d1) / (1000 * 60 * 60 * 24);
                dias = diff >= 0 ? diff + 1 : 0;
            } else if (rango) {
                dias = 1;
            }

            const total = (equipoSeleccionado.precio * dias) * (1 - desc / 100);
            document.getElementById("detalleTotal").innerText = formatearMoneda(total);
        }

        function agregarDesdeDetalle() {
            if (!equipoSeleccionado) return;

            const rango = document.getElementById("detalleFecha").value;
            const desc = parseInt(document.getElementById("detalleDescuento").value) || 0;

            let dias = 0;
            if (rango.includes(" - ")) {
                const [inicio, fin] = rango.split(" - ").map(f => f.split('/').reverse().join('-'));
                const d1 = new Date(inicio);
                const d2 = new Date(fin);
                const diff = (d2 - d1) / (1000 * 60 * 60 * 24);
                dias = diff >= 0 ? diff + 1 : 0;
            } else if (rango) {
                dias = 1;
            }

            if (dias > 0) {
                agregar(equipoSeleccionado.nombre, equipoSeleccionado.precio, dias, desc);
                equipoSeleccionado = null;
            }
        } function formatearMoneda(valor) {
            return valor.toLocaleString('es-MX', {
                style: 'currency',
                currency: 'MXN'
            });
        }
        function toggleCatalogo() {
            const contenedor = document.getElementById("catalogo");
            const flecha = document.getElementById("flechaCatalogo");

            if (contenedor.style.display === "none") {
                contenedor.style.display = "block";
                flecha.textContent = "▲";
            } else {
                contenedor.style.display = "none";
                flecha.textContent = "▼";
            }
        }


        document.addEventListener("DOMContentLoaded", () => {
            const tablaCatalogo = document.getElementById("tablaCatalogo");
            tablaCatalogo.innerHTML = ""; 

            Object.entries(precios).forEach(([nombre, precioBase]) => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
      <td style="cursor:pointer;" onclick="mostrarDetalleEquipo('${nombre}')">${nombre}</td>
      <td>${formatearMoneda(precioBase)}</td>
    `;
                tablaCatalogo.appendChild(tr);
            });

            document.getElementById("catalogo").style.display = "block";
        });

    </script>
</body>
</html>