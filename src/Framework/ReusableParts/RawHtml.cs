/*************************************************************************************************

Raw HTML: Generic Model and MVC Adapter
Licensed to users of N2CMS under the terms of the Boost Software License

Copyright (c) 2013 Benjamin Herila <mailto:ben@herila.net>

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization obtaining a copy of the 
software and accompanying documentation covered by this license (the "Software") to use, reproduce,
display, distribute, execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to do so, all subject to 
the following:

The copyright notices in the Software and this entire statement, including the above license grant,
this restriction and the following disclaimer, must be included in all copies of the Software, in
whole or in part, and all derivative works of the Software, unless such copies or derivative works 
are solely in the form of machine-executable object code generated by a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-
INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*************************************************************************************************/

using System;
using N2.Web.Mvc;
using N2.Engine;
using N2.Details;
using N2.Web.Parts;

namespace N2.Web
{
    [PartDefinition(Title = "Raw HTML", RequiredPermission = N2.Security.Permission.Publish, IconClass = "fa fa-code")]
    public class RawHtml : ContentItem
    {
        [EditableText(Rows = 10, Columns = 50, TextMode = System.Web.UI.WebControls.TextBoxMode.MultiLine)]
        public string HtmlContent
        {
            get { return GetDetail("Body", ""); }
            set { SetDetail("Body", value, ""); }
        }
    }

    [Adapts(typeof(RawHtml))]
    public class RawHtmlAdapter : PartsAdapter
    {
        public override void RenderPart(System.Web.Mvc.HtmlHelper html, ContentItem part, System.IO.TextWriter writer = null)
        {
            if (!(part is RawHtml))
                throw new ArgumentException("This adapter can only be used to adapt RawHTML parts.");
            html.ViewContext.Writer.Write((part as RawHtml).HtmlContent);
        }
    }

}
