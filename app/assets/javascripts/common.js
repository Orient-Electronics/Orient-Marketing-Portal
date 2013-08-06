$('document').ready(function(){

  $('.datepicker').datepicker();
  $('.tree-toggle').click(function () {
    $(this).parent().children('ul.tree').toggle(200);
  });
});
