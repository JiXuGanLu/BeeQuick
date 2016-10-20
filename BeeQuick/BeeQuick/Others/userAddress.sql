CREATE TABLE IF NOT EXISTS "T_UserAddress" (
    "userId" INTEGER NOT NULL,
    "creatTime" INTEGER NOT NULL,
    "userAddressModel" TEXT,
    "selected" INTEGER,
    PRIMARY KEY("creatTime","userId")
);
