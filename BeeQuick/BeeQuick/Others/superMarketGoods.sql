CREATE TABLE IF NOT EXISTS "T_SuperMarketGoods" (
        "id" INTEGER NOT NULL,
        "category_id" INTEGER NOT NULL,
        "child_cid" INTEGER,
        "goodModel" TEXT,
        "price" REAL,
        PRIMARY KEY("id","category_id")
);
