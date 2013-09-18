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
  $(".addAvatar").click(function(e){
    e.preventDefault();
    index = $(this).data("index");
    length = $(this).parent().find('input').length;
    child = $(this).parent().find('.child-controls');
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
    parent = $(this).parent().parent().parent();
    length = parent.find('.parent-controls').find('input').length;
    child = parent.find('.parent-controls').find('.child-controls');
    avatar_link = parent.find('.parent-controls').find('.addAvatar');
    if(text == 1)
    {
      $.ajax ({
        url:  '/reports/file_field',
        data: {index: index, length: length },
        success: function(data)
        {
          child.append(data);
          avatar_link.show();
        }
      });
    }
    else
    if(text == 0)
    {
      child.html("");
      avatar_link.hide();
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