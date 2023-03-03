<cfoutput>
    <script type="text/javascript" language="JavaScript">
        var #toScript(event.buildLink('FileManager.createDirectory'), "addFolderURL")#;
        var #toScript(event.buildLink('FileManager.index'), "indexPageURL")#;
        var #toScript(event.buildLink('FileManager.delete'), "deletePageURL")#;
        var #toScript(event.buildLink('FileManager.editDirectory'), "editPageURL")#;
    </script>
    <script type="text/javascript" language="JavaScript">
        $(document).ready(function(){
            $("##exampleModal").on("hidden.bs.modal", function () {
                $("##name").val('');
            });
            $("##exampleModal").on("show.bs.modal", function () {
                $('##exampleModalLabel').html("Create Folder");
                $('##nameLabel').html("Create Folder");
                $('##submit').html("Create Folder");
                $('##alert').removeClass('show').addClass('d-none');
                $('##editId').remove();
                $('##name').removeClass('is-invalid').removeClass('is-valid');
            });
            $.validator.addMethod("alpha", function(value, element) {
                return this.optional(element) || value == value.match(/^[a-zA-Z0-9\s]+$/);
            }, "Only Alphanumeric values allowed.");
            $("##createFolder").validate({
                rules: {
                    name : {
                        required: true,
                        alpha: true
                    }
                },
                messages : {
                    name: {
                        required: "Please enter a Folder name.",
                    }
                },
                errorElement: "div",
                    errorPlacement: function ( error, element ) {
                        error.addClass( "invalid-feedback" );
                        error.insertAfter( element );
                    },
                highlight: function(element) {
                    $(element).removeClass('is-valid').addClass('is-invalid');
                },
                unhighlight: function(element) {
                    $(element).removeClass('is-invalid').addClass('is-valid');
                },
                submitHandler: function(form) {
                    if (form.editId) {
                        $.ajax({
                            type: "POST",
                            url: editPageURL,
                            data: $("##createFolder").serialize(),
                            success: function(data) {
                                if (data.success) {
                                    $('##name').val('');
                                    $('##exampleModal').modal('hide');
                                    location.href = indexPageURL + "?directory=" + data.parentId;
                                } else {
                                    $('##alert').removeClass('d-none').addClass('show');
                                    $('##alert').html(data.message + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>');
                                }
                            },
                        });
                    } else {
                        $.ajax({
                            type: "POST",
                            url: addFolderURL,
                            data: $("##createFolder").serialize(),
                            success: function(data) {
                                if (data.success) {
                                    $('##name').val('');
                                    $('##exampleModal').modal('hide');
                                    location.href = indexPageURL + "?directory=" + data.parentId;
                                } else {
                                    $('##alert').removeClass('d-none').addClass('show');
                                    $('##alert').html(data.message + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>');
                                    $('##name').removeClass('is-invalid').removeClass('is-valid');
                                }
                            }
                        });
                    }
                }
            });
            $(".delete").click(function() {
                let confirmation = confirm("Do you want to delete this file");
                if (confirmation) {
                    let id = $(this).attr("data-id");
                    let name = $(this).attr("data-name");
                    let isdir = $(this).attr("data-dir");
                    let parentId = $(this).attr("data-parentID");
                    location.href = deletePageURL + "?directory=" + id + "&name=" + name + "&isdir=" + isdir + "&parentId=" + parentId;
                } else {
                    return;
                }
            });
            $(".edit").click(function() {
                $('##exampleModal').modal('show');
                $('##exampleModalLabel').html("Update Folder");
                $('##nameLabel').html("Update Folder");
                $('##submit').html("Update Folder");
                let id = $(this).attr("data-id");
                let name = $(this).attr("data-name");
                $('##name').val(name);
                $('##createFolderDiv').append('<input type="hidden" name="editId" id="editId" value="' + id + '">');
            });
            $(".move").click(function () {
                let id = $(this).attr("data-id");
                let iddir = $(this).attr("data-dirID");
                $("##fileId").val(id);
                $("##dirId").val(iddir);
            });
        });
    </script>
</cfoutput>