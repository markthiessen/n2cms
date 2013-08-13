/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */


//You can copy this file to any location, modify it and set path to it in web.config
//<ckeditor ckConfigJsPath="Path to Your own config file" overwriteStylesSet="Globaly use custom Stylesset (defined in custom ckConfig file)" overwriteFormatTags="Predefine your own formats" contentsCssPath="Path to your own contents.css" />

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For the complete reference:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

		config.uiColor = '#F8F8F8';
	    config.filebrowserWindowWidth = 300;
	    config.filebrowserWindowHeight = 600;
	    config.extraPlugins = 'codemirror';
	    config.height = 300;
	    config.codemirror = {
		showFormatButton: true,
		showCommentButton: false,
		showUncommentButton: false
	};

	// extra allowed content for Twitter Bootstrap styles
	config.extraAllowedContent =
         "table(table,table-bordered,table-condensed,table-striped,table-hover);tr(success,error,warning,info);"
       + "address;abbr[title];cite(pull-right);dl(dl-horizontal);dt;code;"
       + "div(alert,alert-error,alert-success,alert-info,container,container-fluid,hero-unit,media,media-body,page-header,row,span1,span2,span3,span4,span5,span6,span7,span8,span9,span10,span11,span12,well,well-large,well-small);"
       + "p(lead);"
       + "*(media-heading,visible-phone,visible-tablet,visible-desktop,hidden-phone,hidden-tablet,hidden-desktop,muted,pull-left,pull-right);"
       + "span(label,label-success,label-warning,label-important,label-info,label-inverse);"
       + "img[data-src](media-object);"
       + "a(*)[*]{*};button(btn,btn-primary,btn-info,btn-success,btn-warning,btn-danger,btn-inverse,btn-link,btn-large,btn-small,btn-mini)";
    
    // Set the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';

    // Make dialogs simpler.
	config.removeDialogTabs = 'image:advanced;link:advanced';

	config.disableNativeSpellChecker = false;

};