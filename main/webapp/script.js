function sessionOpenContent(evt, repType) {
/*  var i, sessionTabContent, sessionTabLinks;
  sessionTabContent = document.getElementsByClassName("sessionTabContent");
  for (i = 0; i < sessionTabContent.length; i++) {
    sessionTabContent[i].style.display = "none";
  }
  sessionTabLinks = document.getElementsByClassName("sessionTabLinks");
  for (i = 0; i < sessionTabLinks.length; i++) {
    sessionTabLinks[i].className = sessionTabLinks[i].className.replace(" active", "");
  }
  document.getElementById(repType).style.display = "block";
  evt.currentTarget.className += " active";*/
	window.open("http://localhost:8080/BOTU/GetSessionController?sess="+repType, "_self");
}

function openContent(evt, repType) {
  var i, tabContent, tabLinks;
  tabContent = document.getElementsByClassName("tabContent");
  for (i = 0; i < tabContent.length; i++) {
    tabContent[i].style.display = "none";
  }
  tabLinks = document.getElementsByClassName("tabLinks");
  for (i = 0; i < tabLinks.length; i++) {
    tabLinks[i].className = tabLinks[i].className.replace(" active", "");
  }
  document.getElementById(repType).style.display = "block";
  evt.currentTarget.className += " active";
}

function graphOpenContent(evt, repType) {
	  var i, graphTabContent, graphTabLinks;
	  graphTabContent = document.getElementsByClassName("graphTabContent");
	  for (i = 0; i < graphTabContent.length; i++) {
	    graphTabContent[i].style.display = "none";
	  }
	  graphTabLinks = document.getElementsByClassName("graphTabLinks");
	  for (i = 0; i < graphTabLinks.length; i++) {
	    graphTabLinks[i].className = graphTabLinks[i].className.replace(" active", "");
	  }
	  document.getElementById(repType).style.display = "inline-block";
	  evt.currentTarget.className += " active";
	}

