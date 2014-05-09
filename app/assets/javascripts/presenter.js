$(document).ready(function(){
		$('.samplesnav a').click(function(){
			OnThumbClick(this);
		});
		$('.togglearrow').click(function(){
			ToggleCodeRegion();
		});
		$('.navpills li').click(function(){
			var opentab = $(this).find('a').attr('class');
			$('.navpills li.active').removeClass('active');
			$(this).addClass('active');
			$('.tabscontent li').removeClass('active');
			$('.tabscontent li.' + opentab).addClass('active');
			if($('.togglearrow').hasClass('arrowup'))
				ToggleCodeRegion();
		});
		$('.tabscontent pre').click( function() {
	        var refNode = $( this )[0];
	        if ( $.browser.msie ) {
	            var range = document.body.createTextRange();
	            range.moveToElementText( refNode );
	            range.select();
	        } else if ( $.browser.mozilla || $.browser.opera ) {
	            var selection = window.getSelection();
	            var range = document.createRange();
	            range.selectNodeContents( refNode );
	            selection.removeAllRanges();
	            selection.addRange( range );
	        } else if ( $.browser.safari ) {
	            var selection = window.getSelection();
	            selection.setBaseAndExtent( refNode, 0, refNode, 1 );
	        }
	    } );
		$('.samplesnav a').first().click();
});

function ToggleCodeRegion(){
	$('.tabscontent').slideToggle('fast');
	if($('.togglearrow').hasClass('arrowup')){
		$('.togglearrow').removeClass('arrowup').addClass('arrowdown');
	}
	else
	{
		$('.togglearrow').removeClass('arrowdown').addClass('arrowup');
	}
}

function OnThumbClick(obj){
		var chart_container = $(obj).find(".container");
		var html = chart_container.data("chart");
		var fTitle = "";
		$("#currentChart").html("");
		$("#currentChart").attr("class",chart_container.attr("class"));
		fTitle = chart_container.data("function");
		$("#h6_chart_title").text(chart_container.data("title"));
		var functionCode = fTitle.toString();
		var fnBody = functionCode.substring(functionCode.indexOf("{") + 1, functionCode.lastIndexOf("}"));
		
		var chart = new cfx.Chart();
		var objName = "chart1";
		var objType = "cfx.Chart";
		if (fnBody.indexOf("radialGauge1") >= 0){
			chart = new cfx.gauge.RadialGauge();
			objName = "radialGauge1";
			objType = "cfx.gauge.RadialGauge";
		}
		else{
			if (fnBody.indexOf("horizontalGauge1") >= 0){
				chart = new cfx.gauge.HorizontalGauge();
				objName = "horizontalGauge1";
				objType = "cfx.gauge.HorizontalGauge";
			}
			else{
				if (fnBody.indexOf("verticalGauge1") >= 0){
					chart = new cfx.gauge.VerticalGauge();
					objName = "verticalGauge1";
					objType = "cfx.gauge.VerticalGauge";
				}
				else{
					if (fnBody.indexOf("digitalPanel1") >= 0){
						chart = new cfx.gauge.DigitalPanel();
						objName = "digitalPanel1";
						objType = "cfx.gauge.DigitalPanel";
					}
					else{
						if (fnBody.indexOf("trend1") >= 0){
							chart = new cfx.gauge.Trend();
							objName = "trend1";
							objType = "cfx.gauge.Trend";
						}
					}				
				}			
			}		
		}
		
		fTitle(chart);
		chart.create("currentChart");
		chart_container.data("chart",$("#currentChart").html());			
		
		var styleSelector = ".jcf_style." +  chart_container.attr("id");
		$('.tabscontent .css pre').text($(styleSelector).length>0?$(styleSelector).html():"");
		var js = "var " + objName + " = new " + objType + "();\r\n" + fnBody + "\r\n" + objName + ".create('div_obj');";
		js = htmlEncode(replaceAll(js,"\t",""));
		js = replaceAll(js,"// RELEVANT CODE","<div class='relevant_code'>");
		js = replaceAll(js,"// END RELEVANT CODE","</div>");
		var re ="(\\w+)(?=\\s?\\(" + objName + ")";
		var regexp = new RegExp(re, "gi");

		var matches = fnBody.match(regexp);
		if (matches != null){
			for (i=0; i<matches.length; i++) {
				//alert(matches[i]);
				var internalFunctionName = matches[i];
				var internalFunctionCode = window[internalFunctionName];
				js = js  +"\r\n\r\n" + htmlEncode(internalFunctionCode.toString());
			}
		}
		$('.tabscontent .js pre').html(js);
		$('.tabscontent .html pre').text("<div id='div_obj' style='width:" + $("#currentChart").css("width") + ";height:" + $("#currentChart").css("height") + ";'></div>");
}

function htmlEncode(value){
  return $('<div/>').text(value).html();
}
function replaceAll(txt, replace, with_this) {
    return txt.replace(new RegExp(replace, 'g'), with_this);
}

function Positioning(chart,x,y,chartDiv,classContainerName) {
        var topPos = 0, leftPos = 0;
        var viewBoxX = 100;
        var viewBoxY = 100;
        
        var maxWidth = parseInt($(".helper_div." + classContainerName).width());
		var maxHeight = parseInt($(".helper_div." + classContainerName).height());
		
        if (parseInt(y) >= 0) {
            topPos = (parseInt(y) - viewBoxY / 2) * -1;
            leftPos = (parseInt(x) - viewBoxX / 2) * -1;
        }
        if (topPos > 0) topPos = 0;
        if (topPos < (maxHeight - viewBoxY) * -1) topPos = (maxHeight - viewBoxY) * -1;
        if (leftPos > 0) leftPos = 0;
        if (leftPos < (maxWidth - viewBoxX) * -1) leftPos = (maxWidth - viewBoxX) * -1;
        var styleStr = "margin-top:" + topPos + "px; margin-left:" + leftPos + "px;";
        chartDiv.find("svg").attr('style', styleStr);
		
		if (classContainerName.indexOf("chart") >= 0)
			chart.getToolTips().setEnabled(false);		
}

function fix_thumb(chart, chartClass){
    if (chartClass =="chart"){
		chart.getAllSeries().setMarkerSize(2);
		chart.setBorder(null);
		chart.getPlotAreaMargin().setTop(5);
		chart.getPlotAreaMargin().setBottom(1);
		chart.getPlotAreaMargin().setRight(5);
		chart.getPlotAreaMargin().setLeft(5);
		chart.getAxisY().setVisible(false);
		chart.getAxisX().setVisible(false);
		chart.setAxesStyle(cfx.AxesStyle.None);
		chart.setBackground(null);
		chart.getToolTips().setEnabled(false);
		chart.getLegendBox().setVisible(false);
		chart.setExtraStyle(((chart.getExtraStyle()) | (cfx.ChartStyles.HideZLabels)));
		chart.getTitles().getItem(0).setText("");
	}
}