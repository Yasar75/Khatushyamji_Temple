var isCalOpen;
var startAt = 1 // 0 - sunday ; 1 - monday
var showWeekNumber = 0 // 0 - don't show; 1 - show
var showToday = 1 // 0 - don't show; 1 - show
var imgDir = "../AxpImages/" // directory for images ... e.g. var imgDir="/img/"
var styleAnchor = "text-decoration:none;color:black;"
var monthName = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

//Don't Edit these variables
var crossobj, crossMonthObj, crossYearObj, monthSelected, yearSelected, dateSelected, omonthSelected, oyearSelected, odateSelected, monthConstructed, yearConstructed, intervalID1, intervalID2, timeoutID1, timeoutID2, ctlToPlaceValue, ctlNow, dateFormat, nStartingYear
var bPageLoaded = false
var ie = document.all
var dom = document.getElementById
var today = new Date()
var dateNow = today.getDate()
var monthNow = today.getMonth()
var yearNow = today.getFullYear()
var bShow = false;
var HolidaysCounter = 0
var Holidays = new Array()

if (dom) {
    //var imgsrc = new Array("drop11.gif", "drop22.gif", "left11.gif", "left22.gif", "right11.gif", "right22.gif");
    //var img = new Array();
    //for	(i=0;i<imgsrc.length;i++){
    //	img[i] = new Image
    //	img[i].src = imgDir + imgsrc[i]
    //}
    document.write("<div onclick='bShow=true' class='header' id='calendar' style='z-index:99999;position:absolute;visibility:hidden;'><table width=" + ((showWeekNumber == 1) ? 250 : 220) + " style='font-size:12px;border-width:1;border-style:thin;border-color:#6190BA;font-size:11px}' bgcolor='#ffffff'><tr class='header'><td><table width='" + ((showWeekNumber == 1) ? 248 : 218) + "'><tr class='header'><td style='padding:2px;font-size:11px;'><font color='#ffffff'><B><span id='caption'></span></B></font></td><td align=right><a href='javascript:hideCalendarControl()'><IMG SRC='" + imgDir + "close_btn.gif' WIDTH='15' HEIGHT='13' BORDER='0' ALT='Close the Calendar'></a></td></tr></table></td></tr><tr><td style='padding:5px' bgcolor=#ffffff><span id='content'></span></td></tr>")
    if (showToday == 1) {
        document.write("<tr class='header'><td style='padding:5px;" + styleAnchor + "' align=center><span id='lblToday'></span></td></tr>")
    }
    document.write("</table></div><div id='selectMonth' class='Pagebody' style='z-index:99999;position:absolute;visibility:hidden;'></div><div id='selectYear' class='Pagebody' style='z-index:99999;position:absolute;visibility:hidden;'></div>");
}
if (startAt == 0) {
    dayName = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
}
else {
    dayName = new Array("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
}
document.onkeypress = function hidecal1() {
    if (event.keyCode == 27) {
        hideCalendarControl()
    }
}
document.onclick = function hidecal2() {
    if (!bShow) {
        hideCalendarControl()
    }
    bShow = false
}
if (ie) {
    init()
}
else {
    window.onload = init()
}

// hides <select> and <applet> objects (for IE only)
function hideElement(elmID, overDiv) {
    if (ie) {
        for (i = 0; i < document.all.tags(elmID).length; i++) {
            obj = document.all.tags(elmID)[i];
            if (!obj || !obj.offsetParent) {
                continue;
            }
            // Find the element's offsetTop and offsetLeft relative to the BODY tag.
            objLeft = obj.offsetLeft;
            objTop = obj.offsetTop;
            objParent = obj.offsetParent;
            while ((objParent.tagName.toUpperCase() != "BODY") && (objParent.tagName.toUpperCase() != "HTML")) {
                objLeft += objParent.offsetLeft;
                objTop += objParent.offsetTop;
                objParent = objParent.offsetParent;
            }
            objHeight = obj.offsetHeight;
            objWidth = obj.offsetWidth;
            if ((overDiv.offsetLeft + overDiv.offsetWidth) <= objLeft);
            else if ((overDiv.offsetTop + overDiv.offsetHeight) <= objTop);
                /* CHANGE for nested TDs*/
            else if (overDiv.offsetTop >= (objTop + objHeight + obj.height));
                /* END CHANGE */
            else if (overDiv.offsetLeft >= (objLeft + objWidth));
            else {
                //alert(crossobj.top+".."+ objTop +"oLeft+oWidth=" + (overDiv.offsetLeft + overDiv.offsetWidth) +" <=objLeft=" +objLeft);
                //alert(objTop +".."+ crossobj.top.substr(0,crossobj.top.length - 2))
                if (objTop + 2 <= crossobj.top.substr(0, crossobj.top.length - 2))
                { }
                else
                {
                    obj.style.visibility = "hidden";
                }
            }
        }
    }
}

//unhides <select> and <applet> objects (for IE only)
function showElement(elmID) {
    if (ie) {
        for (i = 0; i < document.all.tags(elmID).length; i++) {
            obj = document.all.tags(elmID)[i];
            if (!obj || !obj.offsetParent) {
                continue;
            }
            obj.style.visibility = "";
        }
    }
}

function HolidayRec(d, m, y, desc) {
    this.d = d
    this.m = m
    this.y = y
    this.desc = desc
}

//function addHoliday (d, m, y, desc){
//	Holidays[HolidaysCounter++] = new HolidayRec ( d, m, y, desc )
//}

//function swapImage(srcImg, destImg){
//	if (ie)	{ document.getElementById(srcImg).setAttribute("src",imgDir + destImg) }
//}

function init() {
    var gotoString = "Go To Current Month";
    var todayString = "Today is";
    var scrollLeftMessage = "Click to scroll to previous month. Hold mouse button to scroll automatically.";
    var scrollRightMessage = "Click to scroll to next month. Hold mouse button to scroll automatically.";
    var selectMonthMessage = "Click to select a month.";
    var selectYearMessage = "Click to select a year.";
    var ns4 = document.layers;
    if (!ns4) {
        //if (!ie) { yearNow += 1900	}
        crossobj = (dom) ? document.getElementById("calendar").style : ie ? document.all.calendar : document.calendar
        hideCalendarControl()
        crossMonthObj = (dom) ? document.getElementById("selectMonth").style : ie ? document.all.selectMonth : document.selectMonth
        crossYearObj = (dom) ? document.getElementById("selectYear").style : ie ? document.all.selectYear : document.selectYear
        monthConstructed = false;
        yearConstructed = false;
        if (showToday == 1) {
            document.getElementById("lblToday").innerHTML = todayString + " <a onmousemove='window.status=\"" + gotoString + "\"' onmouseout='window.status=\"\"' title='" + gotoString + "' style='" + styleAnchor + "' href='javascript:monthSelected=monthNow;yearSelected=yearNow;constructCalendar();'>" + dayName[(today.getDay() - startAt == -1) ? 6 : (today.getDay() - startAt)] + ", " + dateNow + " " + monthName[monthNow].substring(0, 3) + "	" + yearNow + "</a>"

        }
        sHTML1 = "<span id='spanLeft' class='Headerbg' style='border-style:solid;border-width:1;cursor:pointer' onmouseover='this.style.borderColor=\"#EFF3FB\";window.status=\"" + scrollLeftMessage + "\"' onclick='javascript:decMonth()' onmouseout='this.style.borderColor=\"\";clearInterval(intervalID1);window.status=\"\"' onmousedown='clearTimeout(timeoutID1);timeoutID1=setTimeout(\"StartDecMonth()\",500)'	onmouseup='clearTimeout(timeoutID1);clearInterval(intervalID1)'>&nbsp;<a id='changeLeft'>&lt;&lt;</a>&nbsp;</span>&nbsp;"
        sHTML1 += "<span id='spanRight' class='Headerbg' style='border-style:solid;border-width:1;cursor:pointer'	onmouseover='this.style.borderColor=\"#EFF3FB\";window.status=\"" + scrollRightMessage + "\"' onmouseout='this.style.borderColor=\"\";clearInterval(intervalID1);window.status=\"\"' onclick='incMonth()' onmousedown='clearTimeout(timeoutID1);timeoutID1=setTimeout(\"StartIncMonth()\",500)'	onmouseup='clearTimeout(timeoutID1);clearInterval(intervalID1)'>&nbsp;<a id='changeRight'>&gt;&gt;</a>&nbsp;</span>&nbsp"
        sHTML1 += "<span id='spanMonth' class='Headerbg' style='border-style:solid;border-width:1;cursor:pointer'	onmouseover='this.style.borderColor=\"#EFF3FB\";window.status=\"" + selectMonthMessage + "\"' onmouseout='this.style.borderColor=\"\";window.status=\"\"' onclick='popUpMonth()'></span>&nbsp;"
        sHTML1 += "<span id='spanYear' class='Headerbg' style='border-style:solid;border-width:1;cursor:pointer' onmouseover='this.style.borderColor=\"#EFF3FB\";window.status=\"" + selectYearMessage + "\"'	onmouseout='this.style.borderColor=\"\";window.status=\"\"'	onclick='popUpYear()'></span>&nbsp;"
        document.getElementById("caption").innerHTML = sHTML1
        bPageLoaded = true
    }
}

function hideCalendarControl() {

    crossobj.visibility = "hidden"
    if (crossMonthObj != null) { crossMonthObj.visibility = "hidden" }
    if (crossYearObj != null) { crossYearObj.visibility = "hidden" }
    showElement('SELECT');
    showElement('APPLET');
    SubCalHgtFrmIview();
    AxDoBlur = true;
}

function padZero(num) {
    return (num < 10) ? '0' + num : num;
}

function constructDate(d, m, y) {
    sTmp = dtFormat;
    sTmp = sTmp.replace('ddd', '<n>');
    sTmp = sTmp.replace("dd", "<e>")
    sTmp = sTmp.replace("d", "<d>")
    sTmp = sTmp.replace("<e>", padZero(d))
    sTmp = sTmp.replace("<d>", d)
    sTmp = sTmp.replace("mmm", "<o>")
    sTmp = sTmp.replace("mm", "<n>")
    sTmp = sTmp.replace("m", "<m>")
    sTmp = sTmp.replace("<m>", m + 1)
    sTmp = sTmp.replace("<n>", padZero(m + 1))
    sTmp = sTmp.replace("<o>", monthName[m])
    return sTmp.replace("yyyy", y)
}

function closeCalendar() {


    ctlToPlaceValue.value = constructDate(dateSelected, monthSelected, yearSelected);
    var title = document.title;

    if (title == "Users") {

        if (ctlToPlaceValue) {
            var objId = ctlToPlaceValue.id;
            if (objId.toString().indexOf("txtUsStrDt") != -1)
                celno = 2;
            else
                celno = 3;

            var index1 = objId.toString().indexOf("ctl");
            var rowIndex = objId.toString().substring(index1 + 3);

            var index2 = rowIndex.toString().indexOf("_");
            Rindx = parseInt(rowIndex.toString().substring(0, index2), 10) - 2;
        }

        ValidateDate(Rindx, celno);
        hideCalendarControl();
    }
}

// Month Pulldown
function StartDecMonth() {
    intervalID1 = setInterval("decMonth()", 80000);
}

function StartIncMonth() {
    intervalID1 = setInterval("incMonth()", 80000);
}

function incMonth() {
    monthSelected++
    if (monthSelected > 11) {
        monthSelected = 0
        yearSelected++
    }
    constructCalendar()
}

function decMonth() {
    monthSelected--
    if (monthSelected < 0) {
        monthSelected = 11
        yearSelected--
    }
    constructCalendar()
}

function constructMonth() {
    popDownYear()
    if (!monthConstructed) {
        sHTML = ""
        for (i = 0; i < 12; i++) {
            sName = monthName[i];
            if (i == monthSelected) {
                sName = "<B>" + sName + "</B>"
            }
            sHTML += "<tr><td id='m" + i + "' onmouseover='this.style.backgroundColor=\"#FFCC99\"' onmouseout='this.style.backgroundColor=\"\"' style='cursor:pointer' onclick='monthConstructed=false;monthSelected=" + i + ";constructCalendar();popDownMonth();event.cancelBubble=true'>&nbsp;" + sName + "&nbsp;</td></tr>"
        }

        document.getElementById("selectMonth").innerHTML = "<table width=70	style='font-size:11px; border-width:1; border-style:solid; border-color:#a0a0a0;' cellspacing=0 onmouseover='clearTimeout(timeoutID1)'	onmouseout='clearTimeout(timeoutID1);timeoutID1=setTimeout(\"popDownMonth()\",100);event.cancelBubble=true'>" + sHTML + "</table>"
        monthConstructed = true
    }
}

function popUpMonth() {
    constructMonth()
    if (navigator.appName != "Microsoft Internet Explorer") {
        crossMonthObj.left = (parseInt(crossobj.left, 10) + 56) + "px";
        crossMonthObj.top = (parseInt(crossobj.top, 10) + 26) + "px";
    }
    else {
        crossMonthObj.left = (parseInt(crossobj.left, 10) + 56) + "px";
        crossMonthObj.top = (parseInt(crossobj.top, 10) + 26) + "px";
    }
    crossMonthObj.visibility = (dom || ie) ? "visible" : "show"

    hideElement('SELECT', document.getElementById("selectMonth"));
    hideElement('APPLET', document.getElementById("selectMonth"));
}

function popDownMonth() {
    crossMonthObj.visibility = "hidden"
}

// Year Pulldown
function incYear() {
    for (i = 0; i < 7; i++) {
        newYear = (i + nStartingYear) + 1
        if (newYear == yearSelected)
        { txtYear = "&nbsp;<B>" + newYear + "</B>&nbsp;" }
        else
        { txtYear = "&nbsp;" + newYear + "&nbsp;" }
        document.getElementById("y" + i).innerHTML = txtYear
    }
    nStartingYear++;
    bShow = true
}

function decYear() {
    for (i = 0; i < 7; i++) {
        newYear = (i + nStartingYear) - 1
        if (newYear == yearSelected)
        { txtYear = "&nbsp;<B>" + newYear + "</B>&nbsp;" }
        else
        { txtYear = "&nbsp;" + newYear + "&nbsp;" }
        document.getElementById("y" + i).innerHTML = txtYear
    }
    nStartingYear--;
    bShow = true
}

function selectYear(nYear) {
    yearSelected = parseInt(nYear + nStartingYear);
    yearConstructed = false;
    constructCalendar();
    popDownYear();
}

function constructYear() {
    popDownMonth()
    sHTML = ""
    if (!yearConstructed) {
        sHTML = "<tr><td align='center'	onmouseover='this.style.backgroundColor=\"#FFCC99\"' onmouseout='clearInterval(intervalID1);this.style.backgroundColor=\"\"' style='cursor:pointer'	onmousedown='clearInterval(intervalID1);intervalID1=setInterval(\"decYear()\",30)' onmouseup='clearInterval(intervalID1)'>-</td></tr>"
        j = 0
        nStartingYear = yearSelected - 3
        for (i = (yearSelected - 3) ; i <= (yearSelected + 3) ; i++) {
            sName = i;
            if (i == yearSelected) {
                sName = "<B>" + sName + "</B>"
            }
            sHTML += "<tr><td id='y" + j + "' onmouseover='this.style.backgroundColor=\"#FFCC99\"' onmouseout='this.style.backgroundColor=\"\"' style='cursor:pointer' onclick='selectYear(" + j + ");event.cancelBubble=true'>&nbsp;" + sName + "&nbsp;</td></tr>"
            j++;
        }
        sHTML += "<tr><td align='center' onmouseover='this.style.backgroundColor=\"#FFCC99\"' onmouseout='clearInterval(intervalID2);this.style.backgroundColor=\"\"' style='cursor:pointer' onmousedown='clearInterval(intervalID2);intervalID2=setInterval(\"incYear()\",30)'	onmouseup='clearInterval(intervalID2)'>+</td></tr>"
        document.getElementById("selectYear").innerHTML = "<table width=44 style='font-size:11px; border-width:1; border-style:solid; border-color:#a0a0a0;'	onmouseover='clearTimeout(timeoutID2)' onmouseout='clearTimeout(timeoutID2);timeoutID2=setTimeout(\"popDownYear()\",100)' cellspacing=0>" + sHTML + "</table>"
        yearConstructed = true
    }
}

function popDownYear() {
    clearInterval(intervalID1)
    clearTimeout(timeoutID1)
    clearInterval(intervalID2)
    clearTimeout(timeoutID2)
    crossYearObj.visibility = "hidden"
}

function popUpYear() {
    var leftOffset
    constructYear()
    leftOffset = parseInt(crossobj.left) + document.getElementById("spanYear").offsetLeft
    if (ie) {
        leftOffset += 6
    }
    if (navigator.appName != "Microsoft Internet Explorer") {
        leftOffset += 6;
        crossYearObj.left = leftOffset + "px";
        crossYearObj.top = (parseInt(crossobj.top, 10) + 26) + "px";
    }
    else {
        crossYearObj.left = leftOffset + "px";
        crossYearObj.top = (parseInt(crossobj.top, 10) + 26) + "px";
    }
    crossYearObj.visibility = (dom || ie) ? "visible" : "show"
}

function WeekNbr(n) {
    // Algorithm used:
    // From Klaus Tondering's Calendar document (The Authority/Guru)
    // hhtp://www.tondering.dk/claus/calendar.html
    // a = (14-month) / 12
    // y = year + 4800 - a
    // m = month + 12a - 3
    // J = day + (153m + 2) / 5 + 365y + y / 4 - y / 100 + y / 400 - 32045
    // d4 = (J + 31741 - (J mod 7)) mod 146097 mod 36524 mod 1461
    // L = d4 / 1460
    // d1 = ((d4 - L) mod 365) + L
    // WeekNumber = d1 / 7 + 1

    year = n.getFullYear();
    month = n.getMonth() + 1;
    if (startAt == 0) {
        day = n.getDate() + 1;
    }
    else {
        day = n.getDate();
    }
    a = Math.floor((14 - month) / 12);
    y = year + 4800 - a;
    m = month + 12 * a - 3;
    b = Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400);
    J = day + Math.floor((153 * m + 2) / 5) + 365 * y + b - 32045;
    d4 = (((J + 31741 - (J % 7)) % 146097) % 36524) % 1461;
    L = Math.floor(d4 / 1460);
    d1 = ((d4 - L) % 365) + L;
    week = Math.floor(d1 / 7) + 1;
    return week;
}

