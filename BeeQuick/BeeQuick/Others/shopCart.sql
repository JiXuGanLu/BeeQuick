CREATE TABLE IF NOT EXISTS "T_ShopCart" (
    "id" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "goodModel" TEXT,
    "type" INTEGER,
    "count" INTEGER,
    "selected" INTEGER,
    PRIMARY KEY("id","userId")
);
