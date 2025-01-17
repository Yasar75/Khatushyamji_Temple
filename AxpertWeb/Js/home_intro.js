var introProfile = introJs();
    introProfile.setOptions({
    tooltipPosition : 'top',
    steps: [
        {
            element: '#dvNonCloudMenu',
            intro: 'Welcome to Axpert, please click on Next to proceed.',
            position: 'bottom'
        },
        {
            element: '#hamburgerMenuIcon',
            intro: 'Click on the link to display dropdown Menu.',
            position: 'bottom'
        },
        {
            element: '#newMenuSearch',
            intro: 'Please enter Menu action or search data and press enter. If you are not sure of what to enter, please press the down arrow key. example Search text: "Create Supplier"',
            position: 'bottom'
        },
        {
            element: '#homeIcon',
            intro: 'Click on this icon to show Home Page.',
            position: 'left'
        },
        {
            element: '#dashBoardIcon',
            intro: 'Click on this icon to display Dashboard with Charts and KPI.',
            position: 'left'
        },
        {
            element: '#themeIcon',
            intro: 'New Feature: Please click on the icon to change the Theme. There is set of pre defined themes to choose from.',
            position: 'left'
        },
        {
            element: '#ExportImportCogIcon',
            intro: 'Click on the link to make changes to Application Settings. Using this option will allow to you to change the behaviour of Forms, Reports, Dashboard and other widgets.',
            position: 'left'
        }
    ]
});
introProfile.oncomplete(function() {
    ;
});
introProfile.onexit(function(){
    ; // on exide code here 
});
introProfile.onchange(function(targetElement) {
    ; //add change bits here
});
introProfile.onafterchange(function(targetElement) {
    ;
});
introProfile.onbeforechange(function(targetElement) {
    ; // add change bits here
});
introProfile.start();
