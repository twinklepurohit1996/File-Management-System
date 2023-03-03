<cfoutput>
   <script>
    Dropzone.options.myGreatDropzone = { // camelized version of the `id`
        paramName: "file", // The name that will be used to transfer the file
        chunking: true,
        timeout:120000, // microseconds
        maxFilesize: 3072, // 3 gigabytes
        chunkSize: 1000000, // bytes
        dictDefaultMessage: "Click text to upload or drag and drop your files.",
        sending: function(file, xhr, formData) {
            formData.append("fileFullName", file.name);
            formData.append("fileSize", file.size);
        },
        autoProcessQueue: true,
        parallelUploads: 1,
        success: function(file, response) {
            if (response.success) {
                $('##alert').removeClass('d-none').addClass('show');
                $('##alert').html(response.message + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>');
            } else {
                $('##alert').removeClass('d-none').addClass('show');
                $('##alert').removeClass('alert-success').addClass('alert-danger');
                $('##alert').html(response.message + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>');
            }
        }
    };
    </script>
</cfoutput>