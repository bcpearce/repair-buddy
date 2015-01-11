$(document).ready(function() {

  //check input to the vin text and enable the submit
  //once the number of characters equals 17
  $('input#vin').keyup(function() {
    if ($(this).val().length === 17) {
      $('#submit-vin').removeAttr("disabled");
    }
    else {
      $('#submit-vin').attr("disabled", "disabled");
    }
  });

  //enable the make selector after choosing a year
  $('select#year').change(function() {
    $makeSelect = $('select#make');
    if (/^\d{4}$/.test($(this).val())) {
      $makeSelect.removeAttr("disabled");
      $('select#make option:gt(0)').remove();
      var year = $('select#year').val();
      /*
      var newOptions = $.ajax({
        dataType: 'json',
        url: "/edmunds_makes",
        data: ('year=' + year)
      });*/
      $.getJSON(
        "/edmunds_makes.json?year="+year,
        function(data) {
          $.each(data, function(key,value) {
            $makeSelect.append($("<option></option>").attr("value", value).text(value));
          });
        });
    }
    else {
      $makeSelect.attr("disabled", "disabled");
    }
  });

});
