<%@ Page Language="C#" MasterPageFile="../Framed.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="N2.Edit.Security.Default" Title="Untitled Page" meta:resourcekey="PageResource1" %>
<%@ Import Namespace="N2.Security"%>
<%@ Register TagPrefix="edit" Namespace="N2.Edit.Web.UI.Controls" Assembly="N2.Management" %>
<asp:Content ID="ch" ContentPlaceHolderID="Head" runat="server">
</asp:Content>
<asp:Content ID="ct" ContentPlaceHolderID="Toolbar" runat="server">
    <n2:OptionsMenu id="om" runat="server">
        <asp:LinkButton ID="btnSave" runat="server" CssClass="command save primary-action" data-icon-class="n2-icon-save" OnCommand="btnSave_Command" meta:resourcekey="btnSaveResource1">Save</asp:LinkButton>
        <asp:LinkButton ID="btnSaveRecursive" runat="server" CssClass="command" data-icon-class="n2-icon-save" OnCommand="btnSaveRecursive_Command" meta:resourcekey="btnSaveRecursiveResource1">Save whole branch</asp:LinkButton>
    </n2:OptionsMenu>
    <edit:CancelLink ID="hlCancel" runat="server" meta:resourcekey="hlCancelResource1">Cancel</edit:CancelLink>
</asp:Content>
<asp:Content ID="cc" ContentPlaceHolderID="Content" runat="server">
	<edit:PersistentOnlyPanel ID="popNotSupported" runat="server" meta:resourceKey="popNotSupported">
	<edit:PermissionPanel id="ppPermitted" runat="server" meta:resourceKey="ppPermitted">

    <asp:CustomValidator ID="cvSomethingSelected" runat="server" Display="Dynamic" CssClass="alert alert-margin" Text="" ErrorMessage="At least one role must be selected" OnServerValidate="cvSomethingSelected_ServerValidate" meta:resourcekey="cvSomethingSelectedResource1" />
    <style>
		.defaults td { border-bottom:solid 1px #ccc;}
		.permissionsHeader { width:130px; }
		td { width:65px;}
		.AuthorizedFalse { opacity:.33; }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $.fn.disable = function () {
                return this.attr("disabled", "disabled");
            };
            $.fn.enable = function () {
                return this.removeAttr("disabled");
            };
            var updateColumn = function () {
                var groupName = this.parentNode.className.split(' ')[1];
                var $grouped = $("." + groupName + " input").not(this);
                if (this.checked) {
                    $grouped.parent().andSelf().disable();
                } else {
                    $grouped.parent().andSelf().enable();
                }
                var $unauthorized = $grouped.parent().filter(".AuthorizedFalse").children("input").andSelf();
                $unauthorized.disable();
                return $grouped;
            };
            $(".overrides .cb input").filter(":checked").addClass("defaultChecked");
            $(".defaults .cb input").click(function () {
                var $grouped = updateColumn.call(this);

                if ($(this).is(':checked'))
                    $grouped.attr("checked", true);
                else
                    $grouped.removeAttr("checked");

                $grouped.filter(".defaultChecked").prop("checked", true);
                $grouped.filter(":not(.defaultChecked)").prop("checked", false);
            }).each(updateColumn);
        });
    </script>
