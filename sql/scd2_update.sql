-- Type 2 SCD Maintenance

-- Update the status, end date -- Add effective_date, expiration_date, current_flag columns
ALTER TABLE menu_dim
ADD (
    effective_date DATE DEFAULT TO_DATE('01/09/2014', 'DD/MM/YYYY'),
    expiration_date DATE DEFAULT TO_DATE('31/12/9999', 'DD/MM/YYYY'),
    current_flag NUMBER(1) DEFAULT 1
);

-- Procedure to insert updated menu record
CREATE OR REPLACE PROCEDURE prc_update_menu (
    i_menuid IN VARCHAR2,
    i_itemprice IN NUMBER,
    i_effective_date IN DATE
) IS
    v_menukey        NUMBER;
    v_MENUID         VARCHAR2(4);
    v_ITEMNAME       VARCHAR2(40);
    v_ITEMPRICE      NUMBER(5,2);
    v_CATEGORY       VARCHAR2(20);
    v_CUISINETYPE    VARCHAR2(15);
    v_effective_date DATE;
    v_expiration_date DATE;
    v_current_flag   NUMBER(1);
BEGIN
    SELECT menu_key, menuID, itemName, itemPrice, category, cuisineType, 
           effective_date, expiration_date, current_flag
    INTO v_menukey, v_MENUID, v_ITEMNAME, v_ITEMPRICE, v_CATEGORY, v_CUISINETYPE, 
         v_effective_date, v_expiration_date, v_current_flag
    FROM menu_dim
    WHERE menuID = i_menuid
    AND current_flag = 1;

    UPDATE menu_dim
    SET expiration_date = i_effective_date - 1,
        current_flag = 0
    WHERE menu_key = v_menukey;

    INSERT INTO menu_dim VALUES (
        menu_dim_seq.NEXTVAL,
        v_MENUID,
        v_ITEMNAME,
        i_itemprice,
        v_CATEGORY,
        v_CUISINETYPE,
        i_effective_date,
        TO_DATE('31/12/9999', 'DD/MM/YYYY'),
        1
    );
END;
/

-- 2.3.2 Insert new row
EXEC prc_update_menu('M001', 1.7, TO_DATE('01/01/2017', 'DD/MM/YYYY'));
EXEC prc_update_menu('M002', 1.6, TO_DATE('01/01/2017', 'DD/MM/YYYY'));
EXEC prc_update_menu('M003', 2.4, TO_DATE('01/01/2017', 'DD/MM/YYYY'));
