$('document').ready(function(){

  $('.datepicker').datepicker();
  $('.tree-toggle').click(function () {
    $(this).parent().children('ul.tree').toggle(200);
  });
  $('select').selectpicker();
  if($('.form-validate').length > 0)
  {
    $('.form-validate').each(function(){
      var id = $(this).attr('id');
      $("#"+id).validate({
        errorElement:'span',
        errorClass: 'help-block error',
        errorPlacement:function(error, element){
          element.parents('.controls').append(error);
        },
        highlight: function(label) {
          $(label).closest('.control-group').removeClass('error success').addClass('error');
        },
        success: function(label) {
          label.addClass('valid').closest('.control-group').removeClass('error success').addClass('success');
        }
      });
    });
  } 
  $(".add_more_link").click(function(e){
    e.preventDefault();
    index = $(this).data("index");
    length = $(this).parent().find('input').length;
    child = $(this).parent().find('.avatar-fields');
    $.ajax ({
        url:  '/reports/file_field',
        data: {index: index, length: length },
        success: function(data)
        {
          child.append(data);
        }
    });
  });

  $(".radio-controls label input").change(function(e){

    e.preventDefault();

    text = $(this).val();
    index = $(this).parent().data('index');
  
    parent = $(this).parent().parent().find(".avatar-fields")
    avatar_link = $(this).parent().parent().find('.parent-avatar-field').find('.add_more_link');
    length = parent.find('input').length;
    if(text == 1)
    {
      $.ajax ({
        url:  '/reports/file_field',
        data: {index: index, length: length },
        success: function(data)
        {
          parent.append(data);
          avatar_link.show();
        }
      });
    }
    else
    if(text == 0)
    {
      parent.html("");
      avatar_link.hide();
    }

  });

  $(".edit_add_more_link").click(function(e){
    e.preventDefault();
    index = $(this).data("index");
    parent = $(this).parent().find('.avatar-fields').find('input').length;
    child = $(this).parent().find('.add-more-avatar');
    length = parent + child.find("input").length;
    $.ajax ({
        url:  '/reports/file_field',
        data: {index: index, length: length },
        success: function(data)
        {
          child.append(data);
        }
    });
  });


  $(".radio-controls-edit label input").change(function(e){
    
    e.preventDefault();

    text = $(this).val();
    index = $(this).parent().data('index');

    contents_1 = $(this).parent().parent().find(".image-field");

    contents_2 = $(this).parent().parent().find(".add-more-avatar");

    avatar_link = $(this).parent().parent().find('.edit_add_more_link');

  
    
    
    length = 0;
    if(text == 1)
    {
      $.ajax ({
        url:  '/reports/file_field',
        data: {index: index, length: length },
        success: function(data)
        {
          contents_2.append(data);
          avatar_link.show();
        }
      });
    }
    else
    if(text == 0)
    {
      id =$(this).parent().data("id");
      console.log(id);
      $.ajax ({
        url:  '/reports/remove_report_line',
        data: {id: id},
        success: function(data)
        {
          contents_1.html("");
          contents_2.html("");
          avatar_link.hide();
        }
      });
      
    }

  });

  
});

  function onLoadDoc(div,unit,report_of) {
    chart1 = new cfx.Chart();chart1.getAnimations().getLoad().setEnabled(true);
    chart1.setGallery(cfx.Gallery.Bar);
    
    chart1.getDataGrid().setVisible(true);
    chart1.getLegendBox().setVisible(false);
        
        
    doTitle(chart1, "Report");
    doDataPopulation(unit,report_of);
    
    var allSeries = chart1.getAllSeries();
    allSeries.setMarkerShape(cfx.MarkerShape.Rect);
        var chartDiv = div[0];
        chart1.create(chartDiv);

  }

  //Chart title settings
  function doTitle(chart, text) {
      var td;
      td = new cfx.TitleDockable();
      td.setText(text);
      td.setDock(cfx.DockArea.Top);
      chart.getTitles().add(td);
  }

  //Main Chart Data Information
  function doDataPopulation(unit,report_of) {
      if(report_of=="Brand")
        var data1 = $('#'+unit +' .' + unit).val().split("~");
      else
        var data1 = $('#category_'+unit +' .' + unit).val().split("~");
      var items = [];
      for(i=0;i<data1.length;i++){
        temp = data1[i].trim().split("|");
        temp1 = {
        report_of: temp[0],
            "Quantity": parseInt(temp[1])
        };
        items.push(temp1);
      }
      chart1.setDataSource(items);
  }

  function showResponse(responseText, statusText, xhr, $form)  {
    if(($form.data('unit')+"")=="display_data"){
      $('.display_data_chart').html('');
      $('.display_data_chart').html(responseText);
    }
    if(($form.data('unit')+"")=="sales_data"){
      $('.sales_data_chart').html('');
      $('.sales_data_chart').html(responseText);
    }
    if(($form.data('unit')+"")=="corner_data"){
      $('.corner_data_chart').html('');
      $('.corner_data_chart').html(responseText);
    }
  } 

  function showCatResponse(responseText, statusText, xhr, $form)  {
    if(($form.data('unit')+"")=="display_data"){
      $('.display_category_data_chart').html('');
      $('.display_category_data_chart').html(responseText);
    }
    if(($form.data('unit')+"")=="sales_data"){
      $('.sales_category_data_chart').html('');
      $('.sales_category_data_chart').html(responseText);
    }
    if(($form.data('unit')+"")=="corner_data"){
      $('.corner_category_data_chart').html('');
      $('.corner_category_data_chart').html(responseText);
    }
  } 