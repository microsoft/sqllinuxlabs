ROOT_API_URL = "/api/Product/";

$(document).ready(function () {

    // DataTable setup
    /*$('#example').DataTable({
        "ajax": {url:ROOT_API_URL,
        error: function(jqXHR, textStatus, errorThrown) {
            //Catch the error and log it to the console but not show it in browser
            console.log('There was an ajax error with the DataTable');
        }},
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
    });// end DataTable setup */
   $.ajax({
        url: "/api/Product",
        error: function(jqXHR, textStatus, errorThrown) {
            //Catch the error and log to console
            console.log('There was an AjaxError on getting the ServerName and VersionName');
            $('#SQL-Server-version').append("CTP 2.1");
            $('#SQL-Server-servername').append("sql-1");
        }}).then(function(data){
        //console.log(data)
        data = $.parseJSON(data);
        //console.log(data.data[0].Version);
        $('#SQL-Server-version').append(data.data[0].Version);
        $('#SQL-Server-servername').append(data.data[0].ServerName);
    })
    
});