function constructCalendar() {
    var weekString = "Wk";
    var selectDateMessage = "Select [date] as date.";  // do not replace [date], it will be replaced by date.
    var styleLightBorder = "border-style:solid;border-width:1px;border-color:#a0a0a0;";
    var aNumDays = Array(31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    var dateMessage
    var startDate = new Date(yearSelected, monthSelected, 1)
    var endDate
    if (monthSelected == 1) {
        endDate = new Date(yearSelected, monthSelected + 1, 1);
        endDate = new Date(endDate - (24 * 60 * 60 * 1000));
        numDaysInMonth = endDate.getDate()
    }
    else {
        numDaysInMonth = aNumDays[monthSelected];
    }
    datePointer = 0
    dayPointer = startDate.getDay() - startAt
    if (dayPointer < 0) {
        dayPointer = 6
    }
    sHTML = "<table	 border=0 style='font-size:10px;'><tr>"
    if (showWeekNumber == 1) {
        sHTML += "<td width=27><b>" + weekString + "</b></td><td width=1 rowspan=7 bgcolor='#d0d0d0' style='padding:0px'><img src='" + imgDir + "divider.gif' width=1></td>"
    }
    for (i = 0; i < 7; i++) {
        sHTML += "<td width='27' align='right'><B>" + dayName[i] + "</B></td>"
    }
    sHTML += "</tr><tr>"
    if (showWeekNumber == 1) {
        sHTML += "<td align=right>" + WeekNbr(startDate) + "&nbsp;</td>"
    }
    for (var i = 1; i <= dayPointer; i++) {
        sHTML += "<td>&nbsp;</td>"
    }
    for (datePointer = 1; datePointer <= numDaysInMonth; datePointer++) {
        dayPointer++;
        sHTML += "<td align=right>"
        sStyle = styleAnchor
        if ((datePointer == odateSelected) && (monthSelected == omonthSelected) && (yearSelected == oyearSelected))
        { sStyle += styleLightBorder }
        sHint = ""
        for (k = 0; k < HolidaysCounter; k++) {
            if ((parseInt(Holidays[k].d) == datePointer) && (parseInt(Holidays[k].m) == (monthSelected + 1))) {
                if ((parseInt(Holidays[k].y) == 0) || ((parseInt(Holidays[k].y) == yearSelected) && (parseInt(Holidays[k].y) != 0))) {
                    sStyle += "background-color:#FFDDDD;"
                    sHint += sHint == "" ? Holidays[k].desc : "\n" + Holidays[k].desc
                }
            }
        }
        var regexp = /\"/g
        sHint = sHint.replace(regexp, "&quot;")
        dateMessage = "onmousemove='window.status=\"" + selectDateMessage.replace("[date]", constructDate(datePointer, monthSelected, yearSelected)) + "\"' onmouseout='window.status=\"\"' "
        if ((datePointer == dateNow) && (monthSelected == monthNow) && (yearSelected == yearNow))
        { sHTML += "<b><a " + dateMessage + " title=\"" + sHint + "\" style='" + sStyle + "' href='javascript:dateSelected=" + datePointer + ";closeCalendar();'><font color=#ff0000>&nbsp;" + datePointer + "</font>&nbsp;</a></b>" }
        else if (dayPointer % 7 == (startAt * -1) + 1)
        { sHTML += "<a " + dateMessage + " title=\"" + sHint + "\" style='" + sStyle + "' href='javascript:dateSelected=" + datePointer + ";closeCalendar();'>&nbsp;<font color=#909090>" + datePointer + "</font>&nbsp;</a>" }
        else
        { sHTML += "<a " + dateMessage + " title=\"" + sHint + "\" style='" + sStyle + "' href='javascript:dateSelected=" + datePointer + ";closeCalendar();'>&nbsp;" + datePointer + "&nbsp;</a>" }

        sHTML += ""
        if ((dayPointer + startAt) % 7 == startAt) {
            sHTML += "</tr><tr>"
            if ((showWeekNumber == 1) && (datePointer < numDaysInMonth)) {
                sHTML += "<td align=right>" + (WeekNbr(new Date(yearSelected, monthSelected, datePointer + 1))) + "&nbsp;</td>"
            }
        }
    }
    document.getElementById("content").innerHTML = sHTML
    document.getElementById("spanMonth").innerHTML = "&nbsp;" + monthName[monthSelected] + "&nbsp;&nbsp;<a id='changeMonth'>v</a>&nbsp;"
    document.getElementById("spanYear").innerHTML = "&nbsp;" + yearSelected + "&nbsp;&nbsp;<a id='changeYear'>v</a>&nbsp;"
}

function showCalendarControl(ctl) {

    AxDoBlur = false;
    var ctl2 = ctl;
    var fixedX = -1;  // x position (-1 if to appear below control)
    var fixedY = -1;  // y position (-1 if to appear below control)
    var format = dtFormat;
    var leftpos = 0
    var toppos = 0
    if (bPageLoaded) {
        if (crossobj.visibility == "hidden") {
            ctlToPlaceValue = ctl2
            dateFormat = format;
            formatChar = " "
            aFormat = dateFormat.split(formatChar)
            if (aFormat.length < 3) {
                formatChar = "/"
                aFormat = dateFormat.split(formatChar)
                if (aFormat.length < 3) {
                    formatChar = "."
                    aFormat = dateFormat.split(formatChar)
                    if (aFormat.length < 3) {
                        formatChar = "-"
                        aFormat = dateFormat.split(formatChar)
                        if (aFormat.length < 3) {
                            // invalid date	format
                            formatChar = ""
                        }
                    }
                }
            }
            tokensChanged = 0
            if (formatChar != "") {
                // use user's date
                aData = ctl2.value.split(formatChar)
                for (i = 0; i < 3; i++) {
                    if ((aFormat[i] == "d") || (aFormat[i] == "dd")) {
                        dateSelected = parseInt(aData[i], 10)
                        tokensChanged++
                    }
                    else if ((aFormat[i] == "m") || (aFormat[i] == "mm")) {
                        monthSelected = parseInt(aData[i], 10) - 1
                        tokensChanged++
                    }
                    else if (aFormat[i] == "yyyy") {
                        yearSelected = parseInt(aData[i], 10)
                        tokensChanged++
                    }
                    else if (aFormat[i] == "mmm") {
                        for (j = 0; j < 12; j++) {
                            if (aData[i] == monthName[j]) {
                                monthSelected = j
                                tokensChanged++
                            }
                        }
                    }
                }
            }
            if ((tokensChanged != 3) || isNaN(dateSelected) || isNaN(monthSelected) || isNaN(yearSelected)) {
                dateSelected = dateNow
                monthSelected = monthNow
                yearSelected = yearNow
            }
            odateSelected = dateSelected
            omonthSelected = monthSelected
            oyearSelected = yearSelected
            aTag = ctl
            do {
                aTag = aTag.offsetParent;
                leftpos += aTag.offsetLeft;
                toppos += aTag.offsetTop;
            } while ((aTag.tagName != "BODY") && (aTag.tagName != "HTML"));

            // to take care of the scroll
            // TODO: the follwoing code takes care of vertical scroll this needs tobe extended to horizontal scroll. 
            aTag = ctl;
            var sTop = 0;
            do {
                aTag = aTag.parentNode;
                if (aTag.tagName == "DIV") {
                    aTag = aTag.parentNode;
                    sTop = aTag.scrollTop;
                    break;
                }
            } while ((aTag.tagName != "BODY") && (aTag.tagName != "HTML"));

            var strLeft = ctl.offsetLeft + leftpos;
            var strTop = ctl.offsetTop + toppos + ctl.offsetHeight + 2 - sTop;

            crossobj.left = fixedX == -1 ? strLeft.toString() + "px" : fixedX
            crossobj.top = fixedY == -1 ? strTop.toString() + "px" : fixedY
            AdjustWidth(strLeft);
            constructCalendar(1, monthSelected, yearSelected);
            crossobj.visibility = (dom || ie) ? "visible" : "show"
            hideElement('SELECT', document.getElementById("calendar"));
            hideElement('APPLET', document.getElementById("calendar"));
            bShow = true;

            AddCalHgtToIview();

        }
        else {
            hideCalendarControl();
            if (ctlNow != ctl) { showCalendarControl(ctl, format); }
        }
        ctlNow = ctl;
    }
}

var extraHgt;
function AddCalHgtToIview() {
    if (document.title == "Iview" || document.title.toLowerCase().indexOf("tstruct") != -1 || document.title == "Users") {
        var currentfr = parent.document.getElementById("middle1");
        if (document.title == "Iview" && window.opener != undefined)
            currentfr = $j("#middle1", window.opener.parent.document);
        //currentfr = window.opener.parent.document.getElementById("middle1");

        var calTop = crossobj.top.replace("px", "");
        //Subtracting extra 30 px for considering the (gray color) footer height both in iview and tstruct
        var temp = parseInt(currentfr.clientHeight, 10) - parseInt(calTop, 10) - 30;
        extraHgt = (220 - temp);

        if (temp < 185)
            currentfr.style.height = parseInt(currentfr.clientHeight, 10) + (400 - temp);
        isCalOpen = true;
    }
}

function SubCalHgtFrmIview() {
    if (document.title == "Iview") {
        if (isCalOpen != undefined && isCalOpen == true) {
            var currentfr = parent.document.getElementById("middle1");
            if (navigator.appName != "Microsoft Internet Explorer") {
                currentfr.height = parseInt(currentfr.height, 10) - extraHgt;
            }
            isCalOpen = false;
        }
    }
}

function AdjustWidth(strLeft) {
    var currentfr = parent.document.getElementById("middle1");
    if (document.title == "Iview" && window.opener != undefined)
        currentfr = window.opener.parent.document.getElementById("middle1");
    if (currentfr != undefined) {
        var cfrwid = parseInt(currentfr.width, 10);
        strLeft = parseInt(strLeft, 10);
        if ((cfrwid - strLeft) < 250 && document.title != "Users") {
            crossobj.left = cfrwid - 250 + "px";
        }
    }
}
