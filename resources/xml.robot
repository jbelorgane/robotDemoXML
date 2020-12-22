*** Settings ***
Library              XML
Documentation        This file contains all operations used on the xml files

*** Variables ***
${XML_FILE}                          ${CURDIR}/../data/users.xml
${XML_FILE2}                         ${CURDIR}/../data/login.xml
${DEFAULT_PASSWORD}                  d3faultp4ss

*** Keywords ***
Get First User City Name
    ${text}                          Get Element Text         ${XML_FILE}                       xpath=*/user[@id="1"]//name
    Should Be Equal                  ${text}                  Paris

Get Second User Email
    Element Text Should Be           ${XML_FILE}              jo@mail                           xpath=*/user[@id="2"]//mail
    
Get number of french users
    ${frUsers}                       Get Element Count        ${XML_FILE}                       xpath=*/user//city[@country="fr"]
    Should Be Equal As Integers      ${frUsers}               2

Get login of 2nd major user
    ${majors}                        Get Elements Texts       ${XML_FILE}                       xpath=*/user[@major="true"]/login
    Should Be Equal                  ${majors}[1]             john





Create New User Base on User with id
    [Arguments]                      ${id}
    ${xml}                           Parse Xml                ${XML_FILE}
    Set Test Variable                ${xml}                   ${xml}
    @{elmt}                          Get Elements             ${xml}                            xpath=*/user[@id="${id}"]
    ${copy}                          Copy Element             ${elmt}[0]

    Set Element Attribute            ${copy}                  id                                4
    Set Element Attribute            ${copy}                  major                             true
    Elements Should Be Equal         ${copy}                  <user id="4" major="true"></user>      exclude     normalize
    Return From Keyword              ${copy}

Add New User
    [Arguments]                      ${user}
    Add Element                      ${xml}                   ${user}                           xpath=users
    Element Should Exist             ${xml}                   xpath=*/user[@id="4"]
    ${nbUser}                        Get Element Count        ${xml}                            xpath=*/user
    Should Be Equal As Integers      ${nbUser}                4

Create New Users List    
    Save Xml                         ${xml}                   ${CURDIR}/../data/users2.xml
    Set Suite Variable               ${XML_FILE}              ${CURDIR}/../data/users2.xml
    




Identify User
    ${xml}                           Parse Xml                ${XML_FILE}
    Set Test Variable                ${xml}                   ${xml}
    ${attr}                          Get Element Attribute    ${XML_FILE}                           id                                  xpath=*/user[@major="false"]
    Should Be Equal                  ${attr}                  3
    Return From Keyword              ${attr}

Tag Modified Element
    [Arguments]                      ${id}
    Set Element Tag                  ${xml}                   newpass                               xpath=*/user[@id="${id}"]/password
    Element Should Exist             ${xml}                   xpath=*/user[@id="${id}"]/newpass
    Element Should Not Exist         ${xml}                   xpath=*/user[@id="${id}"]/password

Delete Password
    [Arguments]                      ${id}
    Clear Element                    ${xml}                   xpath=*/user[@id="${id}"]/newpass
    ${password}                      Get Element              ${xml}                                xpath=*/user[@id="${id}"]/newpass
    Elements Should Be Equal         ${password}              <newpass/>

Set New Cypher
    [Arguments]                      ${id}
    Set Element Attribute            ${xml}                   crypt                                 0                                   xpath=*/user[@id="${id}"]/newpass
    Element Attribute Should Be      ${xml}                   crypt                                 0                                   xpath=*/user[@id="${id}"]/newpass

Set New Password
    [Arguments]                      ${id}
    Set Element Text                 ${xml}                  ${DEFAULT_PASSWORD}                    xpath=*/user[@id="${id}"]/newpass
    Element Text Should Be           ${xml}                  ${DEFAULT_PASSWORD}                    xpath=*/user[@id="${id}"]/newpass
    
Save Last List    
    Save Xml                         ${xml}                  ${CURDIR}/../data/users3.xml
    




Create new user
    [Arguments]                     &{user}
    ${xml} =                        Parse Xml                   ${XML_FILE2}
    Set Test Variable               ${xml}                      ${xml}
    ${nbUsers} =                    Get Element Count           ${xml}                                                                  xpath=*/user
    Should Be Equal As Integers     ${nbUsers}                  3
    ${id} =                         Evaluate                    ${nbUsers} + 1
    Should Be Equal As Integers     ${id}                       4
    Set Test Variable               ${id}                       ${id}
    Add Element                     ${xml}                      <user id="${id}"><login></login><password></password></user>            xpath=users
    Set Element Text                ${xml}                      ${user.login}                                                           xpath=*/user[@id="${id}"]/login
    Set Element Text                ${xml}                      ${user.password}                                                        xpath=*/user[@id="${id}"]/password
    ${newUser} =                    Get Element                 ${xml}                                                                  xpath=*/user[@id="${id}"]
    Elements Should Be Equal        ${newUser}                  <user id="4"><login>R2</login><password>D2</password></user>
 
 
Validate Credentials
    [Arguments]                     &{inputUser}    
    Element Text Should Be          ${xml}                      ${inputUser.login}      xpath=*/user[@id="${id}"]/login
    Element Text Should Be          ${xml}                      ${inputUser.password}   xpath=*/user[@id="${id}"]/password
    Return From Keyword             ${id}

   
Change password
    [Arguments]                     ${selectedUserId}           ${newPassword}
    Should not be empty             ${newPassword}              /!\\ Password must not be empty /!\\
    Set Element Text                ${xml}                      ${newPassword}                                                          xpath=*/user[@id="${selectedUserId}"]/password

    
New Password Exists
    ${newUser} =                    Get Element                 ${xml}                                                                  xpath=*/user[@id="${id}"]
    Elements Should Be Equal        ${newUser}                  <user id="4"><login>R2</login><password>${NEWPASSWORD}</password></user>
    ${newUserPassword} =            Get Element Text            ${xml}                                                                  xpath=*/user[@id="${id}"]/password
    
    
Old password doesn't exist  
    ${newUser} =                    Get Element                 ${xml}                                                                  xpath=*/user[@id="${id}"]
    Should Not Be Equal As Strings  ${newUser}                  <user id="4"><login>R2</login><password>D2</password></user>
    


Delete User
    Remove Element                  ${xml}                      xpath=*/user[@id="${id}"]
    @{allUsers} =                   Get Elements                ${xml}                      */user
    FOR                             ${selectedUser}             IN                          @{allUsers}
        ${selectedId} =                 Get Element Attribute       ${selectedUser}             id
        ${selectedLogin} =              Get Element Text            ${xml}                      xpath=*/user[@id="${selectedId}"]/login
        Log To Console                  ${selectedLogin}       
    END
    
    
