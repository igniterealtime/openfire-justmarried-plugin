<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.jivesoftware.openfire.plugin.married.JustMarriedPlugin"%>
<%@ page import="org.jivesoftware.openfire.auth.AuthFactory" %>
<%@ page import="org.jivesoftware.openfire.user.UserManager" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:useBean id="webManager" class="org.jivesoftware.util.WebManager" />
<%
    webManager.init(request, response, session, application, out);
    String oldName = request.getParameter("oldName");
    String newName = request.getParameter("newName");
    String newPassword = request.getParameter("newPassword");
    String keepCopy = request.getParameter("copy");
    String newEmail = request.getParameter("email");
    String newRealName = request.getParameter("realName");

    final boolean supported = !UserManager.getUserPropertyProvider().isReadOnly();
%>

<html>
<head>
<title>Just married - name changer</title>
<meta name="pageID" content="justmarried" />
<meta name="helpPage" content="" />
<script src="./js/bootstrap.min.js" type="text/javascript"></script>
<link href="./css/bootstrap.min.css" rel="stylesheet" type="text/css">

</head>
<body>

    <% if (!supported) { %>
    <div class="jive-warning">
        <table>
            <tbody>
            <tr>
                <td class="jive-icon"><img src="/images/warning-16x16.gif" alt=""/></td>
                <td class="jive-icon-label">
                    This instance of Openfire does not support this feature, as its user-base is 'read-only' (likely due to being obtained from a remote directory service).
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <br />
    <% } %>

    <div class="jive-contentBoxHeader">Just married</div>
    <div class="jive-contentBox">
        <%
            if (oldName != null && newName != null && oldName.trim().length() > 0 && newName.trim().length() > 0) {
                boolean success = JustMarriedPlugin.changeName(oldName, newName, keepCopy == null ? true : false, newEmail, newRealName, newPassword);
                if (success) {
                    out.write("<div class=\"success\">Successfully renamed user " + oldName + " to " + newName
                            + "!</div>");
                } else {
                    out.write("<div class=\"error\">Something went wrong :-/. Please have a closer look to the error log!</div>");
                }
            } else {
        %>
        <form class="form-horizontal">
            <fieldset>
                <legend>Change the name here</legend>
                <label class="control-label" for="input01">Current username*</label>
                <div
                    <%out.write(oldName != null && oldName.length() == 0 ? "class=\"control-group error\""
                        : "class=\"controls\"");%>>
                    <input type="text" name="oldName" style="height:26px"
                        class="input-xlarge"
                        <%out.write(oldName != null && oldName.length() == 0 ? "id=\"inputError\"" : "id=\"input01\"");%> <%=supported?"":"disabled"%> required>
                    <p class="help-block">The current username e.g user.name
                        (without server)</p>
                </div>
                <label class="control-label" for="input01">New username*</label>
                <div
                    <%out.write(newName != null && newName.length() == 0 ? "class=\"control-group error\""
                        : "class=\"controls\"");%>>
                    <input type="text" name="newName" style="height:26px"
                        class="input-xlarge"
                        <%out.write(newName != null && newName.length() == 0 ? "id=\"inputError\"" : "id=\"input01\"");%> <%=supported?"":"disabled"%> required>
                    <p class="help-block">The new username e.g. user.newname
                        (without server)</p>
                </div>
                <label class="control-label" for="input01">New Password<%=AuthFactory.supportsPasswordRetrieval()?"":"*"%></label>
                <div
                    <%out.write(newName != null && newName.length() == 0 ? "class=\"control-group error\""
                        : "class=\"controls\"");%>>
                    <input type="password" name="newPassword" style="height:26px"
                           class="input-xlarge"
                        <%out.write(newName != null && newName.length() == 0 ? "id=\"inputError\"" : "id=\"input01\"");%> <%=supported?"":"disabled"%> <%=AuthFactory.supportsPasswordRetrieval()?"":"required"%>>
                    <p class="help-block">The new password for this user. <%=AuthFactory.supportsPasswordRetrieval()?"Leave empty to keep the old password.":""%></p>
                </div>

                <label class="control-label" for="input01">New E-Mail address</label>
                <div class="controls">
                    <input type="text" name="email" style="height:26px"
                        class="input-xlarge" id="input01" <%=supported?"":"disabled"%>>
                    <p class="help-block">New email address. Will copy address from old user if field is empty.</p>
                </div>
                <label class="control-label" for="input01">New Name</label>
                <div class="controls">
                    <input type="text" name="realName" style="height:26px"
                        class="input-xlarge" id="input01" <%=supported?"":"disabled"%>>
                    <p class="help-block">Will copy name from old user if field is empty.</p>
                </div>
                <div class="control-group">
                    <label class="checkbox"> <input type="checkbox"
                        id="optionsCheckbox2" name="copy" value="keepCopy" <%=supported?"":"disabled"%>> Keep a
                        copy of the old username
                    </label>
                </div>
                <div class="control-group">
                    <button type="submit" class="btn btn-primary" <%=supported?"":"disabled"%>>Rename user</button>
                </div>
                <p class="help-block">* Mandatory item</p>
            </fieldset>
        </form>

        <%
            }
        %>

    </div>
</body>
</html>
