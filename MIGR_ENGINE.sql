create or replace PACKAGE BODY MIGR_ENGINE
IS
  PROCEDURE transform_address
  IS
   v_iso_2 varchar2(3);
  BEGIN
   delete from migr_address;
   commit;
   for a in (select id, street, building_no, country, postal_code, city
   from bank_a_address) loop
     select iso_2
       into v_iso_2
       from country_iso
       where country_name=a.country;
     if lower(a.country)='poland' then
       insert into migr_address values('A_'||a.id,a.street,a.building_no,v_iso_2,substr(replace(a.postal_code,'-',''),1,2)||'-'||substr(replace(a.postal_code,'-',''),3,3),a.city);
     else
       insert into migr_address values('A_'||a.id,a.street,a.building_no,v_iso_2,a.postal_code,a.city);
     end if;
   end loop;
   for b in (select id, street, building_no, country, postal_code, city
   from bank_b_address) loop
     select iso_2
       into v_iso_2
       from country_iso
       where country_name=b.country;
     if lower(b.country)='poland' then
       insert into migr_address values('B_'||b.id,b.street,b.building_no,v_iso_2,substr(replace(b.postal_code,'-',''),1,2)||'-'||substr(replace(b.postal_code,'-',''),3,3),b.city);
     else
       insert into migr_address values('B_'||b.id,b.street,b.building_no,v_iso_2,b.postal_code,b.city);
     end if;
   end loop;
  EXCEPTION 
   WHEN OTHERS THEN
    dbms_output.put_line('ADDRESS: Error message: ' || SQLERRM);
  END transform_address;

END;