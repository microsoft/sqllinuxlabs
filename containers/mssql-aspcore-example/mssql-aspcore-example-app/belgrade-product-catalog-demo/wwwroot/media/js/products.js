ROOT_API_URL = "/api/Product/";

$(document).ready(function () {

    // DataTable setup
    $('#example').DataTable({
        "ajax": ROOT_API_URL,
        "columns": [
            { "data": "Name" },
            { "data": "Color", "defaultContent": "" },
            { "data": "Price", sType: 'numeric', "defaultContent": "" },
            { "data": "Quantity", "visible": true, "defaultContent": "" },
            { "data": "MadeIn", "visible": true, "defaultContent": "" },
            { "data": "Tags", "visible": true, "defaultContent": "" },
            {
                "data": "ProductID",
                "sortable": false,
                "searchable": false,
                "render": function (data) {
                    return '<button data-id="' + data + '" class="btn btn-primary btn-sm edit" data-toggle="modal" data-target="#modalEditProduct"><span class="glyphicon glyphicon-edit"></span> Edit</button>';
                }
            },
            {
                "data": "ProductID",
                "sortable": false,
                "searchable": false,
                "render": function (data) {
                    return '<button data-id="' + data + '" class="btn btn-danger btn-sm delete"><span class="glyphicon glyphicon-remove"></span> Delete</button>';
                }
            }
        ]
    });// end DataTable setup

});