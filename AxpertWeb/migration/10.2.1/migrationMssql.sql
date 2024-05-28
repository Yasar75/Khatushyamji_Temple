DROP TABLE AX_MOBILE_RESPONSE;
DROP TABLE AX_MOBILE_USER;
DROP TABLE AX_NOTIFY_WORKFLOW;
DROP TABLE AX_NOTIFY_USERS;

DROP TABLE AX_NOTIFY;

DROP TABLE AX_LAYOUTDESIGN_SAVED;
DROP TABLE AX_LAYOUTDESIGN;

CREATE TABLE AX_NOTIFY(
    NOTIFICATION_ID INT IDENTITY(1,1) PRIMARY KEY,
    TITLE VARCHAR(255),
    MESSAGE text,
    ACTIONS text,
    FROMUSER VARCHAR(255),
    BROADCAST VARCHAR(1) DEFAULT 'N',
    STATUS VARCHAR(255),
    CREATED_BY VARCHAR(255),
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    PURGE_ON_FIRST_ACTION VARCHAR(1) DEFAULT 'N',
    NOTIFICATION_SENT_DATETIME datetime DEFAULT CURRENT_TIMESTAMP,
    RECORDID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
);

CREATE TABLE AX_MOBILE_RESPONSE(
    NOTIFICATION_ID INT REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    RESPONSE TEXT, 
    PROJECT_ID VARCHAR(255)
);

CREATE TABLE AX_NOTIFY_WORKFLOW(
    NOTIFICATION_ID INT,
    RECORDID VARCHAR(255),
    APP_LEVEL VARCHAR(2),
    APP_DESC VARCHAR(2),
    CREATED_ON datetime  DEFAULT CURRENT_TIMESTAMP,
    WORKFLOW_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    lno VARCHAR(255),
    elno VARCHAR(255)
);

CREATE TABLE AX_MOBILE_USER(
    IMEI VARCHAR(255),
    USER_ID VARCHAR(255),
    PROJECT_ID VARCHAR(255),
    FIREBASE_ID VARCHAR(255),
    GROUPNAME VARCHAR(255),
    ACTIVE VARCHAR(1)
);

CREATE TABLE AX_NOTIFY_USERS(    
    NOTIFICATION_ID INT REFERENCES AX_NOTIFY(NOTIFICATION_ID) ON DELETE CASCADE,
    USER_ID VARCHAR(255),
    STATUS VARCHAR(255),
    PROJECT_ID VARCHAR(255)
);



CREATE TABLE AX_LAYOUTDESIGN(
    DESIGN_ID INT IDENTITY(1,1) PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT text,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP, 
    IS_MIGRATED VARCHAR(1) DEFAULT 'N'
);

CREATE TABLE AX_LAYOUTDESIGN_SAVED(
    DESIGN_ID INT IDENTITY(1,1) PRIMARY KEY,
    TRANSID VARCHAR(255),
    MODULE VARCHAR(255),
    CONTENT text,
    CREATED_BY VARCHAR(255),
    UPDATED_BY VARCHAR(255),
    IS_DELETED VARCHAR(1) DEFAULT 'N',
    CREATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    UPDATED_ON datetime DEFAULT CURRENT_TIMESTAMP,
    IS_MIGRATED VARCHAR(1) DEFAULT 'N',
    IS_PUBLISH VARCHAR(1) DEFAULT 'N',
    IS_PRIVATE VARCHAR(1) DEFAULT 'N',
    PARENT_DESIGN_ID INT,
    RESPONSIBILITY text,
    ORDER_BY INT
);

alter table axtasks add notify_status VARCHAR(1) DEFAULT 'N';
update ax_homebuild_saved set target = replace(target,'Wrapper','');
update ax_widget set widget_type='kpi' where widget_type='table';

