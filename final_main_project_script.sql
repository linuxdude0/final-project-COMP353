DROP DATABASE php_db;
CREATE DATABASE php_db;
use php_db;

CREATE TABLE Email(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    sender_email VARCHAR(1024), -- location
    dest_email VARCHAR(1024),
    email_title VARCHAR(1024),
    email_body VARCHAR(100)
);

CREATE TABLE Users(
    userID INTEGER PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(1024),
    lastName VARCHAR(1024),
    gender CHAR(1) NOT NULL,
    dateOfBirth DATE,
    SSN CHAR(9) UNIQUE,
    medicare CHAR(12) UNIQUE,
    address VARCHAR(1024),
    postalCode CHAR(6),
    province CHAR(2),
    city VARCHAR(1024),
    phone VARCHAR(15),
    email VARCHAR(256),
    CHECK(gender IN ('M', 'F'))
);

CREATE TABLE Personnel(
    staffID INTEGER PRIMARY KEY,
    role VARCHAR(1024) DEFAULT 'another',
    mandate VARCHAR(1024) NOT NULL,
    CONSTRAINT fk_staff_user FOREIGN KEY(staffID) REFERENCES Users(userID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK(role IN ('admin', 'trainer', 'another')),
    CHECK(mandate IN ('salary', 'volunteer'))
);

CREATE TABLE SecondaryFamilyMember(
    secondaryFamID INTEGER PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(256) NOT NULL,
    lastName VARCHAR(256),
    phone VARCHAR(256) NOT NULL
);

CREATE TABLE FamilyMember(
    famID INTEGER PRIMARY KEY,
    secondaryFamID INTEGER,
    secondaryFamRelation VARCHAR(256),
    CONSTRAINT fk_family_member_user FOREIGN KEY(famID) REFERENCES Users(userID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_family_member_secondary_fam FOREIGN KEY(secondaryFamID) REFERENCES SecondaryFamilyMember(secondaryFamID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE ClubMember(
    clubID INTEGER PRIMARY KEY,
    famMemberID INTEGER NOT NULL,
    familyRelation VARCHAR(1024) DEFAULT 'undefined',
    CONSTRAINT fk_club_user FOREIGN KEY (clubID) REFERENCES Users(userID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    CONSTRAINT fk_club_family FOREIGN KEY (famMemberID) REFERENCES FamilyMember(famID)
    ON UPDATE CASCADE
    ON DELETE SET DEFAULT,
    CHECK (familyRelation IN ('father', 'mother', 'grandfather', 'grandmother', 'tutor', 'partner', 'friend', 'other'))
);

CREATE TABLE Location(
    locID INTEGER PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(128),
    address VARCHAR(1024) NOT NULL,
    city VARCHAR(1024) NOT NULL,
    postalCode CHAR(6),
    province CHAR(2),
    tel VARCHAR(15),
    website VARCHAR(1024),
    type VARCHAR(1024) NOT NULL,
    capacity INTEGER,
    CHECK(type IN ('head', 'branch'))
);

CREATE TABLE LocationOperatingStaff(
    locID INTEGER,
    staffID INTEGER,
    startDate DATE,
    endDate DATE,
    CONSTRAINT fk_location_operating_staff
        FOREIGN KEY(staffID) REFERENCES Personnel(staffID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_operating_staff_location
        FOREIGN KEY(locID) REFERENCES Location(locID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY(locID, staffID, startDate)
);

CREATE TABLE GeneralManagement(
    locID INTEGER,
    staffID INTEGER,
    startDate DATE,
    endDate DATE,
    PRIMARY KEY(locID, staffID),
    CONSTRAINT fk_general_management_location FOREIGN KEY(locID) REFERENCES Location(locID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_general_management_staff FOREIGN KEY(staffID) REFERENCES Personnel(staffID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE RegistrationAtLocation(
    locID INTEGER,
    famID INTEGER,
    startDate DATE,
    endDate DATE,
    PRIMARY KEY(locID, famID, startDate),
    CONSTRAINT fk_registration_location FOREIGN KEY(locID) REFERENCES Location(locID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_registration_family FOREIGN KEY(famID) REFERENCES FamilyMember(famID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Team(
    teamID INTEGER PRIMARY KEY AUTO_INCREMENT,
    teamType VARCHAR(5) NOT NULL,
    teamCoachID INTEGER,
    teamLocation INTEGER,
    FOREIGN KEY(teamCoachID) REFERENCES Personnel(staffID)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CHECK(teamType IN ('boys', 'girls')),
    FOREIGN KEY(teamLocation) REFERENCES Location(locID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);


CREATE TABLE Session(
    teamOneID INTEGER,
    teamTwoID INTEGER,
    time TIMESTAMP,
    scoreOne INTEGER,
    scoreTwo INTEGER,
    address VARCHAR(1024),
    type VARCHAR(16),
    PRIMARY KEY(teamOneID, teamTwoID, time),
    FOREIGN KEY(teamOneID) REFERENCES Team(teamID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY(teamTwoID) REFERENCES Team(teamID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK(type IN ('game', 'training'))
);

CREATE TABLE ClubMemberPartOfTeam(
    clubID INTEGER,
    teamID INTEGER,
    roleOnTeam VARCHAR(255),
    PRIMARY KEY(clubID, teamID),
    FOREIGN KEY (clubID) REFERENCES ClubMember(clubID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (teamID) REFERENCES Team(teamID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK(roleOnTeam IN ('goalkeeper','defender','midfielder','forward'))
);


-- admins with id 10...
-- trainers with id 20...
-- volunteers with id 30...
-- employee inserts
INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(1001, 'John', 'Smith', 'M', '2000-04-15', '076204020', 'A42534261028', '416 Main St', 'VGAEFL', 'QC', 'Montreal', '555-0710', 'przdo@example.com'),
(1002, 'Sara', 'Smith', 'F', '1974-01-25', '645749953', 'A41085858549', '569 Main St', 'P1RJQO', 'QC', 'Montreal', '555-7099', 'phbpt@example.com'),
(1003, 'Kate', 'Smith', 'F', '1976-07-01', '827711383', 'A49160804368', '747 Main St', 'G2QMC8', 'QC', 'Montreal', '555-9964', 'lsacw@example.com'),
(1004, 'Anna', 'Smith', 'F', '1986-12-10', '794168224', 'A12979751094', '998 Main St', '51A9BV', 'QC', 'Montreal', '555-5056', 'bsold@example.com'),
(1005, 'Tom', 'Johnson', 'M', '1999-04-29', '698670643', 'A32050759707', '129 Main St', '9TRVHX', 'QC', 'Montreal', '555-8662', 'avpgz@example.com'),
(1006, 'Mike', 'Brown', 'M', '1990-08-24', '173897636', 'A39893137747', '158 Main St', 'GIBVUI', 'QC', 'Montreal', '555-5124', 'hykmp@example.com'),
(1007, 'Kate', 'Johnson', 'F', '1984-01-04', '251057750', 'A76996213966', '226 Main St', '2FAV5C', 'QC', 'Montreal', '555-6837', 'anhek@example.com'),
(1008, 'Mike', 'Brown', 'M', '1980-01-02', '529710774', 'A66626205392', '741 Main St', '4218IG', 'QC', 'Montreal', '555-5686', 'wgzph@example.com'),
(1009, 'John', 'Doe', 'M', '1998-04-04', '152916498', 'A55765408367', '176 Main St', '75RYTN', 'QC', 'Montreal', '555-9149', 'hwysi@example.com'),
(1010, 'Mike', 'Davis', 'M', '1985-08-28', '766255573', 'A63939416710', '554 Main St', 'VNFRHZ', 'QC', 'Montreal', '555-7950', 'ztykl@example.com'),
(2001, 'Kate', 'Doe', 'F', '1978-08-03', '423027842', 'A12019063690', '783 Main St', '133DPG', 'QC', 'Montreal', '555-0889', 'focau@example.com'),
(2002, 'Kate', 'Doe', 'F', '1987-12-27', '333307354', 'A95081749887', '662 Main St', 'CGBMV8', 'QC', 'Montreal', '555-8029', 'yxkbh@example.com'),
(2003, 'Mike', 'Johnson', 'M', '1981-07-03', '777423861', 'A64459490682', '558 Main St', 'XOPM8A', 'QC', 'Montreal', '555-8537', 'byilv@example.com'),
(2004, 'Jane', 'Brown', 'F', '1991-05-09', '791387427', 'A68839451557', '393 Main St', 'ZKMQBA', 'QC', 'Montreal', '555-7102', 'uzjcm@example.com'),
(2005, 'John', 'Johnson', 'M', '1984-02-21', '157704012', 'A16560169053', '728 Main St', '15OADJ', 'QC', 'Montreal', '555-3849', 'cxzni@example.com'),
(2006, 'John', 'Smith', 'M', '1985-01-29', '235290140', 'A78217182785', '476 Main St', '06KYPL', 'QC', 'Montreal', '555-3344', 'afnwi@example.com'),
(2007, 'Mike', 'Doe', 'M', '1981-09-26', '870655003', 'A83810747615', '508 Main St', 'TPOEYR', 'QC', 'Montreal', '555-1763', 'mlahv@example.com'),
(2008, 'Sara', 'Brown', 'F', '1997-03-21', '318914610', 'A64687089355', '842 Main St', 'LDQPGA', 'QC', 'Montreal', '555-6096', 'ubmwt@example.com'),
(2009, 'Kate', 'Doe', 'F', '1979-02-09', '979736508', 'A80474859751', '231 Main St', 'B0M3TI', 'QC', 'Montreal', '555-1714', 'xdjpt@example.com'),
(2010, 'David', 'Johnson', 'M', '1986-04-25', '536876267', 'A73218435718', '395 Main St', 'XO8PGZ', 'QC', 'Montreal', '555-6300', 'efiqu@example.com'),
(3001, 'Anna', 'Smith', 'F', '1974-12-01', '109289126', 'A57498479469', '367 Main St', 'Z8DC1A', 'QC', 'Montreal', '555-1404', 'wifjs@example.com'),
(3002, 'Chris', 'Doe', 'M', '1982-03-27', '243603589', 'A96251842685', '218 Main St', 'RLZX5I', 'QC', 'Montreal', '555-7093', 'sorle@example.com'),
(3003, 'Mike', 'Johnson', 'M', '1986-11-18', '715725934', 'A51864025793', '181 Main St', 'BPT4M5', 'QC', 'Montreal', '555-2690', 'wgrcz@example.com'),
(3004, 'Jane', 'Brown', 'F', '1990-12-19', '828679256', 'A47839151062', '390 Main St', 'M3Z9QG', 'QC', 'Montreal', '555-8296', 'zojyq@example.com'),
(3005, 'John', 'Davis', 'M', '1988-06-06', '203561487', 'A87352174916', '279 Main St', 'LD6W3M', 'QC', 'Montreal', '555-0489', 'rpkch@example.com');
-- parents
INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(8001, 'Tom', 'Davis', 'M', '1989-09-02', '773003859', 'A21089547404', '674 Main St', '2PPIDR', 'QC', 'Montreal', '555-0748', 'hjuni@example.com'),
(8002, 'John', 'Smith', 'M', '1980-02-06', '041765332', 'A62983035086', '557 Main St', 'U6ZH91', 'QC', 'Montreal', '555-6981', 'jufhh@example.com'),
(8003, 'David', 'Doe', 'M', '1995-10-18', '545281263', 'A29240969251', '374 Main St', 'ZCLN8G', 'QC', 'Montreal', '555-4154', 'jzrej@example.com'),
(8004, 'David', 'Davis', 'M', '1987-11-24', '518013946', 'A04185218662', '702 Main St', 'YUZ7LV', 'QC', 'Montreal', '555-3207', 'agadf@example.com'),
(8005, 'Tom', 'Brown', 'M', '1975-12-30', '791845116', 'A74363256949', '860 Main St', 'PJP6U0', 'QC', 'Montreal', '555-6889', 'awoor@example.com'),
(8006, 'David', 'Doe', 'M', '1987-06-03', '787755085', 'A14788107837', '507 Main St', 'KW67UF', 'QC', 'Montreal', '555-6324', 'kwxdz@example.com'),
(8007, 'Laura', 'Brown', 'F', '1987-06-18', '340077241', 'A16558747715', '431 Main St', '187VDS', 'QC', 'Montreal', '555-1562', 'phlyr@example.com'),
(8008, 'Kate', 'Davis', 'F', '1977-12-02', '632969418', 'A06533791742', '272 Main St', 'IWQRWN', 'QC', 'Montreal', '555-8247', 'rfryo@example.com'),
(8009, 'Anna', 'Johnson', 'F', '1997-05-18', '898290230', 'A78740488581', '225 Main St', 'XX9NRE', 'QC', 'Montreal', '555-1093', 'bkpjl@example.com'),
(8010, 'Tom', 'Davis', 'M', '1996-08-12', '034899073', 'A25078367485', '803 Main St', 'T6TMWA', 'QC', 'Montreal', '555-9226', 'faeeh@example.com'),
(8011, 'Laura', 'Davis', 'F', '1984-08-14', '491676805', 'A49728834114', '474 Main St', '983MX1', 'QC', 'Montreal', '555-9102', 'rtnwv@example.com'),
(8012, 'Chris', 'Doe', 'M', '1994-02-19', '443532977', 'A10640835827', '768 Main St', 'GREJE6', 'QC', 'Montreal', '555-3638', 'tdpaj@example.com'),
(8013, 'Laura', 'Smith', 'F', '1982-07-04', '989479144', 'A06677575950', '201 Main St', 'LO58TT', 'QC', 'Montreal', '555-0760', 'yrerc@example.com'),
(8014, 'John', 'Doe', 'M', '1975-05-20', '833188929', 'A44626283432', '207 Main St', '51VD1C', 'QC', 'Montreal', '555-7924', 'snijx@example.com'),
(8015, 'David', 'Doe', 'M', '1999-12-14', '032578809', 'A61439031730', '768 Main St', 'PKNQL1', 'QC', 'Montreal', '555-9416', 'gvija@example.com'),
(8016, 'Kate', 'Johnson', 'F', '1981-07-30', '919280374', 'A56578206477', '856 Main St', '4DTUOW', 'QC', 'Montreal', '555-0652', 'fgivd@example.com'),
(8017, 'Mike', 'Doe', 'M', '1998-03-22', '244489289', 'A00431246768', '575 Main St', 'O677ZO', 'QC', 'Montreal', '555-9579', 'jkypx@example.com'),
(8018, 'John', 'Davis', 'M', '1990-11-21', '063588179', 'A57866982903', '217 Main St', 'SNTD77', 'QC', 'Montreal', '555-7610', 'lmvgu@example.com'),
(8019, 'Laura', 'Brown', 'F', '2000-04-01', '293571067', 'A47429549393', '381 Main St', 'YV325P', 'QC', 'Montreal', '555-8284', 'vyevy@example.com'),
(8020, 'John', 'Johnson', 'M', '1985-02-06', '414843024', 'A93462131175', '186 Main St', 'XDMJ5E', 'QC', 'Montreal', '555-3084', 'xypig@example.com'),
(8021, 'Tom', 'Davis', 'M', '1984-01-19', '781688278', 'A46299078121', '130 Main St', 'GE4HVZ', 'QC', 'Montreal', '555-6754', 'isryl@example.com'),
(8022, 'Kate', 'Brown', 'F', '1977-08-12', '417452690', 'A12429364348', '242 Main St', 'O4Y5IP', 'QC', 'Montreal', '555-6322', 'zgywo@example.com'),
(8023, 'Kate', 'Brown', 'F', '1993-08-15', '548942905', 'A54541630182', '429 Main St', 'OJ4ISU', 'QC', 'Montreal', '555-8057', 'qljrn@example.com'),
(8024, 'John', 'Johnson', 'M', '1978-10-06', '960653736', 'A49694174543', '290 Main St', '42FF1Z', 'QC', 'Montreal', '555-2597', 'xcqmf@example.com'),
(8025, 'Tom', 'Johnson', 'M', '1978-01-12', '803987928', 'A04275761349', '166 Main St', 'F4LDP9', 'QC', 'Montreal', '555-3706', 'fplyv@example.com');
-- kids: 91 code for boys, 92 code for girls
INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(9101, 'David', 'Brown', 'M', '2016-06-02', '213585345', 'A28769319728', '761 Main St', 'I8N8H2', 'QC', 'Montreal', '555-7352', 'yyiue@example.com'),
(9102, 'David', 'Johnson', 'M', '2018-07-10', '675928801', 'A79839173808', '508 Main St', 'F29UMB', 'QC', 'Montreal', '555-8729', 'asbge@example.com'),
(9103, 'David', 'Smith', 'M', '2016-05-20', '018096420', 'A77108354093', '154 Main St', '4ULGOI', 'QC', 'Montreal', '555-4567', 'uaexl@example.com'),
(9104, 'Tom', 'Davis', 'M', '2016-06-11', '871964014', 'A25497321011', '327 Main St', 'R24EAE', 'QC', 'Montreal', '555-2462', 'icqpg@example.com'),
(9105, 'John', 'Doe', 'M', '2020-03-13', '536010509', 'A15135461628', '397 Main St', '8BIU7Z', 'QC', 'Montreal', '555-4757', 'lsrwq@example.com'),
(9106, 'Tom', 'Johnson', 'M', '2014-09-29', '839004949', 'A73787722399', '635 Main St', 'GJIIMG', 'QC', 'Montreal', '555-8968', 'dhzto@example.com'),
(9107, 'David', 'Doe', 'M', '2020-03-27', '456337836', 'A41424986757', '355 Main St', 'AFLADJ', 'QC', 'Montreal', '555-6050', 'khhxu@example.com'),
(9108, 'Mike', 'Smith', 'M', '2018-11-23', '386804229', 'A88982634051', '552 Main St', 'THAPVY', 'QC', 'Montreal', '555-0977', 'jihfk@example.com'),
(9109, 'Chris', 'Johnson', 'M', '2015-10-08', '156264796', 'A69809802380', '209 Main St', 'T4JN33', 'QC', 'Montreal', '555-6482', 'vsqxg@example.com'),
(9110, 'Chris', 'Johnson', 'M', '2016-11-09', '494903111', 'A76378256451', '856 Main St', 'LMWGU8', 'QC', 'Montreal', '555-0499', 'jgjdn@example.com'),
(9111, 'John', 'Doe', 'M', '2019-03-25', '024052215', 'A89286386309', '926 Main St', 'DEAET9', 'QC', 'Montreal', '555-2991', 'cefxb@example.com'),
(9112, 'John', 'Doe', 'M', '2014-12-06', '991795060', 'A37845652879', '997 Main St', 'I6ZD4K', 'QC', 'Montreal', '555-4977', 'modda@example.com'),
(9113, 'John', 'Brown', 'M', '2016-11-26', '991693935', 'A81943938982', '112 Main St', 'OWQAUI', 'QC', 'Montreal', '555-2018', 'yrrjw@example.com'),
(9114, 'John', 'Smith', 'M', '2020-03-07', '776822283', 'A16145401915', '337 Main St', 'ZGV1YK', 'QC', 'Montreal', '555-7933', 'bpnph@example.com'),
(9115, 'Tom', 'Johnson', 'M', '2018-07-30', '764325092', 'A03867885903', '313 Main St', 'IPR6WB', 'QC', 'Montreal', '555-4140', 'jpzsr@example.com'),
(9116, 'Mike', 'Brown', 'M', '2020-06-29', '707306852', 'A35677058491', '153 Main St', '13HZK4', 'QC', 'Montreal', '555-0649', 'jjehy@example.com'),
(9117, 'Tom', 'Doe', 'M', '2016-05-21', '143597166', 'A45289053125', '205 Main St', '4SFDY6', 'QC', 'Montreal', '555-8391', 'kufgo@example.com'),
(9118, 'David', 'Smith', 'M', '2014-12-20', '673589831', 'A71429068713', '753 Main St', 'KTU5JG', 'QC', 'Montreal', '555-0164', 'hexcu@example.com'),
(9119, 'Tom', 'Smith', 'M', '2019-06-06', '994061394', 'A74863296189', '391 Main St', 'YLM0ZS', 'QC', 'Montreal', '555-7801', 'srkvd@example.com'),
(9120, 'Mike', 'Brown', 'M', '2017-07-29', '402658130', 'A52601420597', '556 Main St', 'O7CSKW', 'QC', 'Montreal', '555-5762', 'fndug@example.com'),
(9121, 'David', 'Smith', 'M', '2016-03-18', '831593582', 'A69530812456', '277 Main St', 'N5ERLH', 'QC', 'Montreal', '555-3179', 'moquy@example.com'),
(9122, 'David', 'Doe', 'M', '2016-02-27', '652350891', 'A93205932840', '593 Main St', 'J58WDB', 'QC', 'Montreal', '555-6905', 'amigr@example.com'),
(9123, 'Chris', 'Brown', 'M', '2016-09-14', '893651230', 'A98654179042', '670 Main St', 'BFW2VZ', 'QC', 'Montreal', '555-4602', 'dpqrs@example.com'),
(9124, 'Mike', 'Johnson', 'M', '2019-08-26', '728765943', 'A21467958320', '268 Main St', '7QAZIH', 'QC', 'Montreal', '555-0765', 'xqzot@example.com'),
(9125, 'Mike', 'Brown', 'M', '2014-11-12', '537498210', 'A19274950876', '235 Main St', 'DFGBJ4', 'QC', 'Montreal', '555-4213', 'jfdvl@example.com'),
(9201, 'Jane', 'Doe', 'F', '2014-08-18', '317953680', 'A01758620439', '118 Main St', '5SRAEL', 'QC', 'Montreal', '555-4316', 'qntbs@example.com'),
(9202, 'Anna', 'Smith', 'F', '2016-03-01', '644976258', 'A17235905843', '476 Main St', '8U3DTN', 'QC', 'Montreal', '555-6907', 'urpel@example.com'),
(9203, 'Sara', 'Doe', 'F', '2020-05-24', '240825173', 'A56247953180', '563 Main St', 'GZHJ3V', 'QC', 'Montreal', '555-3210', 'pkrqx@example.com'),
(9204, 'Kate', 'Smith', 'F', '2015-12-04', '648175392', 'A48162093074', '739 Main St', 'L83WMA', 'QC', 'Montreal', '555-1928', 'ecsvr@example.com'),
(9205, 'Jane', 'Johnson', 'F', '2016-01-22', '594731086', 'A80136204917', '235 Main St', '8DWEPR', 'QC', 'Montreal', '555-4561', 'wnvgr@example.com'),
(9206, 'Laura', 'Doe', 'F', '2019-11-08', '197568042', 'A95804721360', '118 Main St', 'ND8H5L', 'QC', 'Montreal', '555-8263', 'paeyv@example.com'),
(9207, 'Sara', 'Brown', 'F', '2015-09-19', '871569042', 'A20184930567', '485 Main St', 'WG6DZ1', 'QC', 'Montreal', '555-6243', 'gshro@example.com'),
(9208, 'Anna', 'Johnson', 'F', '2016-11-23', '506823491', 'A74862014982', '502 Main St', '7SPHR9', 'QC', 'Montreal', '555-4695', 'anvjy@example.com'),
(9209, 'Kate', 'Smith', 'F', '2018-08-16', '832146579', 'A67028345190', '325 Main St', 'D3ZQFA', 'QC', 'Montreal', '555-7385', 'ztfmc@example.com'),
(9210, 'Laura', 'Smith', 'F', '2015-05-18', '951207843', 'A89204617250', '210 Main St', 'UXRQJ9', 'QC', 'Montreal', '555-9824', 'uryts@example.com'),
(9211, 'Sara', 'Johnson', 'F', '2014-09-23', '102587964', 'A23497851906', '625 Main St', 'FGQW9X', 'QC', 'Montreal', '555-1760', 'yhwvp@example.com'),
(9212, 'Jane', 'Doe', 'F', '2020-02-14', '412680354', 'A01675842937', '818 Main St', '3JXRT7', 'QC', 'Montreal', '555-7461', 'ubkzj@example.com'),
(9213, 'Laura', 'Doe', 'F', '2018-05-19', '779774114', 'A89468193631', '433 Main St', 'TASD3W', 'QC', 'Montreal', '555-0817', 'kjkur@example.com'),
(9214, 'Laura', 'Brown', 'F', '2019-02-03', '543184497', 'A12398308403', '361 Main St', 'SNPQ9M', 'QC', 'Montreal', '555-4404', 'kxwts@example.com'),
(9215, 'Jane', 'Smith', 'F', '2016-03-04', '703191714', 'A46757256167', '777 Main St', '14S5JK', 'QC', 'Montreal', '555-1640', 'obrpq@example.com'),
(9216, 'Jane', 'Johnson', 'F', '2015-03-24', '759843431', 'A75868789007', '914 Main St', 'W3T7EG', 'QC', 'Montreal', '555-3493', 'cmsum@example.com'),
(9217, 'Jane', 'Brown', 'F', '2018-03-23', '356459715', 'A77951199854', '867 Main St', 'D3NJXL', 'QC', 'Montreal', '555-5583', 'ngqlx@example.com'),
(9218, 'Anna', 'Brown', 'F', '2015-12-12', '100178335', 'A10668635759', '719 Main St', 'DH6UBJ', 'QC', 'Montreal', '555-6529', 'sgqvd@example.com'),
(9219, 'Laura', 'Doe', 'F', '2015-05-01', '847190643', 'A66099090195', '903 Main St', 'YHADBT', 'QC', 'Montreal', '555-7142', 'kgyys@example.com'),
(9220, 'Jane', 'Brown', 'F', '2015-04-25', '345241727', 'A26331626170', '794 Main St', '76J2VH', 'QC', 'Montreal', '555-6249', 'idfax@example.com'),
(9221, 'Kate', 'Doe', 'F', '2020-01-08', '604082353', 'A56600899253', '843 Main St', 'TRXE8H', 'QC', 'Montreal', '555-0697', 'rbiel@example.com'),
(9222, 'Sara', 'Davis', 'F', '2020-06-17', '186536499', 'A41101574617', '644 Main St', 'W99J1F', 'QC', 'Montreal', '555-5794', 'xlwsz@example.com'),
(9223, 'Kate', 'Smith', 'F', '2014-08-18', '817777079', 'A33382032423', '190 Main St', 'GUHRRR', 'QC', 'Montreal', '555-0556', 'sateu@example.com'),
(9224, 'Anna', 'Brown', 'F', '2016-06-18', '417509368', 'A01091068608', '235 Main St', 'XFC8WN', 'QC', 'Montreal', '555-6383', 'snogq@example.com'),
(9225, 'Kate', 'Doe', 'F', '2016-07-01', '000803585', 'A03652219130', '836 Main St', '6SXKJ8', 'QC', 'Montreal', '555-3130', 'woyie@example.com');


-- a parent who switched many locations
INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(8026, 'Michael', 'Smith', 'M', '1985-05-25', '876543210', 'A12345678901', '500 Main St', 'H2Z1A4', 'QC', 'Montreal', '555-1234', 'michael.smith@example.com');
-- these are the kids who switched more than 4 locations in the last 2 years and are still active
INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(9226, 'Emma', 'Brown', 'F', '2015-08-05', '284159348', 'A62158749620', '118 Main St', '5SRAEL', 'QC', 'Montreal', '555-4316', 'emma.brown@example.com'),
(9227, 'Liam', 'Smith', 'M', '2016-04-17', '517346285', 'A23154867930', '476 Main St', '8U3DTN', 'QC', 'Montreal', '555-6907', 'liam.smith@example.com'),
(9228, 'Olivia', 'Johnson', 'F', '2015-12-14', '728145309', 'A31765204893', '563 Main St', 'GZHJ3V', 'QC', 'Montreal', '555-3210', 'olivia.johnson@example.com'),
(9229, 'Noah', 'Doe', 'M', '2016-06-09', '396728450', 'A74682039564', '739 Main St', 'L83WMA', 'QC', 'Montreal', '555-1928', 'noah.doe@example.com'),
(9230, 'Sophia', 'Davis', 'F', '2015-09-25', '839451762', 'A85036291740', '235 Main St', '8DWEPR', 'QC', 'Montreal', '555-4561', 'sophia.davis@example.com');



-- Admins (Salary)
INSERT INTO Personnel (staffID, role, mandate) VALUES
(1001, 'admin', 'salary'),
(1002, 'admin', 'salary'),
(1003, 'admin', 'salary'),
(1004, 'admin', 'salary'),
(1005, 'admin', 'salary'),
(1006, 'admin', 'salary'),
(1007, 'admin', 'salary'),
(1008, 'admin', 'salary'),
(1009, 'admin', 'salary'),
(1010, 'admin', 'salary');
-- Trainers (Salary)
INSERT INTO Personnel (staffID, role, mandate) VALUES
(2001, 'trainer', 'salary'),
(2002, 'trainer', 'salary'),
(2003, 'trainer', 'salary'),
(2004, 'trainer', 'salary'),
(2005, 'trainer', 'salary'),
(2006, 'trainer', 'salary'),
(2007, 'trainer', 'salary'),
(2008, 'trainer', 'salary'),
(2009, 'trainer', 'salary'),
(2010, 'trainer', 'salary');
-- Other (Volunteers)
INSERT INTO Personnel (staffID, role, mandate) VALUES
(3001, 'another', 'volunteer'),
(3002, 'another', 'volunteer'),
(3003, 'another', 'volunteer'),
(3004, 'another', 'volunteer'),
(3005, 'another', 'volunteer');




INSERT INTO SecondaryFamilyMember (secondaryFamID, firstName, lastName, phone) VALUES
(1, 'John', 'Doe', '555-1234'),
(2, 'Jane', 'Smith', '555-5678'),
(3, 'Alice', 'Johnson', '555-9101'),
(4, 'Bob', 'Brown', '555-1122'),
(5, 'Carol', 'Davis', '555-3344'),
(6, 'David', 'Miller', '555-5566'),
(7, 'Eve', 'Wilson', '555-7788'),
(8, 'Frank', 'Moore', '555-9900'),
(9, 'Grace', 'Taylor', '555-2233'),
(10, 'Hank', 'Anderson', '555-4455');
-- Family members with secondary family members
INSERT INTO FamilyMember (famID, secondaryFamID, secondaryFamRelation) VALUES
(8001, 1, 'father'),
(8002, 2, 'friend'),
(8003, 3, 'friend'),
(8004, 4, 'father'),
(8005, 5, 'aunt'),
(8006, 6, 'father'),
(8007, 7, 'mother'),
(8008, 8, 'father'),
(8009, 9, 'mother'),
(8010, 10, 'father');
-- Family members without secondary family members
INSERT INTO FamilyMember (famID) VALUES
(8011),
(8012),
(8013),
(8014),
(8015),
(8016),
(8017),
(8018),
(8019),
(8020),
(8021),
(8022),
(8023),
(8024),
(8025),
(8026);

-- Boys (userID starting with 91)
INSERT INTO ClubMember (clubID, famMemberID, familyRelation) VALUES
(9101, 8001, 'father'),
(9102, 8002, 'father'),
(9103, 8003, 'father'),
(9104, 8004, 'grandfather'),
(9105, 8005, 'other'),
(9106, 8006, 'father'),
(9107, 8007, 'mother'),
(9108, 8008, 'mother'),
(9109, 8009, 'grandmother'),
(9110, 8010, 'father'),
(9111, 8011, 'mother'),
(9112, 8012, 'father'),
(9113, 8013, 'mother'),
(9114, 8014, 'father'),
(9115, 8015, 'father'),
(9116, 8016, 'mother'),
(9117, 8017, 'father'),
(9118, 8018, 'grandfather'),
(9119, 8019, 'other'),
(9120, 8020, 'friend'),
(9121, 8021, 'father'),
(9122, 8022, 'mother'),
(9123, 8023, 'grandmother'),
(9124, 8024, 'friend'),
(9125, 8025, 'friend');
-- Girls (userID starting with 92)
INSERT INTO ClubMember (clubID, famMemberID, familyRelation) VALUES
(9201, 8001, 'father'),
(9202, 8002, 'father'),
(9203, 8003, 'father'),
(9204, 8004, 'grandfather'),
(9205, 8005, 'other'),
(9206, 8006, 'father'),
(9207, 8007, 'mother'),
(9208, 8008, 'mother'),
(9209, 8009, 'grandmother'),
(9210, 8010, 'father'),
(9211, 8011, 'mother'),
(9212, 8012, 'father'),
(9213, 8013, 'mother'),
(9214, 8014, 'father'),
(9215, 8015, 'father'),
(9216, 8016, 'mother'),
(9217, 8017, 'father'),
(9218, 8018, 'grandfather'),
(9219, 8019, 'other'),
(9220, 8020, 'friend'),
(9221, 8021, 'father'),
(9222, 8022, 'mother'),
(9223, 8023, 'grandmother'),
(9224, 8024, 'friend'),
(9225, 8025, 'friend');


--kids with 5 location switches in the last 2 years
-- Insert the kids as club members related to Michael Smith
INSERT INTO ClubMember (clubID, famMemberID, familyRelation) VALUES
(9226, 8026, 'other'),
(9227, 8026, 'other'),
(9228, 8026, 'other'),
(9229, 8026, 'other'),
(9230, 8026, 'other');





-- Locations
INSERT INTO Location (location_name, address, city, postalCode, province, tel, website, type, capacity)
VALUES
('Headquarters', '100 Main St', 'Montreal', 'H1A1A1', 'QC', '555-1000', 'www.headquarters.com', 'head', 100), -- 1
('East Branch', '200 East St', 'Montreal', 'H2B2B2', 'QC', '555-2000', 'www.eastbranch.com', 'branch', 80), -- 2
('West Branch', '300 West St', 'Laval', 'H3C3C3', 'QC', '555-3000', 'www.westbranch.com', 'branch', 70), -- 3
('North Branch', '400 North St', 'Laval', 'H4D4D4', 'QC', '555-4000', 'www.northbranch.com', 'branch', 60), -- 4
('South Branch', '500 South St', 'Longueuil', 'H5E5E5', 'QC', '555-5000', 'www.southbranch.com', 'branch', 50); -- 5




-- Admins at locations
INSERT INTO LocationOperatingStaff (locID, staffID, startDate, endDate) VALUES
(5, 1001, '2020-01-01', '2021-01-01'),
(5, 1002, '2020-01-01', '2021-01-01'),
(4, 1003, '2020-01-01', '2021-01-01'),
(4, 1004, '2020-01-01', '2021-01-01'),
(2, 1005, '2020-01-01', '2021-01-01'),
(2, 1006, '2020-01-01', '2021-01-01'),
(3, 1007, '2020-01-01', '2021-01-01'),
(3, 1008, '2020-01-01', '2021-01-01'),
(1, 1009, '2020-01-01', '2021-01-01'),
(1, 1010, '2020-01-01', '2021-01-01');
-- Trainers at locations
INSERT INTO LocationOperatingStaff (locID, staffID, startDate, endDate) VALUES
(5, 2001, '2020-01-01', '2021-01-01'),
(5, 2002, '2020-01-01', '2021-01-01'),
(4, 2003, '2020-01-01', '2021-01-01'),
(4, 2004, '2020-01-01', '2021-01-01'),
(2, 2005, '2020-01-01', '2021-01-01'),
(2, 2006, '2020-01-01', '2021-01-01'),
(3, 2007, '2020-01-01', '2021-01-01'),
(3, 2008, '2020-01-01', '2021-01-01'),
(1, 2009, '2020-01-01', '2021-01-01'),
(1, 2010, '2020-01-01', '2021-01-01');
-- Volunteers at locations with end dates in the past
INSERT INTO LocationOperatingStaff (locID, staffID, startDate, endDate) VALUES
(5, 3001, '2020-01-01', '2021-01-01'),
(4, 3002, '2020-01-01', '2021-01-01'),
(2, 3003, '2020-01-01', '2021-01-01'),
(3, 3004, '2020-01-01', '2021-01-01'),
(1, 3005, '2020-01-01', '2021-01-01');
-- Admins at locations
INSERT INTO LocationOperatingStaff (locID, staffID, startDate, endDate) VALUES
(1, 1001, '2021-01-02', NULL),
(1, 1002, '2021-01-02', NULL),
(2, 1003, '2021-01-02', NULL),
(2, 1004, '2021-01-02', NULL),
(3, 1005, '2021-01-02', NULL),
(3, 1006, '2021-01-02', NULL),
(4, 1007, '2021-01-02', NULL),
(4, 1008, '2021-01-02', NULL),
(5, 1009, '2021-01-02', NULL),
(5, 1010, '2021-01-02', NULL);
-- Trainers at locations
INSERT INTO LocationOperatingStaff (locID, staffID, startDate, endDate) VALUES
(1, 2001, '2021-01-02', NULL),
(1, 2002, '2021-01-02', NULL),
(2, 2003, '2021-01-02', NULL),
(2, 2004, '2021-01-02', NULL),
(3, 2005, '2021-01-02', NULL),
(3, 2006, '2021-01-02', NULL),
(4, 2007, '2021-01-02', NULL),
(4, 2008, '2021-01-02', NULL),
(5, 2009, '2021-01-02', NULL),
(5, 2010, '2021-01-02', NULL);
-- Volunteers at locations
INSERT INTO LocationOperatingStaff (locID, staffID, startDate, endDate) VALUES
(1, 3001, '2021-01-02', NULL),
(2, 3002, '2021-01-02', NULL),
(3, 3003, '2021-01-02', NULL),
(4, 3004, '2021-01-02', NULL),
(5, 3005, '2021-01-02', NULL);





INSERT INTO GeneralManagement (locID, staffID, startDate, endDate) VALUES
(1, 1010, '2020-01-01', '2021-01-01'),
(1, 1001, '2021-01-02', NULL),
(2, 1006, '2020-01-01', '2021-01-01'),
(2, 1003, '2021-01-02', NULL),
(3, 1008, '2020-01-01', '2021-01-01'),
(3, 1005, '2021-01-02', NULL),
(4, 1004, '2020-01-01', '2021-01-01'),
(4, 1007, '2021-01-02', NULL),
(5, 1002, '2020-01-01', '2021-01-01'),
(5, 1009, '2021-01-02', NULL);




-- Current registrations HERE
-- Family members at location 1
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(1, 8001, '2024-01-02', NULL),
(1, 8002, '2024-01-02', NULL),
(1, 8003, '2024-01-02', NULL),
(1, 8004, '2024-01-02', NULL),
(1, 8005, '2024-01-02', NULL);
-- Family members at location 2
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(2, 8006, '2024-01-02', NULL),
(2, 8007, '2024-01-02', NULL),
(2, 8008, '2024-01-02', NULL),
(2, 8009, '2024-01-02', NULL),
(2, 8010, '2024-01-02', NULL);
-- Family members at location 3
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(3, 8011, '2024-01-02', NULL),
(3, 8012, '2024-01-02', NULL),
(3, 8013, '2024-01-02', NULL),
(3, 8014, '2024-01-02', NULL),
(3, 8015, '2024-01-02', NULL);
-- Family members at location 4
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(4, 8016, '2024-01-02', NULL),
(4, 8017, '2024-01-02', NULL),
(4, 8018, '2024-01-02', NULL),
(4, 8019, '2024-01-02', NULL),
(4, 8020, '2024-01-02', NULL);
-- Family members at location 5
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(5, 8021, '2024-01-02', NULL),
(5, 8022, '2024-01-02', NULL),
(5, 8023, '2024-01-02', NULL),
(5, 8024, '2024-01-02', NULL),
(5, 8025, '2024-01-02', NULL);
-- Old registrations for 2020
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(1, 8001, '2020-01-01', '2020-12-31'),
(1, 8006, '2020-01-01', '2020-12-31'),
(1, 8011, '2020-01-01', '2020-12-31'),
(1, 8016, '2020-01-01', '2020-12-31'),
(1, 8021, '2020-01-01', '2020-12-31'),
(2, 8002, '2020-01-01', '2020-12-31'),
(2, 8007, '2020-01-01', '2020-12-31'),
(2, 8012, '2020-01-01', '2020-12-31'),
(2, 8017, '2020-01-01', '2020-12-31'),
(2, 8022, '2020-01-01', '2020-12-31'),
(3, 8003, '2020-01-01', '2020-12-31'),
(3, 8008, '2020-01-01', '2020-12-31'),
(3, 8013, '2020-01-01', '2020-12-31'),
(3, 8018, '2020-01-01', '2020-12-31'),
(3, 8023, '2020-01-01', '2020-12-31'),
(4, 8004, '2020-01-01', '2020-12-31'),
(4, 8009, '2020-01-01', '2020-12-31'),
(4, 8014, '2020-01-01', '2020-12-31'),
(4, 8019, '2020-01-01', '2020-12-31'),
(4, 8024, '2020-01-01', '2020-12-31'),
(5, 8005, '2020-01-01', '2020-12-31'),
(5, 8010, '2020-01-01', '2020-12-31'),
(5, 8015, '2020-01-01', '2020-12-31'),
(5, 8020, '2020-01-01', '2020-12-31'),
(5, 8025, '2020-01-01', '2020-12-31');
-- Old registrations for 2021
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(1, 8001, '2021-01-01', '2021-12-31'),
(2, 8006, '2021-01-01', '2021-12-31'),
(3, 8011, '2021-01-01', '2021-12-31'),
(4, 8016, '2021-01-01', '2021-12-31'),
(5, 8021, '2021-01-01', '2021-12-31'),
(2, 8002, '2021-01-01', '2021-12-31'),
(3, 8007, '2021-01-01', '2021-12-31'),
(4, 8012, '2021-01-01', '2021-12-31'),
(5, 8017, '2021-01-01', '2021-12-31'),
(1, 8022, '2021-01-01', '2021-12-31'),
(3, 8003, '2021-01-01', '2021-12-31'),
(4, 8008, '2021-01-01', '2021-12-31'),
(5, 8013, '2021-01-01', '2021-12-31'),
(1, 8018, '2021-01-01', '2021-12-31'),
(2, 8023, '2021-01-01', '2021-12-31'),
(4, 8004, '2021-01-01', '2021-12-31'),
(5, 8009, '2021-01-01', '2021-12-31'),
(1, 8014, '2021-01-01', '2021-12-31'),
(2, 8019, '2021-01-01', '2021-12-31'),
(3, 8024, '2021-01-01', '2021-12-31'),
(5, 8005, '2021-01-01', '2021-12-31'),
(1, 8010, '2021-01-01', '2021-12-31'),
(2, 8015, '2021-01-01', '2021-12-31'),
(3, 8020, '2021-01-01', '2021-12-31'),
(4, 8025, '2021-01-01', '2021-12-31');
-- Old registrations for 2022
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(1, 8001, '2022-01-01', '2022-12-31'),
(2, 8006, '2022-01-01', '2022-12-31'),
(3, 8011, '2022-01-01', '2022-12-31'),
(4, 8016, '2022-01-01', '2022-12-31'),
(5, 8021, '2022-01-01', '2022-12-31'),
(2, 8002, '2022-01-01', '2022-12-31'),
(3, 8007, '2022-01-01', '2022-12-31'),
(4, 8012, '2022-01-01', '2022-12-31'),
(5, 8017, '2022-01-01', '2022-12-31'),
(1, 8022, '2022-01-01', '2022-12-31'),
(3, 8003, '2022-01-01', '2022-12-31'),
(4, 8008, '2022-01-01', '2022-12-31'),
(5, 8013, '2022-01-01', '2022-12-31'),
(1, 8018, '2022-01-01', '2022-12-31'),
(2, 8023, '2022-01-01', '2022-12-31'),
(4, 8004, '2022-01-01', '2022-12-31'),
(5, 8009, '2022-01-01', '2022-12-31'),
(1, 8014, '2022-01-01', '2022-12-31'),
(2, 8019, '2022-01-01', '2022-12-31'),
(3, 8024, '2022-01-01', '2022-12-31'),
(5, 8005, '2022-01-01', '2022-12-31'),
(1, 8010, '2022-01-01', '2022-12-31'),
(2, 8015, '2022-01-01', '2022-12-31'),
(3, 8020, '2022-01-01', '2022-12-31'),
(4, 8025, '2022-01-01', '2022-12-31');
-- Old registrations for 2022

--special case of a user who switched locations 5 times in the last 2 years: 
INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(1, 8026, '2023-11-01', '2024-01-31'),
(2, 8026, '2024-02-01', '2024-03-31'),
(3, 8026, '2024-04-01', '2024-05-31'),
(4, 8026, '2024-06-01', '2024-06-30'),
(5, 8026, '2024-07-01', NULL);




-- Boys' Teams
INSERT INTO Team (teamID, teamType, teamCoachID, teamLocation) VALUES
(1, 'boys', 2001, 1),
(2, 'boys', 2003, 2),
(3, 'boys', 2005, 3),
(4, 'boys', 2007, 4),
(5, 'boys', 2009, 5);
-- Girls' Teams
INSERT INTO Team (teamID, teamType, teamCoachID, teamLocation) VALUES
(6, 'girls', 2002, 1),
(7, 'girls', 2004, 2),
(8, 'girls', 2006, 3),
(9, 'girls', 2008, 4),
(10, 'girls',2010, 5);




-- Boys on Teams 1 to 5
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9101, 1, 'goalkeeper'),
(9102, 1, 'defender'),
(9103, 1, 'midfielder'),
(9104, 1, 'forward'),
(9105, 1, 'defender'),
(9106, 2, 'goalkeeper'),
(9107, 2, 'defender'),
(9108, 2, 'midfielder'),
(9109, 2, 'forward'),
(9110, 2, 'defender'),
(9111, 3, 'goalkeeper'),
(9112, 3, 'defender'),
(9113, 3, 'midfielder'),
(9114, 3, 'forward'),
(9115, 3, 'defender'),
(9116, 4, 'goalkeeper'),
(9117, 4, 'defender'),
(9118, 4, 'midfielder'),
(9119, 4, 'forward'),
(9120, 4, 'defender'),
(9121, 5, 'goalkeeper'),
(9122, 5, 'defender'),
(9123, 5, 'midfielder'),
(9124, 5, 'forward'),
(9125, 5, 'defender');




-- Girls on Teams 6 to 10
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9201, 6, 'goalkeeper'),
(9202, 6, 'defender'),
(9203, 6, 'midfielder'),
(9204, 6, 'forward'),
(9205, 6, 'defender'),
(9206, 7, 'goalkeeper'),
(9207, 7, 'defender'),
(9208, 7, 'midfielder'),
(9209, 7, 'forward'),
(9210, 7, 'defender'),
(9211, 8, 'goalkeeper'),
(9212, 8, 'defender'),
(9213, 8, 'midfielder'),
(9214, 8, 'forward'),
(9215, 8, 'defender'),
(9216, 9, 'goalkeeper'),
(9217, 9, 'defender'),
(9218, 9, 'midfielder'),
(9219, 9, 'forward'),
(9220, 9, 'defender'),
(9221, 10, 'goalkeeper'),
(9222, 10, 'defender'),
(9223, 10, 'midfielder'),
(9224, 10, 'forward'),
(9225, 10, 'defender');



-- Past Sessions
INSERT INTO Session (teamOneID, teamTwoID, time, scoreOne, scoreTwo, address, type) VALUES
(1, 2, '2023-08-15 10:00:00', 1, 2, '100 Main St', 'game'),
(3, 4, '2023-08-16 11:00:00', 3, 1, '200 East St', 'game'),
(5, 6, '2023-08-17 12:00:00', 2, 2, '300 West St', 'training'),
(7, 8, '2023-08-18 13:00:00', 4, 0, '400 North St', 'game'),
(9, 10, '2023-08-19 14:00:00', 1, 3, '500 South St', 'training'),
(1, 3, '2023-08-20 10:00:00', 2, 1, '100 Main St', 'game'),
(2, 4, '2023-08-21 11:00:00', 1, 1, '200 East St', 'training'),
(5, 7, '2023-08-22 12:00:00', 3, 2, '300 West St', 'game'),
(6, 8, '2023-08-23 13:00:00', 2, 2, '400 North St', 'training'),
(9, 1, '2023-08-24 14:00:00', 4, 1, '500 South St', 'game'),
(2, 3, '2023-08-25 10:00:00', 0, 0, '100 Main St', 'training'),
(4, 5, '2023-08-26 11:00:00', 2, 1, '200 East St', 'game'),
(6, 7, '2023-08-27 12:00:00', 3, 3, '300 West St', 'training'),
(8, 9, '2023-08-28 13:00:00', 1, 4, '400 North St', 'game'),
(1, 4, '2023-08-29 14:00:00', 2, 2, '500 South St', 'training'),
(2, 5, '2023-08-30 10:00:00', 3, 1, '100 Main St', 'game'),
(3, 6, '2023-08-31 11:00:00', 1, 0, '200 East St', 'training'),
(7, 8, '2023-09-01 12:00:00', 2, 3, '300 West St', 'game'),
(9, 1, '2023-09-02 13:00:00', 1, 2, '400 North St', 'training'),
(2, 3, '2023-09-03 14:00:00', 4, 3, '500 South St', 'game');
-- Scheduled Sessions
INSERT INTO Session (teamOneID, teamTwoID, time, scoreOne, scoreTwo, address, type) VALUES
(1, 2, '2024-08-15 10:00:00', NULL, NULL, '100 Main St', 'game'),
(3, 4, '2024-08-16 11:00:00', NULL, NULL, '200 East St', 'game'),
(5, 6, '2024-08-17 12:00:00', NULL, NULL, '300 West St', 'training'),
(7, 8, '2024-08-18 13:00:00', NULL, NULL, '400 North St', 'game'),
(9, 10, '2024-08-19 14:00:00', NULL, NULL, '500 South St', 'training'),
(1, 3, '2024-08-20 10:00:00', NULL, NULL, '100 Main St', 'game'),
(2, 4, '2024-08-21 11:00:00', NULL, NULL, '200 East St', 'training'),
(5, 7, '2024-08-22 12:00:00', NULL, NULL, '300 West St', 'game'),
(6, 8, '2024-08-23 13:00:00', NULL, NULL, '400 North St', 'training'),
(9, 1, '2024-08-24 14:00:00', NULL, NULL, '500 South St', 'game'),
(2, 3, '2024-08-25 10:00:00', NULL, NULL, '100 Main St', 'training'),
(4, 5, '2024-08-26 11:00:00', NULL, NULL, '200 East St', 'game'),
(6, 7, '2024-08-27 12:00:00', NULL, NULL, '300 West St', 'training'),
(8, 9, '2024-08-28 13:00:00', NULL, NULL, '400 North St', 'game'),
(1, 4, '2024-08-29 14:00:00', NULL, NULL, '500 South St', 'training'),
(2, 5, '2024-08-30 10:00:00', NULL, NULL, '100 Main St', 'game'),
(3, 6, '2024-08-31 11:00:00', NULL, NULL, '200 East St', 'training'),
(7, 8, '2024-09-01 12:00:00', NULL, NULL, '300 West St', 'game'),
(9, 1, '2024-09-02 13:00:00', NULL, NULL, '400 North St', 'training'),
(2, 3, '2024-09-03 14:00:00', NULL, NULL, '500 South St', 'game'),
(4, 5, '2024-09-04 10:00:00', NULL, NULL, '100 Main St', 'training'),
(6, 7, '2024-09-05 11:00:00', NULL, NULL, '200 East St', 'game'),
(8, 9, '2024-09-06 12:00:00', NULL, NULL, '300 West St', 'training'),
(1, 2, '2024-09-07 13:00:00', NULL, NULL, '400 North St', 'game'),
(3, 4, '2024-09-08 14:00:00', NULL, NULL, '500 South St', 'training'),
(5, 6, '2024-09-09 10:00:00', NULL, NULL, '100 Main St', 'game');

-- inserts for query 14 only
INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(9231, 'Alphonse', 'Miller', 'M', '2015-05-15', '123456789', 'B12345678901', '123 Main St', 'A1B2C3', 'QC', 'Montreal', '555-1231', 'alice.miller@example.com'),
(9232, 'Bob', 'Smith', 'M', '2016-07-22', '987654321', 'B98765432101', '124 Main St', 'B2C3D4', 'QC', 'Montreal', '555-1232', 'bob.smith@example.com'),
(9233, 'Charlie', 'Johnson', 'M', '2014-09-10', '567890123', 'B56789012301', '125 Main St', 'C3D4E5', 'QC', 'Montreal', '555-1233', 'charlie.johnson@example.com'),
(9234, 'Jackie', 'Brown', 'M', '2015-03-08', '345678901', 'B34567890101', '126 Main St', 'D4E5F6', 'QC', 'Montreal', '555-1234', 'diana.brown@example.com'),
(9235, 'Edward', 'Davis', 'M', '2016-11-30', '789012345', 'B78901234501', '127 Main St', 'E5F6G7', 'QC', 'Montreal', '555-1235', 'edward.davis@example.com');

INSERT INTO ClubMember (clubID, famMemberID, familyRelation) VALUES
(9231, 8001, 'other'),
(9232, 8001, 'other'),
(9233, 8001, 'other'),
(9234, 8001, 'other'),
(9235, 8001, 'other');

INSERT INTO Team (teamID, teamType, teamCoachID, teamLocation) VALUES
(11, 'boys', 2001, 1),
(12, 'boys', 2001, 1),
(13, 'boys', 2001, 1),
(14, 'boys', 2001, 1),
(15, 'boys', 2001, 1);

-- Alice Miller in different roles
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9231, 11, 'goalkeeper'),
(9231, 12, 'defender'),
(9231, 13, 'midfielder'),
(9231, 14, 'forward');

-- Bob Smith in different roles
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9232, 11, 'defender'),
(9232, 12, 'midfielder'),
(9232, 13, 'forward'),
(9232, 14, 'goalkeeper');

-- Charlie Johnson in different roles
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9233, 11, 'midfielder'),
(9233, 12, 'forward'),
(9233, 13, 'goalkeeper'),
(9233, 14, 'defender');

-- Diana Brown in different roles
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9234, 11, 'forward'),
(9234, 12, 'goalkeeper'),
(9234, 13, 'defender'),
(9234, 14, 'midfielder');

-- Edward Davis in different roles
INSERT INTO ClubMemberPartOfTeam (clubID, teamID, roleOnTeam) VALUES
(9235, 11, 'goalkeeper'),
(9235, 12, 'defender'),
(9235, 13, 'midfielder'),
(9235, 14, 'forward');

-- Sessions for the teams
INSERT INTO Session (teamOneID, teamTwoID, time, scoreOne, scoreTwo, address, type) VALUES
(11, 12, '2024-01-10 10:00:00', 1, 2, 'Stadium A', 'game'),
(13, 14, '2024-01-17 10:00:00', 3, 1, 'Stadium A', 'game'),
(11, 13, '2024-02-14 10:00:00', 2, 2, 'Stadium A', 'game'),
(12, 14, '2024-02-21 10:00:00', 0, 3, 'Stadium A', 'game'),
(11, 14, '2024-03-10 10:00:00', 1, 1, 'Stadium A', 'game'),
(12, 13, '2024-03-17 10:00:00', 4, 2, 'Stadium A', 'game'),
(11, 15, '2024-04-14 10:00:00', 2, 0, 'Stadium A', 'game'),
(12, 15, '2024-05-21 10:00:00', 1, 1, 'Stadium A', 'game'),
(13, 15, '2024-06-18 10:00:00', 3, 3, 'Stadium A', 'game'),
(14, 15, '2024-07-10 10:00:00', 1, 0, 'Stadium A', 'game');


-- query 15 inserts

INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(2011, 'John', 'Doe', 'M', '1995-01-15', '193456789', 'c12345678901', '123 Maple St', 'H2X3J1', 'QC', 'Montreal', '555-1111', 'john.doe@example.com'),
(2012, 'James', 'Smith', 'M', '1995-03-22', '934567890', 'c23456789012', '456 Oak St', 'H2X3J2', 'QC', 'Montreal', '555-2222', 'james.smith@example.com'),
(2013, 'Robert', 'Johnson', 'M', '1995-05-30', '945678901', 'c34567890123', '789 Pine St', 'H2X3J3', 'QC', 'Montreal', '555-3333', 'robert.johnson@example.com'),
(2014, 'Michael', 'Brown', 'M', '1995-07-18', '496789012', 'c45678901234', '101 Birch St', 'H2X3J4', 'QC', 'Montreal', '555-4444', 'michael.brown@example.com'),
(2015, 'William', 'Davis', 'M', '1995-09-25', '597890123', 'c56789012345', '202 Cedar St', 'H2X3J5', 'QC', 'Montreal', '555-5555', 'william.davis@example.com');

INSERT INTO FamilyMember (famID, secondaryFamID, secondaryFamRelation) VALUES
(2011, NULL, NULL),
(2012, NULL, NULL),
(2013, NULL, NULL),
(2014, NULL, NULL),
(2015, NULL, NULL);

INSERT INTO Personnel (staffID, role, mandate) VALUES
(2011, 'trainer', 'salary'),
(2012, 'trainer', 'salary'),
(2013, 'trainer', 'salary'),
(2014, 'trainer', 'salary'),
(2015, 'trainer', 'salary');

INSERT INTO Users (userID, firstName, lastName, gender, dateOfBirth, SSN, medicare, address, postalCode, province, city, phone, email) VALUES
(9140, 'Tom', 'Doe', 'M', '2018-01-15', '678901234', 'd67890123456', '321 Elm St', 'H2X4J1', 'QC', 'Montreal', '555-6666', 'tom.doe@example.com'),
(9141, 'Harry', 'Smith', 'M', '2018-03-22', '789712345', 'd78901234567', '654 Spruce St', 'H2X4J2', 'QC', 'Montreal', '555-7777', 'harry.smith@example.com'),
(9142, 'Jack', 'Johnson', 'M', '2018-05-30', '897123456', 'd89012345678', '987 Fir St', 'H2X4J3', 'QC', 'Montreal', '555-8888', 'jack.johnson@example.com'),
(9143, 'Oliver', 'Brown', 'M', '2018-07-18', '971234567', 'd90123456789', '210 Walnut St', 'H2X4J4', 'QC', 'Montreal', '555-9999', 'oliver.brown@example.com'),
(9144, 'Charlie', 'Davis', 'M', '2018-09-25', '712345678', 'd01234567890', '543 Ash St', 'H2X4J5', 'QC', 'Montreal', '555-0000', 'charlie.davis@example.com');

INSERT INTO ClubMember (clubID, famMemberID, familyRelation) VALUES
(9140, 2011, 'father'),
(9141, 2012, 'father'),
(9142, 2013, 'father'),
(9143, 2014, 'father'),
(9144, 2015, 'father');

INSERT INTO RegistrationAtLocation (locID, famID, startDate, endDate) VALUES
(2, 2011, '2023-01-01', NULL),
(2, 2012, '2023-01-01', NULL),
(2, 2013, '2023-01-01', NULL),
(2, 2014, '2023-01-01', NULL),
(2, 2015, '2023-01-01', NULL);

INSERT INTO Team (teamID, teamType, teamCoachID, teamLocation) VALUES
(20, 'boys', 2011, 2),
(21, 'boys', 2012, 2),
(22, 'boys', 2013, 2),
(23, 'boys', 2014, 2),
(24, 'boys', 2015, 2);



DELIMITER // -- temporary changes the delimiter to //

-- trigger for club members -> their age must be between 4 and 10 at registration
CREATE TRIGGER ClubMemberAgeTrigger
BEFORE INSERT ON ClubMember
FOR EACH ROW  -- for each row being inserted
BEGIN
    DECLARE age INT;
    DECLARE dob DATE;
    SELECT U.dateOfBirth INTO dob FROM Users AS U WHERE U.userID = NEW.clubID;
    SET age = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    IF age < 4 OR age > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Club members must be between 4 and 10 years old.';
    END IF;
END;
//

-- this trigger makes sure the ssn is well - defined for any personnel inserted
CREATE TRIGGER ensure_employee_ssn_t
BEFORE INSERT ON Personnel
FOR EACH ROW
BEGIN
    DECLARE socialIns CHAR(9);
    SELECT U.SSN INTO socialIns FROM Users AS U WHERE U.userID = NEW.staffID;
    IF socialIns IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SSN must be entered for all Personnels!';
    END IF;
END;
//


-- trigger to make sure a worker only works at one location at a time, cant be assigned to multiple
CREATE TRIGGER ensure_one_personnel_per_loc_t
BEFORE INSERT ON LocationOperatingStaff
FOR EACH ROW
BEGIN
    DECLARE currentWorkplace INTEGER;
    SELECT LOS.locID 
    INTO currentWorkplace 
    FROM LocationOperatingStaff AS LOS 
    WHERE LOS.staffID = NEW.staffID AND LOS.endDate IS NULL; -- if endDate is null, means he / she works somewhere
    IF currentWorkplace IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An employee can work at a single location at a time only!';
    END IF;
END;
//


-- this trigger is to make sure the general manager of a location is assigned to the same location in the LOS table
CREATE TRIGGER main_employee_compliance_t
BEFORE INSERT ON GeneralManagement
FOR EACH ROW
BEGIN
    DECLARE assignedLoc INTEGER;
    SELECT LOS.locID
    INTO assignedLoc
    FROM LocationOperatingStaff LOS
    WHERE LOS.staffID = NEW.staffID AND LOS.locID = NEW.locID AND LOS.endDate IS NULL;
    IF assignedLoc IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A general manager must be associated with the same location in the LOS table first!';
    END IF;
END;
//

-- ensures only one active manager per location in GeneralManagement
CREATE TRIGGER ensure_single_manager_insert_t
BEFORE INSERT ON GeneralManagement
FOR EACH ROW
BEGIN
    -- Check if there is another active manager at the same location
    IF NEW.endDate IS NULL AND 
       EXISTS (
           SELECT 1 
           FROM GeneralManagement 
           WHERE locID = NEW.locID 
           AND endDate IS NULL 
           AND (staffID != NEW.staffID OR NEW.staffID IS NULL)
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an active manager at this location';
    END IF;
END;
//

-- only one active manager per location in GeneralManagement during update
CREATE TRIGGER ensure_single_manager_update_t
BEFORE UPDATE ON GeneralManagement
FOR EACH ROW
BEGIN
    -- Check if there is another active manager at the same location
    -- Check if the new state of the row being updated would violate the single active manager constraint
    IF NEW.endDate IS NULL AND 
       EXISTS (
           SELECT 1 
           FROM GeneralManagement 
           WHERE locID = NEW.locID 
           AND endDate IS NULL 
           AND (staffID != NEW.staffID OR NEW.staffID IS NULL)
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an active manager at this location';
    END IF;
END;
//


CREATE TRIGGER ensure_single_manager_insert
BEFORE INSERT ON GeneralManagement
FOR EACH ROW
BEGIN
    -- Check if the new state of the row being updated would violate the single active manager constraint
    IF NEW.endDate IS NULL AND 
       EXISTS (
           SELECT 1 
           FROM GeneralManagement 
           WHERE locID = NEW.locID 
           AND endDate IS NULL 
           AND staffID <> NEW.staffID
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an active manager at this location';
    END IF;
END
//


-- this trigger will make sure that the team and the club member belong to the same location only
CREATE TRIGGER ensure_team_same_location_t
BEFORE INSERT ON ClubMemberPartOfTeam
FOR EACH ROW
BEGIN
    DECLARE playerLocID INTEGER;
    DECLARE teamLocID INTEGER;
    -- finding which location the player is currently associated with
    SELECT L.locID
    INTO playerLocID
    FROM ClubMember CM
        INNER JOIN FamilyMember F ON CM.famMemberID = F.famID
        INNER JOIN RegistrationAtLocation RL ON F.famID = RL.famID
        INNER JOIN Location L ON RL.locID = L.locID
    WHERE CM.clubID = NEW.clubID AND RL.endDate IS NULL;
    -- finding which location the team is currently associated with
    SELECT T.teamLocation
    INTO teamLocID
    FROM Team T
    WHERE NEW.teamID = T.teamID;
    IF playerLocID <> teamLocID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Club Member Must be associated with the same location as the team to be assigned!';
    END IF;
END;
//

-- this trigger is self-explanatory, we need boys with boys and girls with girls on the same team...
CREATE TRIGGER ensure_same_gender_on_team_t
BEFORE INSERT ON ClubMemberPartOfTeam
FOR EACH ROW
BEGIN
    DECLARE newMemberGender CHAR(1);
    DECLARE teamGender VARCHAR(5);
    -- time to find what gender is our new team member, it's a single ascii char either a capital M or F
    SELECT U.gender
    INTO newMemberGender
    FROM ClubMember CM
        INNER JOIN Users U ON U.userID = CM.clubID
    WHERE CM.clubID = NEW.clubID;
    -- time to find if our team is for boys or girls...
    SELECT T.teamType
    INTO teamGender
    FROM Team T
    WHERE T.teamID = NEW.teamID;
    IF ((teamGender = 'boys' AND newMemberGender = 'F') OR (teamGender = 'girls' AND newMemberGender = 'M')) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only same-gender club members can be assigned on the same team!';
    END IF;
END;

-- procedure + trigger to make sure the sessions for the same teams are scheduled 3h apart
CREATE PROCEDURE check_session_schedule_f(IN newTeamID INT, IN newTime TIMESTAMP)
BEGIN
    DECLARE sessionCount INT;
    -- checking if the team has sessions less than 3 hours apart
    SELECT COUNT(*)
    INTO sessionCount
    FROM (
        SELECT teamOneID AS teamID, time
        FROM Session
        WHERE teamOneID = newTeamID
        UNION ALL
        SELECT teamTwoID AS teamID, time
        FROM Session
        WHERE teamTwoID = newTeamID
    ) AS sessions
    WHERE ABS(TIMESTAMPDIFF(HOUR, sessions.time, newTime)) < 3;
    IF sessionCount > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot schedule a session less than 3 hours apart from another session for the same team';
    END IF;
END 
//

-- procedure ^^^ above being called in the trig here 
CREATE TRIGGER before_insert_session_t
BEFORE INSERT ON Session
FOR EACH ROW
BEGIN
    CALL check_session_schedule_f(NEW.teamOneID, NEW.time);
    CALL check_session_schedule_f(NEW.teamTwoID, NEW.time);
END 
//

CREATE TRIGGER check_session_conflicts_for_member_T
BEFORE INSERT ON ClubMemberPartOfTeam
FOR EACH ROW
BEGIN
    DECLARE conflicting_sessions_count INT;
    -- Check if there are sessions within 3 hours of each other for the specified club member
    SELECT COUNT(*) INTO conflicting_sessions_count
    -- not my query fully, but i polished it a lot 
    -- what this does: s1 is any session already scheduled for a club member
    -- s2 is any session for the team we are adding the member to
    -- it does a complete cross product
    -- then eliminates them, if count > 1 then trigger is executed, inserting fails
    FROM (
        SELECT s1.time AS session1_time, s2.time AS session2_time
        FROM Session s1, Session s2
        WHERE 
                (s1.teamOneID IN 
                    (SELECT teamID FROM ClubMemberPartOfTeam WHERE clubID = NEW.clubID) OR 
                s1.teamTwoID IN 
                    (SELECT teamID FROM ClubMemberPartOfTeam WHERE clubID = NEW.clubID)) 
                    AND
                (s2.teamOneID = NEW.teamID OR s2.teamTwoID = NEW.teamID) AND
                ABS(TIMESTAMPDIFF(HOUR, s1.time, s2.time)) <= 3
    ) AS session_conflicts;
    IF conflicting_sessions_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert club member into team: sessions are scheduled within 3 hours of each other.';
    END IF;
END 
//
 -- Added team name attribute in team

 -- Q7)
CREATE PROCEDURE `all_location`()
BEGIN
SELECT DISTINCT
        L.address,
        L.city,
        L.province,
        L.postalCode,
        L.tel,
        L.website,
        L.type,
        L.capacity,
        U.firstName,
        COUNT(DISTINCT CM.clubID) AS No_of_ClubMembers
    FROM
        Location L
    INNER JOIN
        GeneralManagement GM ON L.locID = GM.locID
    INNER JOIN
        Personnel P ON P.staffID = GM.staffID
    INNER JOIN
        Users U ON U.userID = P.staffID
    INNER JOIN
        RegistrationAtLocation REG ON REG.locID = L.locID
    INNER JOIN
        ClubMember CM ON CM.famMemberID = REG.famID
    WHERE
        P.role = 'admin' AND GM.endDate is NULL
    GROUP BY
        L.address,
        L.city,
        L.province,
        L.postalCode,
        L.tel,
        L.website,
        L.type,
        L.capacity,
        U.firstName
    ORDER BY
        L.province ASC,
        L.city ASC;
END//

-- Q8) 
CREATE PROCEDURE `Q8`(in famID int)
BEGIN
    SELECT 
        FM.famID as fm_famID,
        FM.secondaryFamRelation as fm_relation,
        SF.secondaryFamID as sf_id,
        SF.firstName as sf_first_name,
        SF.lastName as sf_last_name,
        SF.phone as sf_phone,
        CM.clubID as cm_id,
        U.firstName AS u_firstname,
        U.lastName as u_lastname,
        U.dateOfBirth as u_dob,
        U.SSN as u_ssn,
        U.medicare as u_medicare,
        U.address as u_address,
        U.postalCode,
        U.province,
        U.city,
        U.phone 
    FROM FamilyMember FM
    INNER JOIN ClubMember CM ON CM.famMemberID = FM.famID
    INNER JOIN Users U ON U.userID = CM.clubID
    LEFT JOIN SecondaryFamilyMember SF ON SF.secondaryFamID = FM.secondaryFamID
    Where FM.famID = famID;
END//

-- Q9) 
CREATE PROCEDURE `Q9`(in locID int, in date DATE)
BEGIN
SELECT
    uCoach.firstName AS coachFirstName,
    uCoach.lastName AS coachLastName,
    s.time AS startTime,
    s.address AS Address,
    s.type AS Type,
    l.location_name,
    CT.roleOnTeam,
    CASE
        WHEN s.time <= NOW() THEN CONCAT(s.scoreOne, '-', s.scoreTwo)
        ELSE NULL
    END AS score,
    uPlayer.firstName AS playerFirstName,
    uPlayer.lastName AS playerLastName
FROM
    Location l
    INNER JOIN Team t ON t.teamLocation = l.locID
    INNER JOIN Users uCoach ON uCoach.userID = t.teamCoachID
    INNER JOIN Session s ON (t.teamID = s.teamOneID OR t.teamID = s.teamTwoID)
    INNER JOIN ClubMemberPartOfTeam CT ON CT.teamID = t.teamID
    INNER JOIN Users uPlayer ON uPlayer.userID = CT.clubID
WHERE
    l.locID =locID
    AND DATE(s.time) = date
ORDER BY
    s.time ASC;
END//


 -- Q10)
CREATE PROCEDURE `Q10`()
BEGIN
SELECT C.clubID, U.firstName, U.lastName
FROM ClubMember C
INNER JOIN FamilyMember FM ON C.famMemberID = FM.famID
INNER JOIN RegistrationAtLocation R ON FM.famID = R.famID
INNER JOIN Users U ON C.clubID = U.userID
WHERE 
  TIMESTAMPDIFF(YEAR, U.dateOfBirth, CURRENT_DATE) BETWEEN 4 AND 10
GROUP BY C.clubID, U.firstName, U.lastName
HAVING 
    MIN(R.startDate) >= CURDATE() - INTERVAL 2 YEAR AND
    COUNT(DISTINCT R.locID) >= 4
ORDER BY C.clubID ASC;
END//


 -- Q11)
CREATE PROCEDURE `Q11`(
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
SELECT
    L.location_name,
    COUNT(DISTINCT CASE WHEN S.type = 'training' THEN S.time END) AS total_training_sessions,
    COUNT(DISTINCT CASE WHEN S.type = 'training' THEN CM.clubID END) AS total_training_players,
    COUNT(DISTINCT CASE WHEN S.type = 'game' THEN S.time END) AS total_game_sessions,
    COUNT(DISTINCT CASE WHEN S.type = 'game' THEN CM.clubID END) AS total_game_players
FROM
    Location L
    JOIN Team T ON L.locID = T.teamLocation
    JOIN Session S ON (T.teamID = S.teamOneID OR T.teamID = S.teamTwoID)
    JOIN ClubMemberPartOfTeam CMT ON (T.teamID = CMT.teamID)
    JOIN ClubMember CM ON (CMT.clubID = CM.clubID)
WHERE
    DATE(S.time) BETWEEN startDate AND endDate
GROUP BY
    L.location_name
HAVING
    total_game_sessions >= 3
ORDER BY
    total_game_sessions DESC;
END //

-- Q12)
CREATE PROCEDURE `Q12`()
BEGIN
    SELECT DISTINCT
      CM.clubID AS ClubMembershipNumber,
      U.firstName AS firstName,
      U.lastName AS lastName,
      YEAR(CURDATE()) - YEAR(U.dateOfBirth) AS age,
      U.phone,
      U.email,
      L.location_name AS LocationName
    FROM
      ClubMember CM
      INNER JOIN RegistrationAtLocation REG ON CM.famMemberID = REG.famID
      INNER JOIN Location L ON L.locID = REG.locID
      INNER JOIN Users U ON CM.clubID = U.userID
      LEFT JOIN  ClubMemberPartOfTeam CT ON CM.clubID = CT.clubID
      LEFT JOIN Session S ON (S.teamOneID = CT.teamID OR S.teamTwoID = CT.teamID)
    WHERE 
      YEAR(CURDATE()) - YEAR(U.dateOfBirth) BETWEEN 4 AND 10 AND
      REG.endDate IS NULL AND
      (CT.teamID IS NULL OR
      (S.teamOneID IS NULL AND S.teamTwoID IS NULL))
    ORDER BY
      L.location_name ASC, U.userID ASC;
END//

-- Q13
CREATE PROCEDURE `Q13`()
BEGIN
  WITH Goalkeepers AS
  (
      SELECT
        CM1.clubID
      FROM ClubMember CM1
        INNER JOIN ClubMemberPartOfTeam CMT1 ON CMT1.clubID = CM1.clubID
        INNER JOIN Session S1 ON (CMT1.teamID = S1.teamOneID OR CMT1.teamID = S1.teamTwoID)
      WHERE
        CMT1.roleOnTeam = 'goalkeeper'
      GROUP BY CM1.clubID
      HAVING COUNT(DISTINCT roleOnTeam) = 1
    )
   SELECT DISTINCT
    U.userID AS ClubMembership,
    U.firstName AS firstName, 
    U.lastName AS lastName,
    YEAR(CURDATE()) - YEAR(U.dateOfBirth) AS age,
    U.phone AS phone,
    U.email AS email,
    L.location_name AS LocationName
   FROM Goalkeepers G
    INNER JOIN Users U ON U.userID = G.clubID
    INNER JOIN ClubMember CM ON CM.clubID = G.clubID
    INNER JOIN FamilyMember FM ON FM.famID = CM.famMemberID
    INNER JOIN RegistrationAtLocation REG ON REG.famID = FM.famID
    INNER JOIN Location L ON L.locID = REG.locID
   WHERE
    (YEAR(CURDATE()) - YEAR(U.dateOfBirth) BETWEEN 4 AND 10) AND
    (REG.endDate IS NULL);
END
//

-- Q14)
CREATE PROCEDURE `Q14`()
BEGIN
    WITH AllRoles AS (
        SELECT
            CM.clubID,
            CMT.roleOnTeam
        FROM
            ClubMember CM
            INNER JOIN ClubMemberPartOfTeam CMT ON CM.clubID = CMT.clubID
        GROUP BY CM.clubID, CMT.roleOnTeam
    ),
    DistinctRoles AS (
        SELECT
            clubID
        FROM
            AllRoles
        GROUP BY
            clubID
        HAVING
            COUNT(DISTINCT roleOnTeam) = 4
    )
    SELECT DISTINCT
        U.userID AS ClubMembershipNumber,
        U.firstName AS firstName,
        U.lastName AS lastName,
        YEAR(CURDATE()) - YEAR(U.dateOfBirth) AS age,
        U.phone AS phone,
        U.email AS email,
        L.location_name AS LocationName
    FROM
        DistinctRoles DR
        INNER JOIN Users U ON U.userID = DR.clubID
        INNER JOIN ClubMember CM ON CM.clubID = DR.clubID
        INNER JOIN FamilyMember FM ON FM.famID = CM.famMemberID
        INNER JOIN RegistrationAtLocation REG ON REG.famID = FM.famID
        INNER JOIN Location L ON L.locID = REG.locID
    WHERE
        (REG.endDate IS NULL) AND
        (YEAR(CURDATE()) - YEAR(U.dateOfBirth) BETWEEN 4 AND 10)
    ORDER BY
        L.location_name ASC,
        U.userID ASC;
END //

-- Q15)
CREATE PROCEDURE `Q15`(IN locationID INTEGER)
BEGIN
    SELECT DISTINCT
        U.firstName,
        U.lastName,
        U.phone
    FROM
        FamilyMember FM
        INNER JOIN ClubMember CM ON FM.famID = CM.famMemberID
        INNER JOIN Users U ON FM.famID = U.userID
        INNER JOIN Personnel P ON P.staffID = U.userID
        INNER JOIN Team T ON T.teamCoachID = P.staffID
        INNER JOIN RegistrationAtLocation REG ON REG.famID = FM.famID
    WHERE
        T.teamLocation = locationID
        AND REG.endDate IS NULL
        AND P.role = 'trainer'
    ORDER BY
        U.lastName ASC,
        U.firstName ASC;
END //

-- Q16) 
CREATE PROCEDURE `Q16`()
BEGIN
    SELECT DISTINCT
        U.userID AS ClubMembershipNumber,
        U.firstName AS firstName,
        U.lastName AS lastName,
        YEAR(CURDATE()) - YEAR(U.dateOfBirth) AS age,
        U.phone AS phone,
        U.email AS email,
        L.location_name AS LocationName
    FROM
        Users U
        INNER JOIN ClubMember CM ON U.userID = CM.clubID
        INNER JOIN FamilyMember FM ON CM.famMemberID = FM.famID
        INNER JOIN RegistrationAtLocation R ON FM.famID = R.famID
        INNER JOIN Location L ON R.locID = L.locID
        INNER JOIN ClubMemberPartOfTeam CMT ON CM.clubID = CMT.clubID
        INNER JOIN Session S ON CMT.teamID IN (S.teamOneID, S.teamTwoID)
    WHERE
        R.endDate IS NULL
        AND (
            (S.teamOneID = CMT.teamID AND S.scoreOne > S.scoreTwo)
            OR (S.teamTwoID = CMT.teamID AND S.scoreTwo > S.scoreOne)
        )
        AND CM.clubID NOT IN (
            SELECT CM1.clubID
            FROM
                ClubMember CM1
                INNER JOIN ClubMemberPartOfTeam CMT1 ON CM1.clubID = CMT1.clubID
                INNER JOIN Session S1 ON CMT1.teamID IN (S1.teamOneID, S1.teamTwoID)
            WHERE
                (S1.teamOneID = CMT1.teamID AND S1.scoreOne < S1.scoreTwo)
                OR (S1.teamTwoID = CMT1.teamID AND S1.scoreTwo < S1.scoreOne)
        )
    ORDER BY
        L.location_name ASC,
        U.userID ASC;
END //

-- Q17)
CREATE PROCEDURE `Q17`()
BEGIN
    SELECT
        U.firstName,
        U.lastName,
        GM.startDate AS startDateAsPresident,
        GM.endDate AS lastDateAsPresident
    FROM
        Users U
        INNER JOIN Personnel P ON U.userID = P.staffID
        INNER JOIN GeneralManagement GM ON P.staffID = GM.staffID
    WHERE
        GM.locID = 1
    ORDER BY
        U.firstName ASC,
        U.lastName ASC,
        GM.startDate ASC;
END //


-- Q18) 
CREATE PROCEDURE Q18()
BEGIN
    SELECT DISTINCT
        U.firstName,
        U.lastName,
        U.phone,
        U.email,
        L.location_name AS currentLocationName,
        P.role AS currentRole
    FROM
        Users U
        INNER JOIN Personnel P ON U.userID = P.staffID
        LEFT JOIN LocationOperatingStaff LOS ON P.staffID = LOS.staffID
        LEFT JOIN Location L ON LOS.locID = L.locID
    WHERE
        P.mandate = 'volunteer' AND
        P.staffID NOT IN (
            SELECT DISTINCT FM.famID
            FROM FamilyMember FM
            INNER JOIN ClubMember CM ON FM.famID = CM.famMemberID
        )
        AND
        (LOS.endDate IS NULL)
    ORDER BY
        L.location_name ASC,
        P.role ASC,
        U.firstName ASC,
        U.lastName ASC;
END //


-- Email procedure to get all the info needed to write the email

CREATE PROCEDURE `EmailInfo`(in date DATE)
BEGIN
SELECT 
	U1.firstName as first_name,
	U1.lastName as last_name,
	U1.email as email,
	CMP.roleOnTeam as role,
	U2.firstName as coach_first_name,
	U2.lastName as coach_last_name,
	U2.email as coach_email,
	S.time as session_time,
        S.type as session_type,
        S.address as session_address,
        T.teamID as teamID,
        L.location_name as location_name
FROM ClubMember as CM
INNER JOIN ClubMemberPartOfTeam as CMP ON CMP.clubID = CM.clubID
INNER JOIN Team as T ON CMP.teamID = T.teamID
INNER JOIN Location as L ON L.locID = T.teamLocation
INNER JOIN Users as U1 ON U1.userID = CM.clubID
INNER JOIN Users as U2 ON U2.userID = T.teamCoachID
INNER JOIN Session as S ON (T.teamID = S.teamOneID or T.teamID = S.teamTwoID) and 
	DATE(S.time) BETWEEN date and DATE_ADD(date, INTERVAL 7 DAY)
GROUP BY CM.clubID;
END//

CREATE PROCEDURE `EmailInfoPrevious`()
BEGIN
SELECT 
	U1.firstName as first_name,
	U1.lastName as last_name,
	U1.email as email,
	CMP.roleOnTeam as role,
	U2.firstName as coach_first_name,
	U2.lastName as coach_last_name,
	U2.email as coach_email,
	S.time as session_time,
        S.type as session_type,
        S.address as session_address,
        T.teamID as teamID,
        L.location_name as location_name
FROM ClubMember as CM
INNER JOIN ClubMemberPartOfTeam as CMP ON CMP.clubID = CM.clubID
INNER JOIN Team as T ON CMP.teamID = T.teamID
INNER JOIN Location as L ON L.locID = T.teamLocation
INNER JOIN Users as U1 ON U1.userID = CM.clubID
INNER JOIN Users as U2 ON U2.userID = T.teamCoachID
INNER JOIN Session as S ON (T.teamID = S.teamOneID or T.teamID = S.teamTwoID) and 
	DATE(S.time) < CURRENT_DATE()
GROUP BY CM.clubID;
END//

DELIMITER ;

