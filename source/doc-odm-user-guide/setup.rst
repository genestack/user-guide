Setup user(s) on ODM
####################

Profile
*******

Click on your username (your email address) in the upper right corner
to have access to your profile and sign out of the platform.
Click **Profile** to explore the profile and change settings of your account if needed.

.. image:: images/profile-1.png

On the opening page you'll find the following sections:

.. image:: images/profile-2.png
   :scale: 50 %
   :align: center

- **Basic information** about your profile, namely *Name*, *Password*, *Email*, *Organization*, *Vendor*.
  You can change your name and password if it is needed.

- **API tokens** allows to create an access-token which allows to use scripts without the need to specify regular
  credential explicitly. Learn more about how to generate Genestack REST API tokens in the section :ref:`token-label`.

After click on the **Generate new token** button the confirmation email is sent to your email address. Folow the link
specified in the email to generate API token.

.. image:: images/token.png

- **Application to show after sign in** — allows to specify which application (Dashboard or Study Browser) should
  be your starting point.



Manage groups
*************

**Groups** are used to share files with other users, so that they are accessible for all members
of that group. Any user can create one or several groups and invite their collaborators.

Depending on a role a user have, they can have different privileges in sharing process and managing the group, namely:

- *Non-sharing* — can only view the files shared with the group, however they have no sharing permissions;
- *Sharing User* — not only have an access to the shared files but also can share data themselves;
- *Group Administrator* — in addition to the sharing user rights, can invite or remove users and change their privileges.
  By default, you will be a group administrator of any group that is created by your user.

.. Learn more about it in the section "Sharing":

**Manage groups** application lets you to view the list of groups you are invited in as well as their members,
and manange them according to your privileges.

Click **Manage groups** in the short-cut menu will open the application page.

.. image:: images/shortcuts-manage-groups.png
   :scale: 40 %
   :align: center

If you are an administrator of your organisation, you will see two groups automatically created for you:
one group includes all members of your organisation, another one — those members which are granted with additional
permissions by the administrator of your organisation.

If you are not an administrator of your organisation, then on the Manage Group page you will see the group including
members of your organisation, their email addresses and roles.

.. image:: images/manage-groups-members&curator.png
   :scale: 40 %
   :align: center


Regardless your role in organisation, if you have no groups yet, you can create a new group by click **Create group**.
In the appeared pop-up window you can specify a name for the group.

.. image:: images/create-group.png
   :scale: 40 %
   :align: center


As the new group is created, you can invite other users to join by click on **Add member**.
You can also delete the created group by click on **Remove group**.

.. image:: images/add-user.png
   :scale: 40 %
   :align: center

Then, you will be prompted for the new member email. If they are in your organisation,
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

Once you have added a user to the newly created group, you will also
be able to set up their permissions within the group (by default, new members are non-sharing users).

.. image:: images/change-permissions.png
   :scale: 80 %
   :align: center



Manange users
*************

Manage Users application allows you not only get an overview of the existing users in your organisation,
but also create new users. The application is accessible only if you are
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