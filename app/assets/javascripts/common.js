$('document').ready(function(){

  $('.datepicker').datepicker();
  $('.tree-toggle').click(function () {
    $(this).parent().children('ul.tree').toggle(200);
  });
  $('select').selectpicker();
});

  function onLoadDoc(div,unit) {
    chart1 = new cfx.Chart();chart1.getAnimations().getLoad().setEnabled(true);
    chart1.setGallery(cfx.Gallery.Bar);
    
    chart1.getDataGrid().setVisible(true);
    chart1.getLegendBox().setVisible(false);
        
        
    doTitle(chart1, "Report");
    doDataPopulation(unit);
    
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
  function doDataPopulation(unit) {
      var data1 = $('.' + unit).val().split("~");
      var items = [];
      for(i=0;i<data1.length;i++){
        temp = data1[i].trim().split("|");
        temp1 = {
        "Brand": temp[0],
            "Quantity": parseInt(temp[1])
        };
        items.push(temp1);
      }
      chart1.setDataSource(items);
  }