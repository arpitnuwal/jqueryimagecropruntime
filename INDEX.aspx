<%@ Page Language="C#" AutoEventWireup="true" CodeFile="INDEX.aspx.cs" Inherits="INDEX" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="Css/jquery.cropbox.css" />
    <script type="text/javascript" src="Script/jquery.cropbox.js"></script>
    <style type="text/css">
        div.cropbox .btn-file
        {
            position: relative;
            overflow: hidden;
        }
        div.cropbox .btn-file input[type=file]
        {
            position: absolute;
            top: 0;
            right: 0;
            min-width: 100%;
            min-height: 100%;
            font-size: 100px;
            text-align: right;
            filter: alpha(opacity=0);
            opacity: 0;
            outline: none;
            background: white;
            cursor: inherit;
            display: block;
        }
        div.cropbox .cropped
        {
            margin-top: 10px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $('input[type=file]').change(function () {
                $('#hfImageName').val($(this).prop("files")['0'].name);
            });
            $('#plugin').cropbox({
                selectors:
                {
                    inputInfo: '#plugin textarea.data',
                    inputFile: '#plugin input[type="file"]',
                    btnCrop: '#plugin .btn-crop',
                    btnReset: '#plugin .btn-reset',
                    resultContainer: '#plugin .cropped .panel-body',
                    messageBlock: '#message'
                },
                imageOptions: { class: 'img-thumbnail', style: 'margin-right: 5px; margin-bottom: 5px' },
                variants: [
                              { width: 200, height: 200, minWidth: 180, minHeight: 200, maxWidth: 350, maxHeight: 350 },
                              { width: 150, height: 200 }
                          ]
                , messages: ['Crop a middle image.', 'Crop a small image.']
            });

            $('#btnSave').on("click", function () {
                var image = $('.panel-body').html();
                var byteData = $(image).attr('src');
                byteData = byteData.split(';')[1].replace("base64,", "");
                $.ajax({
                    type: "POST",
                    url: "CS.aspx/InsertImage",
                    data: '{byteData: "' + byteData + '", imageName: "' + $('#hfImageName').val() + '" }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        alert(response.d);
                    },
                    error: function (response) {
                        alert(response.d);
                    }
                });
                return false;
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="message" class="alert alert-info">
        </div>
        <div id="plugin" class="cropbox">
            <div class="workarea-cropbox">
                <div class="bg-cropbox">
                    <img class="image-cropbox">
                    <div class="membrane-cropbox">
                    </div>
                </div>
                <div class="frame-cropbox">
                    <div class="resize-cropbox">
                    </div>
                </div>
            </div>
            <div class="btn-group">
                <span class="btn btn-primary btn-file"><i class="glyphicon glyphicon-folder-open"></i>
                    Browse
                    <input type="file" accept="image/*">
                </span>
                <button type="button" class="btn btn-success btn-crop" disabled="">
                    <i class="glyphicon glyphicon-scissors"></i>Crop
                </button>
                <button type="button" class="btn btn-warning btn-reset">
                    <i class="glyphicon glyphicon-repeat"></i>Reset
                </button>
            </div>
            <div class="cropped panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        Result of cropping</h3>
                </div>
                <div class="panel-body">
                    ...</div>
            </div>
            <div class="form-group">
                <label>
                    Info of cropping</label>
                <textarea class="data form-control" rows="5"></textarea>
            </div>
        </div>
    </div>
    <input type="hidden" name="hfImageName" id="hfImageName" />
    <asp:Button ID="btnSave" Text="Save" runat="server" />
    </form>
</body>
</html>
