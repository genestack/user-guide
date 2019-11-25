Setup user
##########

Profile
*******

To explore and customize your account, click on your username (your email address)
in the top-right corner of the page and, then, select the menu item **Profile**.

.. image:: images/profile-1.png

On the opening page you'll find the following sections:

.. image:: images/profile-2.png
   :scale: 70 %
   :align: center

- **Basic information** about your profile, namely *Name*, *Password*, *Email*, *Organization*, *Vendor*.
  You can change your name and password if it is needed.

- **API tokens** section create an access-token which allows to use scripts without the need to specify regular
  credential explicitly. Learn more about how to generate Genestack REST API tokens in the section :ref:`token-label`.

After you click **Generate new token** the confirmation email is sent to your email address. To generate API token,
follow the link specified in the email. This redirects you to the **Profile** where you can change token name and
download it by click **Download API token**.

.. image:: images/token.png

- **Application to show after sign in** — allows you to specify which application (Dashboard or Study Browser) should
  be your starting point.



Manage groups
*************

**Groups** are used to share files with other users, so that they are accessible for all members
of that group. Any user can create one or several groups and invite their collaborators.

Depending on a role a user have, they can have different privileges in sharing process and managing the group, namely:

- *Non-sharing* — can only view the files shared with the group, however they have no sharing permissions;
- *Sharing User* — not only have an access to the shared files but also can share data themselves;
- *Group Administrator* — in addition to the sharing user rights, can invite or remove users and change their privileges.
  By default, you'll be a group administrator of any group that is created by your user.

.. For more information on using groups and sharing files, see the "Sharing" section.

**Manage groups** application lets you to view the list of groups you are invited in as well as their members,
and manage them according to your privileges.

Click **Manage groups** in the short-cut menu to navigate to the application page.

.. image:: images/shortcuts-manage-groups.png
   :scale: 70 %
   :align: center

If you are an administrator of your organisation, you'll see two groups automatically created for you:
one group lists all members of your organisation, another one — "Curator" group — includes those members which are
granted with additional permissions by the administrator of your organisation. All members of the "Curator" group
can approve and unapprove studies.

If you are not an administrator of your organisation, then, on the Manage Group page you'll see the group including
members of your organisation, their email addresses and roles.

.. image:: images/manage-groups-members&curator.png
   :scale: 40 %
   :align: center

Regardless your role in organisation, if you have no groups yet, you can create one by click **Create group**.
In the appeared pop-up window you'll be asked to give the group a name.

.. image:: images/create-group.png
   :scale: 40 %
   :align: center

As the new group is created, you can invite other users to join by click on **Add member**.
You can also delete the created group by click on **Remove group**.

.. image:: images/add-user.png
   :scale: 40 %
   :align: center

Then, in the dialog that appears, you'll be prompted for the new member email. If they are in your organisation,
you could take advantage of autocomplete.

.. image:: images/invite-by-email.png
   :scale: 40 %
   :align: center

If you would like to invite a collaborator from other organisation to join the group,
the invitation has to be approved by an organisation administrator from both sides.
To approve incoming invitations, you should go to the **Invitations** tab.

.. image:: images/invitations-tab.png
   :scale: 40 %
   :align: center

Once you have added a user to the newly created group, you'll also
be able to set up their permissions within the group (by default, new members are non-sharing users).

.. image:: images/change-permissions.png
   :scale: 80 %
   :align: center


Manage users
************

Manage Users application allows you not only to get an overview of the existing users in your organisation,
but also to create new users. The application is accessible only if you are
an administrator of your organisation. You can check your role out in the **Profile**.

In order to open the application, you can use the shortcut menu and select **Manage Users**.

.. image:: images/shortcuts-users.png
   :scale: 40 %
   :align: center

On the application page you can change passwords of the users and make any
user administrator or lock them out of the platform.

.. image:: images/manage-users.png
   :scale: 40 %
   :align: center

To create a new user, click on the **Create user** button. In the pop-up window you should specify for
the new user their name, email and password.

.. image:: images/new-user.png
   :scale: 35 %
   :align: center

As the user is created, they can log in using the specified credentials.