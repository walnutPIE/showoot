// Dom7
var $$ = Dom7;
// Init App
var app = new Framework7({
  id: 'com.showoot',
  root: '#app',
  theme: 'md',
  init: false,
  cacheDuration: 0,
  cache: false,
  view: {
    // 여러 페이지를 캐시해서 뒤로가기가 여러 depth에서도 동작하게 하려면 필요한 옵션
    stackPages: true,
    pushState: true
  },
  routes: routes,
});

/////////////////////커스터마이징 캘린더
function customizingCalendar(){
  var monthNames=['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  var today = new Date();
  var calendarInline = app.calendar.create({
    containerEl: '#demo-calendar-inline-container',
    value: [today],
    events: [
      new Date(2018, 11, 1),
      new Date(2018, 11, 5),
      new Date(2018, 11, 8),
      new Date(2018, 11, 11),
      new Date(2018, 11, 20)
    ],
    weekHeader: true,
    renderToolbar: function () {
      return '<div class="toolbar calendar-custom-toolbar no-shadow">' +
        '<div class="toolbar-inner">' +
          '<div class="left">' +
            '<a href="#" class="link icon-only"><i class="icon icon-back ' + (app.theme === 'md' ? 'color-black' : '') + '"></i></a>' +
          '</div>' +
          '<div class="center"></div>' +
          '<div class="right">' +
            '<a href="#" class="link icon-only"><i class="icon icon-forward ' + (app.theme === 'md' ? 'color-black' : '') + '"></i></a>' +
          '</div>' +
        '</div>' +
      '</div>';
    },
    on: {
      init: function (c) {
        $$('.calendar-custom-toolbar .center').text(monthNames[c.currentMonth] +', ' + c.currentYear);
        $$('.calendar-custom-toolbar .left .link').on('click', function () {
          calendarInline.prevMonth();
        });
        $$('.calendar-custom-toolbar .right .link').on('click', function () {
          calendarInline.nextMonth();
        });
      },
      monthYearChangeStart: function (c) {
        $$('.calendar-custom-toolbar .center').text(monthNames[c.currentMonth] +', ' + c.currentYear);
      },
      dayClick: function(calendar, dayEl, year, month, day){
        var date = year + "-" + (parseInt(month)+1) + "-" + day;
        //app.router.navigate('/diary/pick_date?date=' + date);
        // app.request.get('/diary/pick_date.js',{ picked_date:date, }, function (data) {
        //
        // });
        $('#new_post').attr("href", "/diary/new_post?picked_date=" + date)
        $.ajax({
          type: 'GET',
          url: '/diary/pick_date',
          data: { picked_date: date },
          dataType : 'script'
        });
      }
    }
  });
}

$$(document).on("page:init", ".page[data-name='home-index']", function() {
  customizingCalendar();
});
$$(document).on("page:init", ".page[data-name='diary-index_post']", function() {
  customizingCalendar();
});
$$(document).on("page:init", ".page[data-name='diary-edit_post']", function() {
  var clothesInfo = [];
  var clothInfo = {};
  var selected_cloth;
  var selected_color;

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
         $('#image_upload').attr('src', e.target.result);
       };
       reader.readAsDataURL(input.files[0]);
     }
   }
   // Create dynamic Popover
    var dynamicPopover = app.popover.create({
      targetEl: 'a.dynamic-popover',
      content: '<div class="popover" style="margin:0 auto;">'+
                  '<div class="popover-inner">'+
                    '<div class="block">'+
                      '<p>색깔을 선택해주세요</p>'+
                      '<p><a href="#" id="color" class="link popover-close">빨강</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">노랑</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">녹색</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">파랑</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">보라</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">주황</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">연두</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">청록</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">군청</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">자주</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">흰색</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">회색</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">검정</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">분홍</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">하늘</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">브라운</a></p>'+
                    '</div>'+
                  '</div>'+
                '</div>',
      // Events
      on: {
        open: function (popover) {
          console.log(popover);
        },
        opened: function (popover) {
          //색깔 정해서 rails hidden_field에 value 넣기
          var elements = document.getElementsByClassName('popover-close');
          for (var i = 0, len = elements.length; i < len; i++) {
            elements[i].addEventListener("click", function(e) {
              console.log(e.target.innerText);
              selected_color = e.target.innerText;
            });
          }
          // $('#color').on('click', function(e){
          //   console.log(e.target.innerText);
          //   selected_color = e.target.innerText;
          // });
        },
        closed: function(popover){
          cloth_info = {main: selected_cloth.split("_")[0] ,sub: selected_cloth.split("_")[1], color: selected_color };
          clothesInfo.push( cloth_info );
        }
      }
    });

   $('input').on('change', function(){
     readURL(this);
   });

   $('#category_select_btn').on('click', function(){
     //console.log(clothesInfo);
     //여기서 hidden_field에 옷 정보 넘겨주기
     document.getElementById('clothes_info').value = JSON.stringify(clothesInfo);
     console.log(document.getElementById('clothes_info').value);
   });

   $$('input[type="radio"]').on('change click', function(ev){
    selected_cloth = $$(ev.currentTarget).val();
     console.log(selected_cloth);
     dynamicPopover.open();
   });
});
$$(document).on("page:init", ".page[data-name='diary-new_post']", function() {
  var clothesInfo = [];
  var clothInfo = {};
  var selected_cloth;
  var selected_color;

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
         $('#image_upload').attr('src', e.target.result);
       };
       reader.readAsDataURL(input.files[0]);
     }
   }
   // Create dynamic Popover
    var dynamicPopover = app.popover.create({
      targetEl: 'a.dynamic-popover',
      content: '<div class="popover" style="margin:0 auto;">'+
                  '<div class="popover-inner">'+
                    '<div class="block">'+
                      '<p>색깔을 선택해주세요</p>'+
                      '<p><a href="#" id="color" class="link popover-close">빨강</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">노랑</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">녹색</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">파랑</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">보라</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">주황</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">연두</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">청록</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">군청</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">자주</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">흰색</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">회색</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">검정</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">분홍</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">하늘</a></p>'+
                      '<p><a href="#" id="color" class="link popover-close">브라운</a></p>'+
                    '</div>'+
                  '</div>'+
                '</div>',
      // Events
      on: {
        open: function (popover) {
          console.log(popover);
        },
        opened: function (popover) {
          //색깔 정해서 rails hidden_field에 value 넣기
          var elements = document.getElementsByClassName('popover-close');
          for (var i = 0, len = elements.length; i < len; i++) {
            elements[i].addEventListener("click", function(e) {
              console.log(e.target.innerText);
              selected_color = e.target.innerText;
            });
          }
          // $('#color').on('click', function(e){
          //   console.log(e.target.innerText);
          //   selected_color = e.target.innerText;
          // });
        },
        closed: function(popover){
          cloth_info = {main: selected_cloth.split("_")[0] ,sub: selected_cloth.split("_")[1], color: selected_color };
          clothesInfo.push( cloth_info );
        }
      }
    });

   $('input').on('change', function(){
     readURL(this);
   });

   $('#category_select_btn').on('click', function(){
     //console.log(clothesInfo);
     //여기서 hidden_field에 옷 정보 넘겨주기
     document.getElementById('clothes_info').value = JSON.stringify(clothesInfo);
     console.log(document.getElementById('clothes_info').value);
   });

   $$('input[type="radio"]').on('change click', function(ev){
    selected_cloth = $$(ev.currentTarget).val();
     console.log(selected_cloth);
     dynamicPopover.open();
   });
});
$$(document).on("page:init", ".page[data-name='mypage-index']", function() {
  var allowInfinite = true;
  var lastItemIndex = $$('.list li').length; //card-container의 자식 개수
  var maxItems = 200;
  var itemsPerLoad = 20;

  $$('.infinite-scroll-content').on('infinite', function () {
    if (!allowInfinite) return;
    // Set loading flag
    allowInfinite = false;

    // Emulate 1s loading
    setTimeout(function () {
      // Reset loading flag
      allowInfinite = true;

      //다 로드한 경우
      if (lastItemIndex >= maxItems){
        app.infiniteScroll.destroy('.infinite-scroll-content');
        $$('.infinite-scroll-preloader').remove();
        return;
      }

      // Generate new items HTML
      var html = '';
      for (var i = lastItemIndex + 1; i <= lastItemIndex + itemsPerLoad; i++) {
        html += '<li>Item ' + i + '</li>'; // 여기에 div id잡아서 가져오기
      }
      // Append new items
      $$('.list ul').append(html);

      // Update last loaded index
      lastItemIndex = $$('.list li').length;
    }, 1000);
  });
});

app.init();
