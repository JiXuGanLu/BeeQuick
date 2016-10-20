CREATE TABLE IF NOT EXISTS "T_CollectionGoods" (
    "id" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "goodModel" TEXT,
    PRIMARY KEY("id","userId")
);
