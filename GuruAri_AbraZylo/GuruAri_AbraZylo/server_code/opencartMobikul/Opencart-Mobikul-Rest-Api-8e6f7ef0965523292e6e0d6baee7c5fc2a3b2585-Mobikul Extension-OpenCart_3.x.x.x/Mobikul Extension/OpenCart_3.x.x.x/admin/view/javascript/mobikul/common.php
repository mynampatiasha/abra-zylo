<?php
$token = $_GET['token'];
header("Content-Type: application/javascript");

?>


var inner_count = 0;
var addSortable = function(type,text,value,messageStatus){
$('#sortable').append('<li class="inner-list" id="' + value + '" data-id="'+ inner_count +'" type="' + type + '"><a class="list-group-item"><span class="ui-icon ui-icon-arrowthick-2-n-s">'+ text +'</span><i class="fa fa-trash list-trash" data-id="inner_'+ inner_count +'" onClick="removeComponent(this)"></i></a></li>');

if(typeof window["add" + type] == "function") {
  $('.mobile-content').append(window["add" + type](inner_count,type));
  if(messageStatus)
  saveHomeSequence('Component added');
}
if( type.substr(0, 6) == 'banner'){
  $('.mobile-content').append(window['addBannerSection'](inner_count,type,value,text)  );
  if(messageStatus)
  saveHomeSequence('Component added');
}
if( type.substr(0, 8) == 'carousel'){
  $('.mobile-content').append(window['addCarouselSection'](inner_count,type,value,text) );
  if(messageStatus)
  saveHomeSequence('Component added');
}
  
inner_count++;
};

var addBannerSection = function(count,type,value,title){
return `<div class="home-box" id="inner_${count}">
      <div style="width: 100%;">

              <div style="   
                  float: left;   
                  position: relative;
                  margin: 10px 0px 0px 10px;
                  color: black;
                          ">
                           ${title}
              </div>
              <div><img  class="home_image" src="../image/mobikul/banner.png"></div>
      </div>


     
      <input type="hidden" name="mobikulhome_sequence[]" value="${type}" />
  </div>

</div>`;

};


var addCarouselSection = function(count,type,value,title){

if(value==''){
  value = 'best';
}
if(value =='image_catagory') {
  value = 'best';
} 

  if( value == 'best' ||
      value == 'popular' ||
      value == 'latest' ||
      value == 'special_products' ||
      value == 'discounted_products' ||
      value == 'random_product' ||
      value == 'manufacturer' ||
      value == 'manufacturer_products' ||
      value == 'catagories' ||
      value == 'catagory_products'
         
  ){
   
    return `<div class="home-box" id="inner_${count}">
      <div style="width: 100%;">

              <div style="   
                  float: left;   
                  position: relative;
                  margin: 10px 0px 0px 10px;
                  color: black;
                          ">
                           ${title}
              </div>
              <div><img style="margin-right: -114px;" class="home_image" src="../image/mobikul/view_all.png"></div>
      </div>


      <div id="container" class="test">  
       
      <?php

     
        for ($i=0; $i <  $_GET['product_homecount']; $i++) {  ?>
            <div class="product-box">
                <div class="product"> 
                      <div class="label">  Product <?php echo $i+1 ; ?> </div> 
                </div>
            </div>
          <?php } ?>
          
      </div>
      <input type="hidden" name="mobikulhome_sequence[]" value="${type}" />
  </div>

</div>`;
  }else if ( value == 'image_carousel'){
    return `<div class="home-box" id="inner_${count}">
      <div style="width: 100%;">

              <div style="   
                  float: left;   
                  position: relative;
                  margin: 10px 0px 0px 10px;
                  color: black;
                          ">
                           ${title}
              </div>
              <div><img  class="home_image" src="../image/mobikul/banner.png"></div>
      </div>


     
      <input type="hidden" name="mobikulhome_sequence[]" value="${type}" />
  </div>

</div>`;
  }else if ( value == 'image_all_parrent_category'){
    return `<div class="home-box" id="inner_${count}">
      <div style="width: 100%;">

              <div style="   
                  float: left;   
                  position: relative;
                  margin: 10px 0px 0px 10px;
                  color: black;
                          ">
                           ${title}
              </div>
              <div><img  class="home_image" src="../image/mobikul/category.png"></div>
      </div>


     
      <input type="hidden" name="mobikulhome_sequence[]" value="${type}" />
  </div>

</div>`;
  }else if ( value == 'image_manufacturer'){
    return `<div class="home-box" id="inner_${count}">
    <div style="width: 100%;">

    <div style="   
        float: left;   
        position: relative;
        margin: 10px 0px 0px 10px;
        color: black;
                ">
                ${title}
    </div>
       <div><img style="margin-right: -114px;" class="home_image" src="../image/mobikul/view_all.png"></div>
       <div><img  class="home_image" src="../image/mobikul/carousel.png"></div>
    </div>

     
      <input type="hidden" name="mobikulhome_sequence[]" value="${type}" />
  </div>

</div>`;
  }

};




var addrecently = function(count,type){
return '<div class="home-box" id="inner_' + count + '"><img class="home_image" src="../image/mobikul/recently.png"><input type="hidden" name="mobikulhome_sequence[]" value="'+type+'" /></div>';
};

var addpartners = function(count,type){
return '<div class="home-box" id="inner_' + count + '"><img class="home_image" src="../image/mobikul/partners.png"><input type="hidden" name="mobikulhome_sequence[]" value="'+type+'" /></div>';
};

$(function() {
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
});

$('#sortable').sortable({
    start: function(event, ui) {
        ui.item.data('start_pos', ui.item.index());
    },
    stop: function(event, ui) {
        var start_pos = ui.item.data('start_pos');
        if (start_pos != ui.item.index()) {
          $('.mobile-content').html('');
          var sequence = [];
          $('.inner-list').each(function(index,item){
         
            var type = $(item).attr('type');
            sequence.push(type);
            var count = $(item).data('id'); 
            var value = item.id;  
            if(typeof window["add" + type] == "function") {
              $('.mobile-content').append(window["add" + type](count,type));
            }
    
            if( type.substr(0, 6) == 'banner'){ 
              $('.mobile-content').append(window['addBannerSection'](count,type));              
            }
            if( type.substr(0, 8) == 'carousel'){            
              $('.mobile-content').append(window['addCarouselSection'](count,type,value));              
            }

          });
          saveHomeSequence('Component sequence changed');
        }
    }
});

var displayMessage = function(message) {
  var cont = Math.random().toString(36).substring(4);
  $('#message-cont').append('<div class="message" id="'+cont+'">'+message+'</div>');
  $('#'+cont).fadeOut(3000, function(){ $(this).remove();});
};

$(".addsortable").on('click',function(){
  scrollComponent($('.mobile-content'),$(".home-box").last());
});

var scrollComponent = function($container, $scrollTo) {
  $($container).animate({
    scrollTop: $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
  }, 500);
};

var removeComponent = function(current){
   $('#'+$(current).data('id')).remove();
  $(current).parent().parent().remove();
  saveHomeSequence('Component deleted');
};

var saveHomeSequence = function(message){
  $.post("index.php?route=extension/module/mobikul/saveHomeSequence&user_token=<?php echo $token; ?>",{mobikulhome_sequence: $('input[name="mobikulhome_sequence[]"]').map(function () {return this.value;}).get()}, function() {
    displayMessage(message);
  });
};





