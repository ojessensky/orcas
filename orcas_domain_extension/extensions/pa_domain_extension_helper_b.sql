create or replace package body pa_domain_extension_helper is
  function is_equal( p_val1 number, p_val2 number ) return number
  is
  begin
    if( p_val1 is null and p_val2 is null )
    then
      return 1;
    end if;
    if( p_val1 is null or p_val2 is null )
    then
      return 0;
    end if;
    if( p_val1 = p_val2 )
    then
      return 1;
    else
      return 0;
    end if;
  end; 
  
  function is_equal( p_val1 number, p_val2 number, p_default number ) return number
  is
  begin
    if( p_val1 is null and p_val2 is null )
    then
      return 1;
    end if;
    if( nvl(p_val1,p_default) = nvl(p_val2,p_default) )
    then
      return 1;
    else
      return 0;
    end if;
  end;   
  
  function is_equal( p_val1 varchar2, p_val2 varchar2 ) return number
  is
  begin
    if( p_val1 is null and p_val2 is null )
    then
      return 1;
    end if;
    if( p_val1 is null or p_val2 is null )
    then
      return 0;
    end if;
    if( p_val1 = p_val2 )
    then
      return 1;
    else
      return 0;
    end if;
  end;
  
  function is_equal_ignore_case( p_val1 varchar2, p_val2 varchar2 ) return number
  is
  begin
    return is_equal( upper(p_val1), upper(p_val2) );
  end;   

  function get_generated_name( p_gennamerule_list in ct_syex_gennamerule_list, p_column_name in varchar2, p_column_domain_name in varchar2, p_table_name in varchar2, p_alias in varchar2 ) return varchar2
  is
    v_return varchar2(100) := '';
  begin
    for i in 1..p_gennamerule_list.count
    loop
      v_return := v_return || p_gennamerule_list(i).i_constant_name;
      if( ot_syex_gennamerulepart.is_equal( p_gennamerule_list(i).i_constant_part, ot_syex_gennamerulepart.c_column_name ) = 1 )
      then
        if( p_column_name is null )
        then
          raise_application_error( -20000, 'p_column_name invalid' || p_alias || p_table_name );
        end if;
        v_return := v_return || p_column_name;
      end if;
      if( ot_syex_gennamerulepart.is_equal( p_gennamerule_list(i).i_constant_part, ot_syex_gennamerulepart.c_column_domain_name ) = 1 )
      then
        if( p_column_domain_name is null )
        then
          raise_application_error( -20000, 'p_column_domain_name invalid' || p_column_name || p_table_name );
        end if;      
        v_return := v_return || p_column_domain_name;
      end if;
      if( ot_syex_gennamerulepart.is_equal( p_gennamerule_list(i).i_constant_part, ot_syex_gennamerulepart.c_table_name ) = 1 )
      then
        if( p_table_name is null )
        then
          raise_application_error( -20000, 'p_table_name invalid' || p_column_name || p_alias );
        end if;      
        v_return := v_return || p_table_name;
      end if;
      if( ot_syex_gennamerulepart.is_equal( p_gennamerule_list(i).i_constant_part, ot_syex_gennamerulepart.c_alias_name ) = 1 )
      then
        v_return := v_return || p_alias;
      end if;
    end loop;

    return v_return;
  end;   
  
  function get_generated_name_table( p_gennamerule_list in ct_syex_gennamerule_list, p_table_name in varchar2, p_alias in varchar2 ) return varchar2
  is
  begin
    return get_generated_name( p_gennamerule_list, null, null, p_table_name, p_alias );
  end;
    
  function get_generated_name_column( p_gennamerule_list in ct_syex_gennamerule_list, p_column_name in varchar2, p_table_name in varchar2, p_alias in varchar2 ) return varchar2
  is
  begin
    return get_generated_name( p_gennamerule_list, p_column_name, null, p_table_name, p_alias );
  end;  

  function get_generated_name_col_domain( p_gennamerule_list in ct_syex_gennamerule_list, p_column_domain_name in varchar2 ) return varchar2
  is
  begin
    return get_generated_name( p_gennamerule_list, null, p_column_domain_name, null, null );
  end;    
end;
/