<div class="tabPanel">
    <!-- customized -->
    <div class="input-append input-prepend">
        <a id="allRolesBtn" class="btn active add-on">All roles</a>
        <a id="accessRolesBtn" class="btn add-on">Roles with access</a>
        <input id="roleFilterTxt" type="text" placeholder="filter roles by name"/>
        <input id="roleFilterClearBtn" type="button" class="btn add-on" style="height:30px;" value=" X " />
    </div>
    <script type="text/javascript">

        $(function () {
            var filter = { type: 'all', text: '' };
            var rows = [];
            $('#rolesTable tbody.overrides tr').each(function () {
                var rawText = $(this).children('td').first().text();

                var row = {
                    elm: $(this),
                    rawText: $(this).children('td').first().text(),
                    compareText: rawText.toUpperCase()
                };
                if (row.compareText == 'ADMINISTRATORS')
                    $(this).addClass('admin');

                var rawTextParts = row.rawText.split('|');
                row.formattedHtml = $('<span/>').append(
                    $('<span/>').css({ color: 'rgba(24, 160, 222, 0.8)' }).text(rawTextParts[0]),
                    $('<span/>').css({ color: '#797979' }).text(rawText.indexOf('|') >= 0 ? ' | ' : ''),
                    $('<span/>').css({ color: '#393939' }).text(rawTextParts[1]));
                $(this).children('td').first().html(row.formattedHtml);
                rows.push(row);
            });

            function filterTable() {
                var text = filter.text.toUpperCase();
                rows.forEach(function (item) {

                    var canShow = filter.type == 'all' || item.elm.find('input:checked').length > 0;

                    if ((!text || (text && item.compareText.indexOf(text) >= 0)) && canShow)
                        item.elm.show();
                    else
                        item.elm.hide();
                });
            }

            $('#allRolesBtn').click(function () {
                $('#accessRolesBtn').removeClass('active');
                $(this).addClass('active');
                filter.type = 'all';
                filterTable();
            });
            $('#accessRolesBtn').click(function () {
                $('#allRolesBtn').removeClass('active');
                $(this).addClass('active');
                filter.type = 'access';
                filterTable();
            });

            function assign(permLevel) {
                $('.overrides tr:not(.admin) span.permission' + permLevel).children('input:visible').filter(':not(:disabled)').prop('checked', true);

            }
            function clear(permLevel) {
                $('.overrides tr:not(.admin) span.permission' + permLevel).children('input:visible').filter(':not(:disabled)').prop('checked', false);
            }

            var rClear = $('<a href="#">clear</a>').click(function (e) { e.preventDefault(); clear(0); }),
                rAssign = $('<a href="#">assign</a>').click(function (e) { e.preventDefault(); assign(0); }),

                wClear = $('<a href="#">clear</a>').click(function (e) { e.preventDefault(); clear(1); }),
                wAssign = $('<a href="#">assign</a>').click(function (e) { e.preventDefault(); assign(1); }),

                pClear = $('<a href="#">clear</a>').click(function (e) { e.preventDefault(); clear(2); }),
                pAssign = $('<a href="#">assign</a>').click(function (e) { e.preventDefault(); assign(2); }),

                aClear = $('<a href="#">clear</a>').click(function (e) { e.preventDefault(); clear(3); }),
                aAssign = $('<a href="#">assign</a>').click(function (e) { e.preventDefault(); assign(3); }),

                toggleRow = $('<tr/>').css({ background: '#EFEFEF' }).append(
                $('<td/>').text('Modify all visible permissions').css({ color: '#60b044' }),
                $('<td/>').append(rClear).append(' | ').append(rAssign),
                $('<td/>').append(wClear).append(' | ').append(wAssign),
                $('<td/>').append(pClear).append(' | ').append(pAssign),
                $('<td/>').append(aClear).append(' | ').append(aAssign));

            $('#rolesTable thead').after(
                $('<tbody/>').addClass('toggles').append(toggleRow));



            $('#roleFilterTxt').keydown(function (e) {
                if (e.keyCode == 13) {
                    filter.text = $(this).val();
                    filterTable();
                    e.preventDefault();
                    return false;
                }
            });

            $('#roleFilterClearBtn').click(function (e) {
                filter.text = '';
                filter.type = 'all';

                $('#accessRolesBtn').removeClass('active');
                $('#accessRolesBtn').addClass('active');

                $('#roleFilterTxt').val(filter.text);


                filterTable();
            });
        });
    </script>
    
    <!-- /customized -->
    <table id="rolesTable" class="table">
		<thead>
			<tr>
				<td class="permissionsHeader" title="Altered: <%= Selection.SelectedItem.AlteredPermissions %>"></td>
				<asp:Repeater ID="rptHeaders" runat="server" DataSource="<%# Permissions %>"><ItemTemplate>
					<td><%# Container.DataItem %></td>
				</ItemTemplate></asp:Repeater>
			</tr>
		</thead>
		<tbody class="defaults">
			<tr>
				<td style="width:200px;"><%= GetLocalResourceString("DefaultText", "Default")%></td>
			<asp:Repeater ID="rptEveryone" runat="server" DataSource="<%# Permissions %>"><ItemTemplate>
				<td>
					<asp:CheckBox ID="cbEveryone" Checked="<%# IsEveryone((Permission)Container.DataItem) %>" Enabled="<%# IsAuthorized(Selection.SelectedItem, (Permission)Container.DataItem) %>" runat="server" CssClass='<%# "cb permission" + Container.ItemIndex %>' />
					<asp:CustomValidator ID="cvMarker" ErrorMessage="<%# Container.DataItem.ToString() %>" Text="*" runat="server" />
				</td>
			</ItemTemplate></asp:Repeater>
			</tr>
		</tbody>
		
		<tbody class="overrides">
		<asp:Repeater ID="rptPermittedRoles" runat="server" DataSource="<%# GetAvailableRoles() %>"><ItemTemplate>
			<tr>
				<td style="width:450px;"><%# Container.DataItem %></td>
				<asp:Repeater ID="rptPermissions" runat="server" DataSource="<%# Permissions %>" 
							  OnItemDataBound="rptPermissions_ItemDataBound"
							  OnItemCreated="rptPermissions_ItemCreated"><ItemTemplate>
					<td>
						<asp:CheckBox ID="cbRole" runat="server" 
									  Checked="<%# IsRolePermitted(GetRole(Container), (Permission)Container.DataItem) %>" 
									  CssClass='<%# "cb permission" + Container.ItemIndex + " Authorized" + IsUserPermitted(GetRole(Container), (Permission)Container.DataItem) %>' />
					</td>
				</ItemTemplate></asp:Repeater>
			</tr>	
		</ItemTemplate></asp:Repeater>		
		</tbody>
    </table>
</div>
	</edit:PermissionPanel>
	</edit:PersistentOnlyPanel>
</asp:Content>
