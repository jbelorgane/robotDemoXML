Prerequisites :
Robot Framework installation instructions : https://github.com/robotframework/robotframework/blob/master/INSTALL.rst


Instructions :
    Simply start the demo by using "demo-xml-V2.robot" as a command line instruction.

Overview :

This test will manipulate an xml file containing a list of "users" :
    - various searchs in the 1st test cases
    - creation and insertion of a new "user" element templated on another existing user
    - modification of one of the users password to simulate a more typical cases
    
The last test case uses a gherkin-style synthax and showcases several meta Robot functionnalities.
    - selecting which case to start using tags
    - injecting variable from the CLI
    - creating custom error messages
    - writing setups/teardowns at different levels
    - using scalar, list and dictionary variables
    - using loops
    
Two copies of the original xml file (users.xml) will also be created during the execution to allow visualization of the changes in the file.

The only libraries used in the project are Built-In library (included by default in all Robot projects) and XML library.

Variables synthax :
    --variable DEFAULT_PASSWORD:{anything}
    --variable NEWPASSWORD:{anything not null}
    
Tags synthax :
    --include {tagname}
    --exclude {tagname}
The possible tags are noBDD and BDD (select or exclude the last test case)